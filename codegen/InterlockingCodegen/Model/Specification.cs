using Antlr4.Runtime;
using Newtonsoft.Json;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace FormalInterlocking.Model;

public record Specification(
  Enums Enums,
  List<Interface> Interfaces,
  List<EntityType> EntityTypes,
  List<Graph> Graphs,
  Schedule Schedule)
{

  public static Specification Parse(string rootPath)
  {
    var directoryInfo = new DirectoryInfo(rootPath);
    if (!directoryInfo.Exists)
    {
      throw new DirectoryNotFoundException($"The specified directory does not exist: {rootPath}");
    }

    var enums = ParseEnums(directoryInfo);
    var interfaces = ParseInterfaces(directoryInfo);
    var concepts = ParseEntityTypes(directoryInfo);
    var graphs = ParseGraphs(directoryInfo);
    var schedule = ParseSchedule(directoryInfo);

    return new Specification(enums, interfaces, concepts, graphs, schedule);
  }

  internal static string YamlToJson(string yamlContent)
  {
    var deserializer = new DeserializerBuilder()
      .WithNamingConvention(CamelCaseNamingConvention.Instance)
      .Build();
    var yamlObject = deserializer.Deserialize<object>(yamlContent);
    var serializer = new SerializerBuilder()
      .JsonCompatible()
      .Build();
    return serializer.Serialize(yamlObject);
  }

  private static Enums ParseEnums(DirectoryInfo specificationRoot)
  {
    var enumsFile = Path.Combine(specificationRoot.FullName, "enums.yaml");
    if (!File.Exists(enumsFile))
    {
      throw new FileNotFoundException($"The enums file does not exist: {enumsFile}");
    }

    try
    {
      var yamlContent = File.ReadAllText(enumsFile);
      var jsonContent = YamlToJson(yamlContent);
      var enums = JsonConvert.DeserializeObject<Enums>(jsonContent);
      if (enums == null)
      {
        throw new InvalidOperationException("Failed to deserialize enums.");
      }
      return enums;
    }
    catch (Exception ex)
    {
      throw new InvalidOperationException($"Failed to parse enums from {enumsFile}: {ex.Message}", ex);
    }
  }

  private static Schedule ParseSchedule(DirectoryInfo specificationRoot)
  {
    var scheduleFile = Path.Combine(specificationRoot.FullName, "schedule.yaml");
    if (!File.Exists(scheduleFile))
    {
      throw new FileNotFoundException($"The schedule file does not exist: {scheduleFile}");
    }

    try
    {
      var yamlContent = File.ReadAllText(scheduleFile);
      var jsonContent = YamlToJson(yamlContent);
      var schedule = JsonConvert.DeserializeObject<Schedule>(jsonContent);
      if (schedule == null)
      {
        throw new InvalidOperationException("Failed to deserialize schedule.");
      }
      return schedule;
    }
    catch (Exception ex)
    {
      throw new InvalidOperationException($"Failed to parse schedule from {scheduleFile}: {ex.Message}", ex);
    }
  }

  private static List<Graph> ParseGraphs(DirectoryInfo specificationRoot)
  {
    var graphs = new List<Graph>();

    var graphsDirectory = Path.Combine(specificationRoot.FullName, "graphs");
    if (!Directory.Exists(graphsDirectory))
    {
      throw new DirectoryNotFoundException($"The graphs directory does not exist: {graphsDirectory}");
    }

    foreach (var graphFile in Directory.GetFiles(graphsDirectory, "*.puml").OrderBy(x => x))
    {
      try
      {
        var graph = Graph.Parse(graphFile);
        graphs.Add(graph);
      }
      catch (Exception ex)
      {
        Console.WriteLine($"Error parsing graph file {graphFile}: {ex.Message}");
        throw;
      }
    }

    return graphs;
  }

  private static List<Interface> ParseInterfaces(DirectoryInfo specificationRoot)
  {
    var interfaces = new List<Interface>();

    var interfacesDirectory = Path.Combine(specificationRoot.FullName, "interfaces");
    if (!Directory.Exists(interfacesDirectory))
    {
      throw new DirectoryNotFoundException($"The interfaces directory does not exist: {interfacesDirectory}");
    }

    foreach (var yamlFile in Directory.GetFiles(interfacesDirectory, "*.yaml").OrderBy(x => x))
    {
      try
      {
        var yamlContent = File.ReadAllText(yamlFile);
        var jsonContent = YamlToJson(yamlContent);
        var interfaceItem = JsonConvert.DeserializeObject<Interface>(jsonContent);
        if (interfaceItem != null)
        {
          interfaces.Add(interfaceItem);
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine($"Error parsing file {yamlFile}: {ex.Message}");
        throw;
      }
    }

    return interfaces;
  }

  private static List<EntityType> ParseEntityTypes(DirectoryInfo specificationRoot)
  {
    var entityTypes = new List<EntityType>();

    var entityTypesDirectory = Path.Combine(specificationRoot.FullName, "entity_types");
    if (!Directory.Exists(entityTypesDirectory))
    {
      throw new DirectoryNotFoundException($"The entity types directory does not exist: {entityTypesDirectory}");
    }

    foreach (var yamlFile in Directory.GetFiles(entityTypesDirectory, "*.yaml").OrderBy(x => x))
    {
      try
      {
        var yamlContent = File.ReadAllText(yamlFile);
        var jsonContent = YamlToJson(yamlContent);
        var entityType = JsonConvert.DeserializeObject<EntityType>(jsonContent);

        // Parse the default values for interface inputs
        if (entityType?.Interfaces != null)
        {
          foreach (var iface in entityType.Interfaces)
          {
            if (iface.Value.Inputs != null)
            {
              foreach (var input in iface.Value.Inputs)
              {
                if (!string.IsNullOrEmpty(input.Value.Default.StringValue))
                {
                  var inputInput = new AntlrInputStream(input.Value.Default.StringValue);
                  var inputLexer = new ExpressionLexer(inputInput);
                  var inputTokenStream = new CommonTokenStream(inputLexer);
                  var inputParser = new ExpressionParser(inputTokenStream);

                  var hasParseErrors = false;
                  inputParser.RemoveErrorListeners();
                  inputParser.AddErrorListener(new ErrorListener((line, charPositionInLine, msg) =>
                  {
                      Console.Error.WriteLine($"Parse error at line {line}, char {charPositionInLine}: {msg}");
                      hasParseErrors = true;
                  }));

                  var inputTree = inputParser.valueReference() ?? throw new InvalidOperationException($"Failed to parse input default value for {input.Key} in {yamlFile}");

                  if (hasParseErrors)
                  {
                      throw new InvalidOperationException($"Failed to parse input default value for {input.Key} in {yamlFile}");
                  }

                  // Check for unconsumed tokens
                  if (inputParser.CurrentToken.Type != TokenConstants.EOF)
                  {
                    throw new InvalidOperationException($"Extra input after valid input default value for {input.Key} in {yamlFile}");
                  }

                  input.Value.ParsedDefault = inputTree;
                }
              }
            }

            if (iface.Value.Outputs != null)
            {
              foreach (var output in iface.Value.Outputs)
              {
                if (!string.IsNullOrEmpty(output.Value.Default.StringValue))
                {
                  var outputInput = new AntlrInputStream(output.Value.Default.StringValue);
                  var outputLexer = new ExpressionLexer(outputInput);
                  var outputTokenStream = new CommonTokenStream(outputLexer);
                  var outputParser = new ExpressionParser(outputTokenStream);

                  var hasParseErrors = false;
                  outputParser.RemoveErrorListeners();
                  outputParser.AddErrorListener(new ErrorListener((line, charPositionInLine, msg) =>
                  {
                      Console.Error.WriteLine($"Parse error at line {line}, char {charPositionInLine}: {msg}");
                      hasParseErrors = true;
                  }));

                  var outputTree = outputParser.valueReference() ?? throw new InvalidOperationException($"Failed to parse output default value for {output.Key} in {yamlFile}");

                  if (hasParseErrors)
                  {
                      throw new InvalidOperationException($"Failed to parse output default value for {output.Key} in {yamlFile}");
                  }

                  // Check for unconsumed tokens
                  if (outputParser.CurrentToken.Type != TokenConstants.EOF)
                  {
                    throw new InvalidOperationException($"Extra input after valid output default value for {output.Key} in {yamlFile}");
                  }

                  output.Value.ParsedDefault = outputTree;
                }

                foreach (var mapping in output.Value.Mapping ?? new Dictionary<string, string>())
                {
                  // Parse mapping key as value reference
                  var mappingKeyInput = new AntlrInputStream(mapping.Key);
                  var mappingKeyLexer = new ExpressionLexer(mappingKeyInput);
                  var mappingKeyTokenStream = new CommonTokenStream(mappingKeyLexer);
                  var mappingKeyParser = new ExpressionParser(mappingKeyTokenStream);

                  var hasParseErrors = false;
                  mappingKeyParser.RemoveErrorListeners();
                  mappingKeyParser.AddErrorListener(new ErrorListener((line, charPositionInLine, msg) =>
                  {
                      Console.Error.WriteLine($"Parse error at line {line}, char {charPositionInLine}: {msg}");
                      hasParseErrors = true;
                  }));

                  var mappingKeyTree = mappingKeyParser.valueReference() ?? throw new InvalidOperationException($"Failed to parse output mapping key for {output.Key} in {yamlFile}");

                  if (hasParseErrors)
                  {
                      throw new InvalidOperationException($"Failed to parse output mapping key for {output.Key} in {yamlFile}");
                  }

                  // Check for unconsumed tokens
                  if (mappingKeyParser.CurrentToken.Type != TokenConstants.EOF)
                  {
                    throw new InvalidOperationException($"Extra input after valid output mapping key for {output.Key} in {yamlFile}");
                  }

                  // Parse mapping value as expression
                  var mappingValueInput = new AntlrInputStream(mapping.Value);
                  var mappingValueLexer = new ExpressionLexer(mappingValueInput);
                  var mappingValueTokenStream = new CommonTokenStream(mappingValueLexer);
                  var mappingValueParser = new ExpressionParser(mappingValueTokenStream);

                  mappingValueParser.RemoveErrorListeners();
                  mappingValueParser.AddErrorListener(new ErrorListener((line, charPositionInLine, msg) =>
                  {
                      Console.Error.WriteLine($"Parse error at line {line}, char {charPositionInLine}: {msg}");
                      hasParseErrors = true;
                  }));

                  var mappingValueTree = mappingValueParser.expression() ?? throw new InvalidOperationException($"Failed to parse output mapping for {output.Key} in {yamlFile}");

                  if (hasParseErrors)
                  {
                      throw new InvalidOperationException($"Failed to parse output mapping for {output.Key} in {yamlFile}");
                  }

                  // Check for unconsumed tokens
                  if (mappingValueParser.CurrentToken.Type != TokenConstants.EOF)
                  {
                    throw new InvalidOperationException($"Extra input after valid output mapping for {output.Key} in {yamlFile}");
                  }

                  output.Value.ParsedMapping[mappingKeyTree] = mappingValueTree;
                }
              }
            }
          }
        }
        if (entityType != null)
        {
          entityTypes.Add(entityType);
        }
      }
      catch (Exception ex)
      {
        Console.WriteLine($"Error parsing file {yamlFile}: {ex.Message}");
        throw;
      }
    }

    return entityTypes;
  }

  // Returns the Rust enum type name if the type is an enum, otherwise null
  public string? ResolveRustEnumType(string typeName)
  {
    if (Enums.Enums1.ContainsKey(typeName))
    {
      // Rust enums are PascalCase
      return char.ToUpperInvariant(typeName[0]) + typeName.Substring(1);
    }
    return null;
  }
}
