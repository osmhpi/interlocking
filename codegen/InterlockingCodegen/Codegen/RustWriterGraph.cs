using FormalInterlocking.Model;
using static ExpressionParser;
using FormalInterlocking.Codegen;

namespace FormalInterlocking.Codegen;

static partial class RustWriter
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
    var structName = graph.Name + "StateMachine";

    var termFields = string.Join("\n", (graph.Terms?.Terms ?? new Dictionary<string, Term>()).Select(t => $"    pub {t.Key}_value: bool,"));

    string ToRustBoolFunctionWithContext(string fnName, ExpressionContext expr, bool @default)
    {
      var visitor = new ExpressionToRustVisitor(true, entityType, spec.Interfaces); // pass a flag to enable context-aware codegen
      var exprText = visitor.Visit(expr);
      return $"    pub fn {fnName}(&self, ctx: &EvalContext, now: timestamp) -> bool {{\n        ({exprText}).unwrap_or({(@default ? "true" : "false")})\n    }}";
    }

    // Generate Rust boolean functions for each term, context-aware
    var rustTermFns = string.Empty;
    if (graph.Terms?.Terms != null)
    {
      rustTermFns = string.Join("\n\n", graph.Terms.Terms.Select(term =>
      {
        var fnName = term.Key;
        var expr = term.Value.ParsedTree;
        if (expr == null) return $"    pub fn {fnName}(&self, ctx: &EvalContext, now: timestamp) -> bool {{\n        {(term.Value.Default ? "true" : "false")}\n    }}";
        return ToRustBoolFunctionWithContext(fnName, expr, term.Value.Default);
      }));
    }

    return @$"
    // Auto-generated Rust state machine for {graph.Name}

use web_sys;
use crate::{{configuration_types::*, enums::*, eval_context::EvalContext, graph::Graph, triggerable::Triggerable, timestamp::timestamp}};

#[derive(Clone)]
pub struct {structName} {{
    __state: root_State,
    pub entity: Entities{graph.Terms?.Entity_type ?? string.Empty}Item,
{string.Join("\n", (graph.Terms?.Variables ?? new Dictionary<string, Variable>()).Select(v => $"    pub {v.Key}: {v.Value.Type},"))}
{termFields}
}}

impl {structName} {{
    pub fn new(entity: Entities{graph.Terms?.Entity_type ?? string.Empty}Item) -> Self {{
        Self {{
            __state: root_State::__initial,
            entity,
{string.Join(",\n", (graph.Terms?.Variables ?? new Dictionary<string, Variable>()).Select(v =>
    $"            {v.Key}: {{ {RustHelper.GetRustDefaultValue(v.Value)} }}"))}
{(graph.Terms?.Variables?.Count > 0 ? "," : "")}
{string.Join(",\n", (graph.Terms?.Terms ?? new Dictionary<string, Term>()).Select(t =>
    $"            {t.Key}_value: {RustHelper.GetRustBoolDefault(t.Value)}"))}
        }}
    }}

{rustTermFns}
}}

impl Graph for {structName} {{
    fn evaluate_terms(&mut self, ctx: &EvalContext, now: timestamp) {{
{string.Join("\n", (graph.Terms?.Terms ?? new Dictionary<string, Term>()).Select(t => $"        self.{t.Key}_value = self.{t.Key}(ctx, now);"))}
    }}

    fn transition(&mut self, now: timestamp) {{
        self.__state = self.transition_root(self.__state.clone(), now);
    }}
}}

{GenerateGraphContentPrivate(spec, graph, entityType, graph.Subgraph, "root")}";
  }

  private static string? GenerateGraphContentPrivate(Specification spec, Graph graph, EntityType entityType, Subgraph subgraph, string parent)
  {
    // Extract states and transitions from the parse tree
    var states = new HashSet<string>();
    var transitions = subgraph.Transitions;

    var diagramBody = graph.ParseTree.diagramBody();
    // Collect states from state declarations
    foreach (var stateDecl in diagramBody.stateDecl())
    {
      var stateName = stateDecl.stateRef().stateName()?.GetText();
      if (!string.IsNullOrEmpty(stateName)) {
        states.Add(stateName);
        continue;
      }

      var pseudostateName = stateDecl.stateRef().pseudostateName()?.GetText();
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

    // Generate a function for each state to compute the next state
    var transitionFns = string.Join("\n\n", rustStates.Select(state =>
    {
      var stateTransitions = validTransitions
          .Where(t => t.From == state || (state == "__initial" && t.From == "[*]"))
          .OrderBy(t => t.Priority ?? int.MaxValue)
          .ToList();
      var fnLines = new List<string>();
      var stateIsNested = subgraph.NestedSubgraphs.ContainsKey(state);
      if (stateIsNested)
      {
        fnLines.Add($"    fn transition_from_{parent}_{state}(&mut self, s: {parent}_{state}_State, now: timestamp) -> {parent}_State {{");
      }
      else
      {
        fnLines.Add($"    fn transition_from_{parent}_{state}(&mut self, now: timestamp) -> {parent}_State {{");
      }
      foreach (var t in stateTransitions)
      {
        // Fetch assignments for the target state (t.To)
        var assignments = subgraph.StateAssignments?.TryGetValue(t.To, out var value) == true ? value : null;
        string assignmentCode = string.Empty;
        if (assignments != null)
        {
          assignmentCode = string.Join("\n", assignments.Select(a =>
          {
            var variable = a.refVar()?.GetText() ?? "";
            var value = a.valueReference()?.GetText() ?? "";
            return $"            self.{variable} = {value};";
          }));
        }
        if (t.ParsedCondition != null)
        {
          var visitor = new TransitionConditionToRustVisitor();
          var condExpr = visitor.Visit(t.ParsedCondition);
          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        if {condExpr} {{\n{assignmentCode}\n            return self.transition_from_{parent}_{t.To}(now); }}");
          }
          else
          {
            var logEnteringState = $"            web_sys::console::log_1(&format!(\"{graph.Name}({{}})={t.To}\", self.entity.name).into());";
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        if {condExpr} {{\n{assignmentCode}\n            {logEnteringState}\n            return {parent}_State::{t.To}(self.transition_from_{parent}_{t.To}___initial(now)); }}");
            }
            else
            {
              fnLines.Add($"        if {condExpr} {{\n{assignmentCode}\n            {logEnteringState}\n            return {parent}_State::{t.To}; }}");
            }
          }
        }
        else
        {
          if (choicePseudostates.Contains(t.To))
          {
            fnLines.Add($"        {assignmentCode}\n        return self.transition_from_{parent}_{t.To}();");
          }
          else
          {
            var logEnteringState = $"            web_sys::console::log_1(&format!(\"{graph.Name}({{}})={t.To}\", self.entity.name).into());";
            var isNested = subgraph.NestedSubgraphs.ContainsKey(t.To);
            if (isNested)
            {
              fnLines.Add($"        {assignmentCode}\n        {logEnteringState}\n        return {parent}_State::{t.To}(self.transition_from_{parent}_{t.To}___initial(now));");
            }
            else
            {
              fnLines.Add($"        {assignmentCode}\n        {logEnteringState}\n        return {parent}_State::{t.To};");
            }
          }
        }
      }
      if (!choicePseudostates.Contains(state) && state != "__initial")
      {
        var isNested = subgraph.NestedSubgraphs.ContainsKey(state);
        if (isNested)
        {
          fnLines.Add($"        {parent}_State::{state}(self.transition_{parent}_{state}(s.clone(), now))");
        }
        else
        {
          fnLines.Add($"        {parent}_State::{state}");
        }
      }
      fnLines.Add("    }");
      return string.Join("\n", fnLines);
    }));

    // Generate Rust match arms for transitions, calling the per-state function
    var matchArms = string.Join("\n            ", rustStates
      .Where(x => !choicePseudostates.Contains(x))
      .Where(x => !subgraph.NestedSubgraphs.ContainsKey(x))
      .Select(state => $"{parent}_State::{state} => {{ self.transition_from_{parent}_{state}(now) }}")
      .Concat(rustStates
        .Where(x => !choicePseudostates.Contains(x))
        .Where(x => subgraph.NestedSubgraphs.ContainsKey(x))
        .Select(state => $"{parent}_State::{state}(s) => {{ self.transition_from_{parent}_{state}(s, now) }}")
      ));

    var structName = graph.Name + "StateMachine";

    var subgraphs = subgraph.NestedSubgraphs.Select(kv => GenerateGraphContentPrivate(spec, graph, entityType, kv.Value, $"{parent}_{kv.Key}")).Where(s => s != null);

    var rust = $@"
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum {parent}_State {{
    {enumStates}
}}

impl {structName} {{
{transitionFns}

    fn transition_{parent}(&mut self, state: {parent}_State, now: timestamp) -> {parent}_State {{
        // Performs a state transition if possible
        match state {{
            {matchArms}
        }}
    }}
}}
{string.Join("\n", subgraphs)}";
    return rust;
  }
}
