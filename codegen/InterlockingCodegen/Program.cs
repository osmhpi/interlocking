using FormalInterlocking.Model;
using FormalInterlocking.Codegen;
using Antlr4.Runtime.Atn;

try
{
  // Spec root is given as first argument
  var specRoot = args[0];
  var spec = Specification.Parse(specRoot + "/generic_application");

  // Ensure path exists
  if (!Directory.Exists($"{specRoot}/simulator/src"))
  {
    Directory.CreateDirectory($"{specRoot}/simulator/src");
  }

  RustWriter.WriteEnums(spec.Enums, $"{specRoot}/simulator/src/enums.rs");

  // Ensure path exists
  if (!Directory.Exists($"{specRoot}/simulator/src/graphs"))
  {
      Directory.CreateDirectory($"{specRoot}/simulator/src/graphs");
  }

  RustWriter.WriteGraphsModule(spec.Graphs, $"{specRoot}/simulator/src/graphs/mod.rs");
  foreach (var graph in spec.Graphs)
  {
    try
    {
      var concept = spec.EntityTypes.Single(c => c.Name == graph.Terms.Entity_type);
      RustWriter.WriteGraph(spec, graph, concept, $"{specRoot}/simulator/src/graphs/{graph.Name}.rs");
    }
    catch (TransformerException ex)
    {
      Console.WriteLine($"Error generating graph '{graph.Name}': {ex.Message}");
      return 1;
    }
  }

  // Ensure path exists
  if (!Directory.Exists($"{specRoot}/simulator/src/entity_types"))
  {
      Directory.CreateDirectory($"{specRoot}/simulator/src/entity_types");
  }

  var conceptInterfaces = new List<(string ConceptName, string InterfaceName)>();
  foreach (var concept in spec.EntityTypes)
  {
    foreach (var iface in concept.Interfaces ?? new Dictionary<string, InterfaceAssignment>())
    {
      try
      {
        var ifaceDefinition = spec.Interfaces.Single(i => i.Name == iface.Key);
        RustWriter.WriteEntityTypeInterface(ifaceDefinition, concept, iface.Value, $"{specRoot}/simulator/src/entity_types/{concept.Name}_{iface.Key}.rs", spec);
        conceptInterfaces.Add((concept.Name, iface.Key));
      }
      catch (TransformerException ex)
      {
        Console.WriteLine($"Error generating interface '{iface.Key}' for entity type '{concept.Name}': {ex.Message}");
        return 1;
      }
    }
  }

  RustWriter.WriteConceptsModule(conceptInterfaces, $"{specRoot}/simulator/src/entity_types/mod.rs", spec);

  RustWriter.WriteSchedule(spec.Graphs, spec.Schedule, conceptInterfaces, $"{specRoot}/simulator/src/schedule.rs");
  RustWriter.WriteEvalContext(spec.Graphs, conceptInterfaces, $"{specRoot}/simulator/src/eval_context.rs");

  JsonSchemaWriter.WriteJsonSchema($"{specRoot}/simulator/configuration.schema.json", spec);

  return 0;
}
catch(Exception ex)
{
  Console.WriteLine("An error occurred during code generation.");
  Console.WriteLine(ex.Message);
  Console.WriteLine(ex.StackTrace);

  return 1;
}
