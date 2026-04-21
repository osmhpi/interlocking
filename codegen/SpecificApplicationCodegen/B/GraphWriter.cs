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
              inputs.Add(input);
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
    var currentStateSet = $"  STATE_{graph.Name}_{parent} = {{ {string.Join(", ", rustStates.Select(x => $"STATE_{graph.Name}_{parent}_{x}"))} }}";
    return subgraphs
      .Append(currentStateSet)
      .Aggregate((a, b) => a + ";\n" + b);
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
    .Concat(["GraphState_root"]).Aggregate((a, b) => a + ",\n  " + b)}
INVARIANT
  {graph.Terms.Terms.Select(t => $"{t.Key} : BOOL")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} : {(v.Value.Type == "timestamp" ? "INT" : v.Value.Type)}"))
    .Concat(["GraphState_root : STATE_" + graph.Name + "_root"])
    .Aggregate((a, b) => a + " &\n  " + b)}
INITIALIZATION
  {graph.Terms.Terms.Select(t => $"{t.Key} := {t.Value.Default.ToString().ToUpper()}")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} := {new TermWriter().VisitValueReference(v.Value.ParsedDefault!)}"))
    .Concat(["GraphState_root := STATE_" + graph.Name + "_root___initial"])
    .Aggregate((a, b) => a + ";\n  " + b)}
OPERATIONS
  InitialTransition({string.Join(", ", allInputs)}) =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? new TermWriter().Visit(t.Value.ParsedTree) : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
      // Perform transition
{GenerateInitialTransition(spec, graph, entityType, graph.Subgraph, "root")}
    END;
  Transition({string.Join(", ", allInputs)}) =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? new TermWriter().Visit(t.Value.ParsedTree) : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
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
            fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n            return self.transition_from_{parent}_{t.To}(now)\n");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}(self.transition_from_{parent}_{t.To}___initial(now))\n");
            }
            else
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}\n");
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
            fnLines.Add($"        {assignmentCode}\n        return self.transition_from_{parent}_{t.To}();");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {assignmentCode}\n        return {parent}_State::{t.To}(self.transition_from_{parent}_{t.To}___initial(now));");
            }
            else
            {
              fnLines.Add($"        {assignmentCode}\n        GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}");
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
            fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n            return self.transition_from_{parent}_{t.To}(now)\n");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}(self.transition_from_{parent}_{t.To}___initial(now))\n");
            }
            else
            {
              fnLines.Add($"        {verb} {condExpr} THEN\n{assignmentCode}\n          GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}\n");
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
            fnLines.Add($"        {assignmentCode}\n        return self.transition_from_{parent}_{t.To}();");
          }
          else
          {
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {assignmentCode}\n        return {parent}_State::{t.To}(self.transition_from_{parent}_{t.To}___initial(now));");
            }
            else
            {
              fnLines.Add($"        {assignmentCode}\n        GraphState_{parent} := STATE_{graph.Name}_{parent}_{t.To}");
            }
          }
        }

        isFirstTransition = false;
      }
      if (anyCondition)
      {
        fnLines.Add("        END");
      }
      if (!choicePseudostates.Contains(state) && state != "__initial")
      {
        var isNested = subgraph.NestedSubgraphs.ContainsKey(state);
        if (isNested)
        {
          fnLines.Add($"        {parent}_State::{state}(self.transition_{parent}_{state}(s.clone(), now))");
        }
      }
      // fnLines.Add("    }");
      return string.Join("\n", fnLines);
    }

    // Generate Rust match arms for transitions, calling the per-state function
    var matchArms = string.Join(";\n      ", rustStates
      .Where(x => !choicePseudostates.Contains(x))
      .Where(x => !subgraph.NestedSubgraphs.ContainsKey(x))
      .Select(state => $"SELECT GraphState_{parent} = STATE_{graph.Name}_{parent}_{state} THEN \n{WriteTransitionFunction(state)}\n      END")
      .Concat(rustStates
        .Where(x => !choicePseudostates.Contains(x))
        .Where(x => subgraph.NestedSubgraphs.ContainsKey(x))
        .Select(state => $"SELECT GraphState_{parent} = STATE_{graph.Name}_{parent}_{state}(s) THEN \n{WriteTransitionFunction(state)}\n      END")
      ));

    return matchArms;
  }
}
