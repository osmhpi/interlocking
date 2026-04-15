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

      // Remove duplicates but keep defined order
      return inputs.Distinct().ToList();
  }

  private static string? GenerateGraphContent(Specification spec, Graph graph, EntityType entityType)
  {
    var states = GenerateGraphContentPrivate(spec, graph, entityType, graph.Subgraph, "root");
    var allInputs = CollectAllInputsToGraph(spec, graph);

    return @$"MACHINE {graph.Name}
SEES Enums
SETS
  STATE_{graph.Name}_root = {{ {string.Join(", ", states.Select(x => $"STATE_{graph.Name}_root_{x}"))} }}
VARIABLES
  {graph.Terms.Terms.Select(t => $"{t.Key}")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key}"))
    .Concat(["GraphState"]).Aggregate((a, b) => a + ",\n  " + b)}
INVARIANT
  {graph.Terms.Terms.Select(t => $"{t.Key} : BOOL")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} : {v.Value.Type}"))
    .Concat(["GraphState : STATE_" + graph.Name + "_root"])
    .Aggregate((a, b) => a + " &\n  " + b)}
INITIALIZATION
  {graph.Terms.Terms.Select(t => $"{t.Key} := {t.Value.Default.ToString().ToUpper()}")
    .Concat(graph.Terms.Variables.Select(v => $"{v.Key} := {v.Value.ParsedDefault?.qualifiedName()?.enumerationTypeName().GetText()}_{v.Value.ParsedDefault?.qualifiedName()?.enumerationLiteralName().GetText()}"))
    .Concat(["GraphState := STATE_" + graph.Name + "_root___initial"])
    .Aggregate((a, b) => a + ";\n  " + b)}
OPERATIONS
  InitialTransition =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? new TermWriter().Visit(t.Value.ParsedTree) : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
      // Perform transition
      SELECT GraphState = STATE_{graph.Name}_root___initial THEN
        GraphState := STATE_{graph.Name}_root___initial
      END;
    END
  Transition({string.Join(", ", allInputs)}) =
    BEGIN
      // Update Terms
      {graph.Terms.Terms.Select(t => $"{t.Key} := {(t.Value.ParsedTree != null ? new TermWriter().Visit(t.Value.ParsedTree) : t.Value.Default.ToString().ToUpper())}").Aggregate((a, b) => a + " ||\n      " + b)};
      // Perform transition
      SELECT GraphState = STATE_{graph.Name}_root___initial THEN
        GraphState := STATE_{graph.Name}_root___initial
      END
    END
END//MACHINE
";
  }

  private static List<string> GenerateGraphContentPrivate(Specification spec, Graph graph, EntityType entityType, Subgraph subgraph, string parent)
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

    return rustStates;
  }
}
