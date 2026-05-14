using FormalInterlocking.Codegen;
using FormalInterlocking.Model;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Schema;

try
{
  if (args.Length == 0)
  {
    Console.WriteLine("Please provide the path to the specification root as the first argument.");
    return 1;
  }

  // Spec root is given as first argument
  var specRoot = args[0];
  var spec = Specification.Parse(specRoot + "/generic_application");

  // Read specific application schema
  var schema = JSchema.Parse(File.ReadAllText($"{specRoot}/generic_application_simulator/configuration.schema.json"));
  var specificAppConfig = JObject.Parse(File.ReadAllText($"{specRoot}/specific_application/configuration.json"));

  if (!specificAppConfig.IsValid(schema, out IList<string> validationErrors))
  {
    Console.WriteLine("Specific application configuration is invalid.");
    // foreach (var error in validationErrors)
    // {
    //   Console.WriteLine($"- {error}");
    // }
    return 1;
  }

  // Ensure path exists
  if (!Directory.Exists($"{specRoot}/specific_application/B/"))
  {
    Directory.CreateDirectory($"{specRoot}/specific_application/B/");
  }
  else
  {
    // Clear existing files in the directory
    var existingFiles = Directory.GetFiles($"{specRoot}/specific_application/B/", "*.mch");
    foreach (var file in existingFiles)
    {
      File.Delete(file);
    }
  }

  BWriter.WriteEnums(spec.Enums, $"{specRoot}/specific_application/B/Enums.mch");

  foreach (var graph in spec.Graphs)
  {
    try
    {
      var concept = spec.EntityTypes.Single(c => c.Name == graph.Terms.Entity_type);
      BWriter.WriteGraph(spec, graph, concept, $"{specRoot}/specific_application/B/{graph.Name}.mch");
    }
    catch (TransformerException ex)
    {
      Console.WriteLine($"Error generating graph '{graph.Name}': {ex.Message}");
      return 1;
    }
  }

  foreach (var entityType in spec.EntityTypes)
  {
    foreach (var intf in entityType.Interfaces)
    {
      try
      {
        var systemInterface = spec.Interfaces.Single(x => x.Name == intf.Key);
        BWriter.WriteInterface(spec, systemInterface, intf.Value, entityType, $"{specRoot}/specific_application/B/{systemInterface.Name}_{entityType.Name}.mch");
      }
      catch (TransformerException ex)
      {
        Console.WriteLine($"Error generating interface '{intf.Key}_{entityType.Name}': {ex.Message}");
        return 1;
      }
    }
  }

  BWriter.WriteSystem(spec, specificAppConfig, $"{specRoot}/specific_application/B/System.mch");
  BWriter.WriteSimulator(spec, specificAppConfig, $"{specRoot}/specific_application/B/Simulator.mch");

  return 0;
}
catch(Exception ex)
{
  Console.WriteLine("An error occurred during code generation.");
  Console.WriteLine(ex.Message);
  Console.WriteLine(ex.StackTrace);

  return 1;
}

