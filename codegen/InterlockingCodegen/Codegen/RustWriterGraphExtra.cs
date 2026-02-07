using FormalInterlocking.Model;
using static ExpressionParser;
using FormalInterlocking.Codegen;

namespace FormalInterlocking.Codegen;

static partial class RustWriter
{

  // Add a context struct for evaluation
  public static void WriteEvalContext(List<Graph> graphs, List<(string ConceptName, string InterfaceName)> conceptInterfaces, string outputPath)
  {
    var lines = new List<string>();
    lines.Add("// Auto-generated evaluation context for state machines");
    lines.Add("use std::collections::HashMap;");
    lines.Add("");
    lines.Add("use crate::graphs::*;");
    lines.Add("use crate::entity_types::*;");
    lines.Add("");
    foreach (var graph in graphs)
    {
      var structName = char.ToUpperInvariant(graph.Name[0]) + graph.Name.Substring(1) + "StateMachine";
      lines.Add($"pub type {graph.Name}_map = HashMap<String, {structName}>;");
    }
    // Add type aliases for each concept-interface pair
    foreach (var (concept, iface) in conceptInterfaces)
    {
      lines.Add($"pub type {concept}_{iface}_map = HashMap<String, {concept}_{iface}Struct>;");
    }
    lines.Add("\npub struct EvalContext {");
    foreach (var graph in graphs)
    {
      lines.Add($"    pub {graph.Name}: {graph.Name}_map,");
    }
    // Add fields for each concept-interface pair
    foreach (var (concept, iface) in conceptInterfaces)
    {
      lines.Add($"    pub {concept}_{iface}: {concept}_{iface}_map,");
    }
    lines.Add("}");
    File.WriteAllText(outputPath, string.Join("\n", lines));
  }

  internal static void WriteGraphsModule(List<Graph> graphs, string v)
  {
    if (graphs == null) throw new ArgumentNullException(nameof(graphs));
    if (string.IsNullOrEmpty(v)) throw new ArgumentException("Output path cannot be null or empty.", nameof(v));

    var directory = Path.GetDirectoryName(v);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var lines = new List<string>();
    lines.Add("// Auto-generated Rust module for graphs");
    lines.Add("");
    foreach (var graph in graphs)
    {
      var moduleName = graph.Name;
      lines.Add($"mod {moduleName};");
    }
    lines.Add("");
    lines.Add("// Re-export the state machines for use in other modules");
    foreach (var graph in graphs)
    {
      var structName = graph.Name + "StateMachine";
      lines.Add($"pub use {graph.Name}::{structName};");
    }
    lines.Add("");

    File.WriteAllText(v, string.Join("\n", lines));
  }

  internal static void WriteEnums(Enums enums, string v)
  {
    if (enums == null) throw new ArgumentNullException(nameof(enums));
    if (string.IsNullOrEmpty(v)) throw new ArgumentException("Output path cannot be null or empty.", nameof(v));

    var directory = Path.GetDirectoryName(v);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var lines = new List<string>();
    lines.Add("// Auto-generated Rust enums");
    lines.Add("");

    foreach (var enumDef in enums.Enums1)
    {
      var enumName = char.ToUpperInvariant(enumDef.Key[0]) + enumDef.Key.Substring(1);
      lines.Add($"#[derive(Debug, Clone, Copy, PartialEq, Eq)]");
      lines.Add($"pub enum {enumName} {{");
      foreach (var value in enumDef.Value.Enum)
      {
        var variantName = char.ToUpperInvariant(value[0]) + value.Substring(1);
        lines.Add($"    {variantName},");
      }
      lines.Add("}");
      lines.Add("");
    }

    File.WriteAllText(v, string.Join("\n", lines));
  }
}
