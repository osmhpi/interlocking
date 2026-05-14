using FormalInterlocking.Model;
using FormalInterlocking.Codegen;

try
{
  // Spec root is given as first argument
  var specRoot = args[0];
  var spec = Specification.Parse(specRoot + "/generic_application");
  var simulatorRoot = $"{specRoot}/generic_application_simulator";

  // Ensure path exists
  if (!Directory.Exists($"{simulatorRoot}/src"))
  {
    Directory.CreateDirectory($"{simulatorRoot}/src");
  }

  RustWriter.WriteEnums(spec.Enums, $"{simulatorRoot}/src/enums.rs");

  // Ensure path exists
  if (!Directory.Exists($"{simulatorRoot}/src/graphs"))
  {
      Directory.CreateDirectory($"{simulatorRoot}/src/graphs");
  }
  else
  {
    // Clear existing graph files
    var existingGraphFiles = Directory.GetFiles($"{simulatorRoot}/src/graphs", "*.rs");
    foreach (var file in existingGraphFiles)
    {
        File.Delete(file);
    }
  }

  RustWriter.WriteGraphsModule(spec.Graphs, $"{simulatorRoot}/src/graphs/mod.rs");
  foreach (var graph in spec.Graphs)
  {
    try
    {
      var concept = spec.EntityTypes.Single(c => c.Name == graph.Terms.Entity_type);
      RustWriter.WriteGraph(spec, graph, concept, $"{simulatorRoot}/src/graphs/{graph.Name}.rs");
    }
    catch (TransformerException ex)
    {
      Console.WriteLine($"Error generating graph '{graph.Name}': {ex.Message}");
      return 1;
    }
  }

  // Ensure path exists
  if (!Directory.Exists($"{simulatorRoot}/src/entity_types"))
  {
      Directory.CreateDirectory($"{simulatorRoot}/src/entity_types");
  }
  else
  {
    // Clear existing entity type files
    var existingEntityTypeFiles = Directory.GetFiles($"{simulatorRoot}/src/entity_types", "*.rs");
    foreach (var file in existingEntityTypeFiles)
    {
        File.Delete(file);
    }
  }

  var conceptInterfaces = new List<(string ConceptName, string InterfaceName)>();
  foreach (var concept in spec.EntityTypes)
  {
    foreach (var iface in concept.Interfaces ?? new Dictionary<string, InterfaceAssignment>())
    {
      try
      {
        var ifaceDefinition = spec.Interfaces.Single(i => i.Name == iface.Key);
        RustWriter.WriteEntityTypeInterface(ifaceDefinition, concept, iface.Value, $"{simulatorRoot}/src/entity_types/{concept.Name}_{iface.Key}.rs", spec);
        conceptInterfaces.Add((concept.Name, iface.Key));
      }
      catch (TransformerException ex)
      {
        Console.WriteLine($"Error generating interface '{iface.Key}' for entity type '{concept.Name}': {ex.Message}");
        return 1;
      }
    }
  }

  RustWriter.WriteConceptsModule(conceptInterfaces, $"{simulatorRoot}/src/entity_types/mod.rs", spec);

  RustWriter.WriteSchedule(spec.Graphs, spec.Schedule, conceptInterfaces, $"{simulatorRoot}/src/schedule.rs");
  RustWriter.WriteEvalContext(spec.Graphs, conceptInterfaces, $"{simulatorRoot}/src/eval_context.rs");

  JsonSchemaWriter.WriteJsonSchema($"{simulatorRoot}/configuration.schema.json", spec);

  return 0;
}
catch(Exception ex)
{
  Console.WriteLine("An error occurred during code generation.");
  Console.WriteLine(ex.Message);
  Console.WriteLine(ex.StackTrace);

  return 1;
}
