using FormalInterlocking.Model;

static partial class BWriter
{
  public static void WriteGraph(Specification spec, Graph graph, EntityType entityType, string outputPath)
  {
    if (graph == null) throw new ArgumentNullException(nameof(graph));
    if (string.IsNullOrEmpty(outputPath)) throw new ArgumentException("Output path cannot be null or empty.", nameof(outputPath));

    var directory = Path.GetDirectoryName(outputPath);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var content = GenerateGraphContent(spec, graph, entityType);
    File.WriteAllText(outputPath, content);
  }

  private static List<string> CollectAllInputsToGraph(Specification spec, Graph graph)
  {
      var inputs = new List<string>();

      // From terms
      foreach (var term in graph.Terms.Terms)
      {
          var theTerm = term.Value.ParsedTree;
          if (theTerm == null) continue;
          foreach (var input in new ReferenceExtractor().Visit(theTerm) ?? [])
          {
              inputs.Add(input.ToBString());
          }
      }

      if (graph.Terms.Variables.Any(x => x.Value.Type == "timestamp"))
      {
          inputs.Add("NOW"); // Add NOW as implicit input for time-based conditions
      }

      // Remove duplicates but keep defined order
      return inputs.Distinct().ToList();
  }

  private static string DeclareStateSetsRecursively(Specification spec, Graph graph, EntityType entityType, Subgraph subgraph, string parent)
  {
    // Extract states and transitions from the parse tree
    var states = new HashSet<string>();
    var transitions = subgraph.Transitions;

    var diagramBody = graph.ParseTree.diagramBody();
    // Collect states from state declarations
    foreach (var stateDecl in diagramBody.stateDeclaration())
    {
      var stateName = stateDecl.stateReference().stateName()?.GetText();
      if (!string.IsNullOrEmpty(stateName)) {
        states.Add(stateName);
        continue;
      }

      var pseudostateName = stateDecl.stateReference().pseudostateName()?.GetText();
      if (!string.IsNullOrEmpty(pseudostateName))
      {
        states.Add(pseudostateName);
      }
    }

    // Collect states and transitions from transitions
    foreach (var transition in transitions)
    {
      var from = transition.From;
      var to = transition.To;
      if (!string.IsNullOrEmpty(from)) states.Add(from);
      if (!string.IsNullOrEmpty(to)) states.Add(to);
    }

    // Remove special state names for Rust enum and transitions
    var rustStates = states.Where(s => s != "[*]").ToList();
    var validTransitions = transitions;

    // Helper for Rust enum variant formatting
    string Rustify(string s) {
      var hasNestedGraph = subgraph.NestedSubgraphs.ContainsKey(s);
      if (hasNestedGraph)
      {
        return $"{s}({parent}_{s}_State)";
      }
      return s;
    }

    // Collect choice pseudostate names for quick lookup
    var choicePseudostates = new HashSet<string>(subgraph.ChoicePseudostates
        .Where(p => p.EndsWith("<<choice>>"))
        .Select(p => p.Split(':')[0]));

    // Add __initial to the list of states
    rustStates.Insert(0, "__initial");

    // Generate Rust enum for states (excluding choice pseudostates)
    var enumStates = string.Join(",\n    ", rustStates.Where(x => !choicePseudostates.Contains(x)).Select(Rustify));

    var subgraphs = subgraph.NestedSubgraphs.Select(kv => DeclareStateSetsRecursively(spec, graph, entityType, kv.Value, $"{parent}_{kv.Key}"));
    var currentStateSet = $"  STATETYPE_{graph.Name}_{parent} = {{ {string.Join(", ", rustStates.Select(x => $"STATE_{graph.Name}_{parent}_{x}"))} }}";
    return subgraphs
      .Append(currentStateSet)
      .Aggregate((a, b) => a + ";\n" + b);
  }

  private static List<string> GetNestedSubstatesRecursively(Subgraph subgraph, string parent)
  {
    var states = new List<string>();
    foreach (var nested in subgraph.NestedSubgraphs)
    {
      var nestedParent = $"{parent}_{nested.Key}";
      states.AddRange(GetNestedSubstatesRecursively(nested.Value, nestedParent));
      states.Add(nestedParent);
    }
    return states;
  }

  private static string? GenerateGraphContent(Specification spec, Graph graph, EntityType entityType)
  {
    var states = DeclareStateSetsRecursively(spec, graph, entityType, graph.Subgraph, "root");
    var allInputs = CollectAllInputsToGraph(spec, graph);

    return @$"MACHINE {graph.Name}
SEES Enums
SETS
{states}
VARIABLES
  {graph.Terms.Terms.Select(t => $"{t.Key}")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key}"))
    .Concat(GetNestedSubstatesRecursively(graph.Subgraph, "root").Append("root").Select(s => $"GraphState_{s}"))
    .Aggregate((a, b) => a + ",\n  " + b)}
INVARIANT
  {graph.Terms.Terms.Select(t => $"{t.Key} : BOOL")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} : {(v.Value.Type == "timestamp" ? "INT" : "E_" + v.Value.Type)}"))
    .Concat(GetNestedSubstatesRecursively(graph.Subgraph, "root").Append("root").Select(s => $"GraphState_{s} : STATETYPE_{graph.Name}_{s}"))
    .Aggregate((a, b) => a + " &\n  " + b)}
INITIALIZATION
  {graph.Terms.Terms.Select(t => $"{t.Key} := {t.Value.Default.ToString().ToUpper()}")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} := {new TermWriter().VisitValueReference(v.Value.ParsedDefault!)}"))
    .Concat(GetNestedSubstatesRecursively(graph.Subgraph, "root").Append("root").Select(s => $"GraphState_{s} := STATE_{graph.Name}_{s}___initial"))
    .Aggregate((a, b) => a + ";\n  " + b)}
OPERATIONS
  InitialTransition({string.Join(", ", allInputs)}) =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? $"bool({new TermWriter().Visit(t.Value.ParsedTree)})" : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
      // Perform transition
{GenerateInitialTransition(spec, graph, entityType, graph.Subgraph, "root")}
    END;
  Transition({string.Join(", ", allInputs)}) =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? $"bool({new TermWriter().Visit(t.Value.ParsedTree)})" : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
      // Perform transition
      {GenerateTransitions(spec, graph, entityType, graph.Subgraph, "root")}
    END
END//MACHINE
";
  }

  private static string GenerateInitialTransition(Specification spec, Graph graph, EntityType entityType, Subgraph subgraph, string parent)
  {
    // Extract states and transitions from the parse tree
    var states = new HashSet<string>();
    var transitions = subgraph.Transitions;

    // var diagramBody = graph.ParseTree.diagramBody();
    // // Collect states from state declarations
    // foreach (var stateDecl in diagramBody.stateDeclaration())
    // {
    //   var stateName = stateDecl.stateReference().stateName()?.GetText();
    //   if (!string.IsNullOrEmpty(stateName)) {
    //     states.Add(stateName);
    //     continue;
    //   }

    //   var pseudostateName = stateDecl.stateReference().pseudostateName()?.GetText();
    //   if (!string.IsNullOrEmpty(pseudostateName))
    //   {
    //     states.Add(pseudostateName);
    //   }
    // }

    // Collect states and transitions from transitions
    foreach (var transition in transitions)
    {
      var from = transition.From;
      var to = transition.To;
      if (!string.IsNullOrEmpty(from)) states.Add(from);
      if (!string.IsNullOrEmpty(to)) states.Add(to);
    }

    // Remove special state names for Rust enum and transitions
    var rustStates = new [] {"__initial" };
    var validTransitions = transitions;

    // Helper for Rust enum variant formatting
    string Rustify(string s) {
      var hasNestedGraph = subgraph.NestedSubgraphs.ContainsKey(s);
      if (hasNestedGraph)
      {
        return $"{s}({parent}_{s}_State)";
      }
      return s;
    }

    // Collect choice pseudostate names for quick lookup
    var choicePseudostates = new HashSet<string>(subgraph.ChoicePseudostates
        .Where(p => p.EndsWith("<<choice>>"))
        .Select(p => p.Split(':')[0]));

    // Generate Rust enum for states (excluding choice pseudostates)
    var enumStates = string.Join(",\n    ", rustStates.Where(x => !choicePseudostates.Contains(x)).Select(Rustify));

    // Generate a function for each state to compute the next state
    string WriteTransitionFunction(string state) {
      var stateTransitions = validTransitions
          .Where(t => state == "__initial" && t.From == "[*]")
          .OrderBy(t => t.Priority ?? int.MaxValue)
          .ToList();
      var fnLines = new List<string>();
      var stateIsNested = subgraph.NestedSubgraphs.ContainsKey(state);
      var isFirstTransition = true;
      var anyCondition = false;
      foreach (var t in stateTransitions)
      {
        var verb = isFirstTransition ? "IF" : "ELSIF";
        // Fetch assignments for the target state (t.To)
        var assignments = subgraph.StateAssignments?.TryGetValue(t.To, out var value) == true ? value : null;
        string assignmentCode = string.Empty;
        if (assignments != null)
        {
          assignmentCode = string.Join("\n      ", assignments.Select(a => new AssignmentWriter().VisitAssignment(a)));
        }
        if (t.ParsedCondition != null)
        {
          anyCondition = true;
          var visitor = new TransitionConditionToBVisitor();
          var condExpr = visitor.Visit(t.ParsedCondition);
          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n{WriteTransitionFunction(t.To)}");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}");
              fnLines.Add($"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To};");
              fnLines.Add(GenerateInitialTransition(spec, graph, entityType, subgraph.NestedSubgraphs[t.To], $"{parent}_{t.To}"));
            }
            else
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}");
              fnLines.Add(string.Join(";\n", new [] {
                $"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}",
              }.Concat(subgraph.NestedSubgraphs.Select(nested => $"          GraphState_{parent}_{nested.Key} := STATE_{graph.Name}_{parent}_{nested.Key}___initial"))));
            }
          }
        }
        else
        {
          if (!isFirstTransition)
          {
            fnLines.Add("        ELSE");
          }

          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        {assignmentCode}\n{WriteTransitionFunction(t.To)}");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {assignmentCode}");
              fnLines.Add($"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To};");
              fnLines.Add(GenerateInitialTransition(spec, graph, entityType, subgraph.NestedSubgraphs[t.To], $"{parent}_{t.To}"));
            }
            else
            {
              fnLines.Add($"        {assignmentCode}");
              fnLines.Add(string.Join(";\n", new [] {
                $"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}",
              }.Concat(subgraph.NestedSubgraphs.Select(nested => $"          GraphState_{parent}_{nested.Key} := STATE_{graph.Name}_{parent}_{nested.Key}___initial"))));
            }
          }
        }

        isFirstTransition = false;
      }
      if (anyCondition)
      {
        fnLines.Add("        END");
      }
      return string.Join("\n", fnLines);
    }

    return WriteTransitionFunction("__initial");
  }

  private static string GenerateTransitions(Specification spec, Graph graph, EntityType entityType, Subgraph subgraph, string parent)
  {
    // Extract states and transitions from the parse tree
    var states = new HashSet<string>();
    var transitions = subgraph.Transitions;

    // var diagramBody = graph.ParseTree.diagramBody();
    // // Collect states from state declarations
    // foreach (var stateDecl in diagramBody.stateDeclaration())
    // {
    //   var stateName = stateDecl.stateReference().stateName()?.GetText();
    //   if (!string.IsNullOrEmpty(stateName)) {
    //     states.Add(stateName);
    //     continue;
    //   }

    //   var pseudostateName = stateDecl.stateReference().pseudostateName()?.GetText();
    //   if (!string.IsNullOrEmpty(pseudostateName))
    //   {
    //     states.Add(pseudostateName);
    //   }
    // }

    // Collect states and transitions from transitions
    foreach (var transition in transitions)
    {
      var from = transition.From;
      var to = transition.To;
      if (!string.IsNullOrEmpty(from)) states.Add(from);
      if (!string.IsNullOrEmpty(to)) states.Add(to);
    }

    // Remove special state names for Rust enum and transitions
    var rustStates = states.Where(s => s != "[*]").ToList();
    var validTransitions = transitions;

    // Helper for Rust enum variant formatting
    string Rustify(string s) {
      var hasNestedGraph = subgraph.NestedSubgraphs.ContainsKey(s);
      if (hasNestedGraph)
      {
        return $"{s}({parent}_{s}_State)";
      }
      return s;
    }

    // Collect choice pseudostate names for quick lookup
    var choicePseudostates = new HashSet<string>(subgraph.ChoicePseudostates
        .Where(p => p.EndsWith("<<choice>>"))
        .Select(p => p.Split(':')[0]));

    // Generate Rust enum for states (excluding choice pseudostates)
    var enumStates = string.Join(",\n    ", rustStates.Where(x => !choicePseudostates.Contains(x)).Select(Rustify));

    // Generate a function for each state to compute the next state
    string WriteTransitionFunction(string state) {
      var stateTransitions = validTransitions
          .Where(t => t.From == state || (state == "__initial" && t.From == "[*]"))
          .OrderBy(t => t.Priority ?? int.MaxValue)
          .ToList();
      var fnLines = new List<string>();
      var stateIsNested = subgraph.NestedSubgraphs.ContainsKey(state);
      // if (stateIsNested)
      // {
      //   fnLines.Add($"    fn transition_from_{parent}_{state}(&mut self, s: {parent}_{state}_State, now: timestamp) -> {parent}_State {{");
      // }
      // else
      // {
      //   fnLines.Add($"    fn transition_from_{parent}_{state}(&mut self, now: timestamp) -> {parent}_State {{");
      // }
      var isFirstTransition = true;
      var anyCondition = false;
      foreach (var t in stateTransitions)
      {
        var verb = isFirstTransition ? "IF" : "ELSIF";
        // Fetch assignments for the target state (t.To)
        var assignments = subgraph.StateAssignments?.TryGetValue(t.To, out var value) == true ? value : null;
        string assignmentCode = string.Empty;
        if (assignments != null)
        {
          assignmentCode = string.Join("\n      ", assignments.Select(a => new AssignmentWriter().VisitAssignment(a)));
        }
        if (t.ParsedCondition != null)
        {
          anyCondition = true;
          var visitor = new TransitionConditionToBVisitor();
          var condExpr = visitor.Visit(t.ParsedCondition);
          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n{WriteTransitionFunction(t.To)}\n");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}");
              fnLines.Add($"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To};");
              fnLines.Add(GenerateInitialTransition(spec, graph, entityType, subgraph.NestedSubgraphs[t.To], $"{parent}_{t.To}"));
            }
            else
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}");
              fnLines.Add(string.Join(";\n", new [] {
                $"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}",
              }.Concat(subgraph.NestedSubgraphs.Select(nested => $"          GraphState_{parent}_{nested.Key} := STATE_{graph.Name}_{parent}_{nested.Key}___initial"))));
            }
          }
        }
        else
        {
          if (!isFirstTransition)
          {
            fnLines.Add("        ELSE");
          }

          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        {assignmentCode}\n{WriteTransitionFunction(t.To)}");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {assignmentCode}");
              fnLines.Add($"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To};");
              fnLines.Add(GenerateInitialTransition(spec, graph, entityType, subgraph.NestedSubgraphs[t.To], $"{parent}_{t.To}"));
            }
            else
            {
              fnLines.Add($"        {assignmentCode}");
              fnLines.Add(string.Join(";\n", new [] {
                $"          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}",
              }.Concat(subgraph.NestedSubgraphs.Select(nested => $"          GraphState_{parent}_{nested.Key} := STATE_{graph.Name}_{parent}_{nested.Key}___initial"))));
            }
          }
        }

        isFirstTransition = false;
      }
      if (!choicePseudostates.Contains(state) && state != "__initial")
      {
        var isNested = subgraph.NestedSubgraphs.ContainsKey(state);
        if (isNested)
        {
          if (anyCondition)
          {
            fnLines.Add("        ELSE");
          }
          fnLines.Add(GenerateTransitions(spec, graph, entityType, subgraph.NestedSubgraphs[state], $"{parent}_{state}"));
        }
      }
      if (anyCondition)
      {
        fnLines.Add("        END");
      }
      return string.Join("\n", fnLines);
    }

    // Generate Rust match arms for transitions, calling the per-state function
    var matchArms = string.Join(";\n      ", rustStates
      .Where(x => !choicePseudostates.Contains(x))
      .Select(state => {
        var transition = WriteTransitionFunction(state);
        if (transition.Trim().Length == 0)
        {
          return null;
        }
        return $"SELECT GraphState_{parent} = STATE_{graph.Name}_{parent}_{state} THEN \n{transition}\n      END";
      })
      .Where(x => x != null));

    return matchArms;
  }
}
