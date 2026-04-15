using FormalInterlocking.Model;
using static ExpressionParser;
using FormalInterlocking.Codegen;

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

  private static string? GenerateGraphContent(Specification spec, Graph graph, EntityType entityType)
  {
    var states = GenerateGraphContentPrivate(spec, graph, entityType, graph.Subgraph, "root");

    return @$"MACHINE {graph.Name}
SEES Enums
SETS
  STATE_{graph.Name}_root = {{ {string.Join(", ", states.Select(x => $"STATE_{graph.Name}_root_{x}"))} }}
VARIABLES
  GraphState
INVARIANT
  GraphState : STATE_{graph.Name}_root
INITIALIZATION
  GraphState := STATE_{graph.Name}_root___initial
OPERATIONS
  InitialTransition =
    SELECT GraphState = STATE_{graph.Name}_root___initial THEN
      GraphState := STATE_{graph.Name}_root___initial
    END;
  Transition =
    SELECT GraphState = STATE_{graph.Name}_root___initial THEN
      GraphState := STATE_{graph.Name}_root___initial
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
