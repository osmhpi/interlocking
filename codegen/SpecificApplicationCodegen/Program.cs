using FormalInterlocking.Codegen;
using FormalInterlocking.Model;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Schema;

try
{
  // Spec root is given as first argument
  var specRoot = args[0];
  var spec = Specification.Parse(specRoot + "/generic_application");

  // Read specific application schema
  var schema = JSchema.Parse(File.ReadAllText($"{specRoot}/simulator/configuration.schema.json"));
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

  BWriter.WriteSystem(spec, specificAppConfig, $"{specRoot}/specific_application/B/System.mch");

  return 0;
}
catch(Exception ex)
{
  Console.WriteLine("An error occurred during code generation.");
  Console.WriteLine(ex.Message);
  Console.WriteLine(ex.StackTrace);

  return 1;
}

