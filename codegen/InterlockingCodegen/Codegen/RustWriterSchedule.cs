using FormalInterlocking.Model;
using static ExpressionParser;
using FormalInterlocking.Codegen;

namespace FormalInterlocking.Codegen;

static partial class RustWriter
{
  public static void WriteSchedule(List<Graph> graphs, Schedule schedule, List<(string ConceptName, string InterfaceName)> conceptInterfaces, string outputPath)
  {
    if (schedule == null) throw new ArgumentNullException(nameof(schedule));
    if (string.IsNullOrEmpty(outputPath)) throw new ArgumentException("Output path cannot be null or empty.", nameof(outputPath));

    var directory = Path.GetDirectoryName(outputPath);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var content = GenerateScheduleContent(graphs, schedule, conceptInterfaces);
    File.WriteAllText(outputPath, content);
  }
  private static string GenerateScheduleContent(List<Graph> graphs, Schedule schedule, List<(string ConceptName, string InterfaceName)> conceptInterfaces)
  {
    var lines = new List<string>();
    lines.Add("// Auto-generated Rust code to instantiate state machines for the schedule\n");
    lines.Add("use std::collections::HashMap;");
    lines.Add("");
    lines.Add("use crate::{entity_types::*, configuration_types::Entities, enums::*, eval_context::EvalContext, graph::Graph, graphs::*, timestamp::timestamp};");
    lines.Add("");

    // Helper for PascalCase
    string PascalCase(string s) => char.ToUpperInvariant(s[0]) + s.Substring(1);

    // 2. Schedule struct
    lines.Add("pub struct Schedule {");
    foreach (var graph in graphs)
      lines.Add($"    pub {graph.Name}: Vec<{PascalCase(graph.Name)}StateMachine>,");
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"    pub {concept}_{iface}: Vec<{PascalCase(concept)}_{iface}Struct>,");
    lines.Add("}");
    lines.Add("");

    // 3. ScheduleBuilder struct
    lines.Add("pub struct ScheduleBuilder {");
    foreach (var graph in graphs)
      lines.Add($"    {graph.Name}: Vec<{PascalCase(graph.Name)}StateMachine>,");
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"    {concept}_{iface}: Vec<{PascalCase(concept)}_{iface}Struct>,");
    lines.Add("}");
    lines.Add("");

    // 4. ScheduleBuilder::new
    lines.Add("impl ScheduleBuilder {");
    lines.Add("    pub fn new(entities: Entities) -> Self {");
    foreach (var graph in graphs)
    {
      lines.Add($"        let mut {graph.Name} = Vec::new();");
      lines.Add($"        entities.{graph.Terms.Entity_type.ToLowerInvariant()}.iter().for_each(|x| {{");
      lines.Add($"            {graph.Name}.push({PascalCase(graph.Name)}StateMachine::new(x.clone()));");
      lines.Add("        });");
    }
    foreach (var (concept, iface) in conceptInterfaces)
    {
      lines.Add($"        let mut {concept}_{iface} = Vec::new();");
      lines.Add($"        entities.{concept.ToLowerInvariant()}.iter().for_each(|c| {{");
      lines.Add($"            {concept}_{iface}.push({PascalCase(concept)}_{iface}Struct::new(c.clone()));");
      lines.Add("        });");
    }
    lines.Add("        Self {");
    foreach (var graph in graphs)
      lines.Add($"            {graph.Name},");
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"            {concept}_{iface},");
    lines.Add("        }");
    lines.Add("    }");
    lines.Add("");

    // 5. ScheduleBuilder::build
    lines.Add("    pub fn build(self) -> Schedule {");
    lines.Add("        Schedule {");
    foreach (var graph in graphs)
      lines.Add($"            {graph.Name}: self.{graph.Name},");
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"            {concept}_{iface}: self.{concept}_{iface},");
    lines.Add("        }");
    lines.Add("    }");
    lines.Add("}");
    lines.Add("");

    // Add a Rust function to build EvalContext from &self
    lines.Add("impl Schedule {");
    lines.Add("    fn build_eval_context(&self) -> EvalContext {");
    foreach (var (concept, iface) in conceptInterfaces)
    {
      lines.Add($"        let {concept}_{iface}_map: HashMap<String, {PascalCase(concept)}_{iface}Struct> =");
      lines.Add($"            self.{concept}_{iface}.clone().into_iter().map(|iface| (iface.entity.name.clone(), iface)).collect();");
    }
    foreach (var graph in graphs)
    {
      lines.Add($"        let {graph.Name}_map: HashMap<String, {PascalCase(graph.Name)}StateMachine> =");
      lines.Add($"            self.{graph.Name}.clone().into_iter().map(|m| (m.entity.name.clone(), m)).collect();");
    }
    lines.Add($"        EvalContext {{");
    foreach (var graph in graphs)
      lines.Add($"            {graph.Name}: {graph.Name}_map,");
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"            {concept}_{iface}: {concept}_{iface}_map,");
    lines.Add($"        }}");
    lines.Add($"    }}");
    lines.Add("");

    // 6. Schedule impl with evaluate_terms and transition in schedule order
    // lines.Add("impl Schedule {");
    lines.Add("    pub fn transition(&mut self, now: timestamp) {");
    // --- SCHEDULED TRANSITION LOGIC ---
    foreach (var group in schedule.Groups)
    {
      var grouping = group.Grouping;
      var iterations = group.Iterations > 0 ? group.Iterations : 1;
      for (int iter = 0; iter < iterations; iter++)
      {
        if (grouping == GroupsGrouping.By_graph)
        {
          foreach (var entry in group.Entries)
          {
            var graphName = entry.Graph;
            lines.Add($"        for i in 0..self.{graphName}.len() {{");
            lines.Add($"            let ctx = self.build_eval_context();");
            lines.Add($"            self.{graphName}[i].evaluate_terms(&ctx, now);");
            lines.Add($"            self.{graphName}[i].transition(now);");
            lines.Add($"        }}");
          }
        }
        else if (grouping == GroupsGrouping.By_instance)
        {
          lines.Add($"        let len = self.{group.Entries.First().Graph}.len();");
          lines.Add($"        for i in 0..len {{");
          foreach (var entry in group.Entries)
          {
            var graphName = entry.Graph;
            lines.Add($"            let ctx = self.build_eval_context();");
            lines.Add($"            self.{graphName}[i].evaluate_terms(&ctx, now);");
            lines.Add($"            self.{graphName}[i].transition(now);");
          }
          lines.Add($"        }}");
        }
      }
    }
    // --- END SCHEDULED TRANSITION LOGIC ---
    lines.Add("        let ctx = self.build_eval_context();");
    // Call complete_cycle on all concept interface structs
    foreach (var (concept, iface) in conceptInterfaces)
      lines.Add($"        for iface in &mut self.{concept}_{iface} {{ iface.complete_cycle(&ctx); }}");
    lines.Add("        println!(\"Schedule transition completed.\");");
    lines.Add("    }");
    lines.Add("}");
    return string.Join("\n", lines);
  }
}
