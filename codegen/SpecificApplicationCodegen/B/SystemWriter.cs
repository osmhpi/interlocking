using System.Data;
using FormalInterlocking.Codegen;
using FormalInterlocking.Model;
using Newtonsoft.Json.Linq;

static partial class BWriter
{
    private static string? SanitizeBIdentifier(string? identifier)
    {
        // Replace + and - with _PLUS_ and _MINUS_ respectively, and remove any other non-alphanumeric characters
        return identifier?.Replace("+", "_PLUS_").Replace("-", "_MINUS_").Replace(".", "_DOT_");
    }

    public static void WriteSystem(Specification spec, JObject specificAppConfig, string outputPath)
    {
        var content = GenerateSystemContent(spec, specificAppConfig);
        File.WriteAllText(outputPath, content);
    }

    record PropertyValue(int? duration, bool? boolean, string? reference, List<string>? referenceList, string? targetEntityType);
    private static string ProvideInputsToGraphInstance(Specification spec, Graph graph, string entity, JObject specificAppConfig, string now)
    {
        var entityType = spec.EntityTypes.Single(e => graph.Terms.Entity_type == e.Name);
        var propertyMap = new Dictionary<string, PropertyValue>();

        foreach (var property in entityType.Properties)
        {
            if (property.Value.Type == "duration")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<int?>();
                propertyMap[property.Key] = new PropertyValue(duration: propertyValueOfInstance ?? 0, boolean: null, reference: null, referenceList: null, null);
            }
            else if (property.Value.Type == "boolean")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<bool?>();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: propertyValueOfInstance ?? false, reference: null, referenceList: null, null);
            }
            else
            {
              var linkedEntityType = spec.EntityTypes.Single(e => e.Name == property.Value.Type);
              if (!property.Value.Max.IsUnbounded)
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToString();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: propertyValueOfInstance, referenceList: null, property.Value.Type);
              }
              else
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.Select(x => x.ToString());
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: null, referenceList: propertyValueOfInstance?.ToList(), property.Value.Type);
              }
            }
        }

        var inputs = new List<Reference>();
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
        var orderedInputs = inputs.Distinct().ToList();
        var parameters = new List<string>();
        foreach (var input in orderedInputs)
        {
            if (input.PropertyName != null)
            {
                // Resolve property value from map above
                var propertyValue = propertyMap[input.PropertyName];

                var graphOrInterfaceName = input.GraphOrInterfaceName;
                if (input.GraphOrInterfaceName != null && spec.Interfaces.Any(i => i.Name == input.GraphOrInterfaceName))
                {
                    graphOrInterfaceName = $"{input.GraphOrInterfaceName}_{propertyValue.targetEntityType}";
                }

                if (propertyValue.duration.HasValue)
                {
                    parameters.Add(propertyValue.duration.Value.ToString());
                }
                else if (propertyValue.boolean.HasValue)
                {
                    parameters.Add(propertyValue.boolean.Value ? "TRUE" : "FALSE");
                }
                else if (propertyValue.reference != null)
                {
                    parameters.Add($"{graphOrInterfaceName}_{SanitizeBIdentifier(propertyValue.reference)}.{input.VariableName}");
                }
                else if (propertyValue.referenceList != null)
                {
                    parameters.Add("{" + string.Join(", ", propertyValue.referenceList.Select(x => $"{graphOrInterfaceName}_{SanitizeBIdentifier(x)}.{input.VariableName}")) + "}");
                }
                else
                {
                    // Empty set
                    parameters.Add("{}");
                }
            }
            else if (input.IsNow)
            {
                parameters.Add(now);
            }
            else
            {
                var graphOrInterfaceName = input.GraphOrInterfaceName;
                if (input.GraphOrInterfaceName != null && spec.Interfaces.Any(i => i.Name == input.GraphOrInterfaceName))
                {
                    graphOrInterfaceName = $"{input.GraphOrInterfaceName}_{entityType.Name}";
                }
                // Input refers to graph or interface belonging to the same entity instance
                parameters.Add($"{graphOrInterfaceName}_{entity}.{input.VariableName}");
            }
        }

        return string.Join(", ", parameters);
    }
    private static string ProvideInputsToInterfaceInstance(Specification spec, string entityTypeName, string interfaceName, string entity, JObject specificAppConfig)
    {
        var entityType = spec.EntityTypes.Single(e => e.Name == entityTypeName);
        var intf = entityType.Interfaces[interfaceName];
        var propertyMap = new Dictionary<string, PropertyValue>();

        foreach (var property in entityType.Properties)
        {
            if (property.Value.Type == "duration")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<int?>();
                propertyMap[property.Key] = new PropertyValue(duration: propertyValueOfInstance ?? 0, boolean: null, reference: null, referenceList: null, targetEntityType: null);
            }
            else if (property.Value.Type == "boolean")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<bool?>();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: propertyValueOfInstance ?? false, reference: null, referenceList: null, targetEntityType: null);
            }
            else
            {
              var linkedEntityType = spec.EntityTypes.Single(e => e.Name == property.Value.Type);
              if (!property.Value.Max.IsUnbounded)
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToString();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: propertyValueOfInstance, referenceList: null, targetEntityType: property.Value.Type);
              }
              else
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.Select(x => x.ToString());
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: null, referenceList: propertyValueOfInstance?.ToList(), targetEntityType: property.Value.Type);
              }
            }
        }

        var inputs = new List<Reference>();
        foreach (var term in (intf.Outputs ?? new Dictionary<string, InterfaceOutputField>()).SelectMany(x => x.Value.ParsedMapping))
        {
            var theTerm = term.Value;
            if (theTerm == null) continue;
            foreach (var input in new ReferenceExtractor().Visit(theTerm) ?? [])
            {
                inputs.Add(input);
            }
        }

        // Remove duplicates but keep defined order
        var orderedInputs = inputs.Distinct().ToList();
        var parameters = new List<string>();
        foreach (var input in orderedInputs)
        {
            if (input.PropertyName != null)
            {
                // Resolve property value from map above
                var propertyValue = propertyMap[input.PropertyName];

                var graphOrInterfaceName = input.GraphOrInterfaceName;
                if (input.GraphOrInterfaceName != null && spec.Interfaces.Any(i => i.Name == input.GraphOrInterfaceName))
                {
                    graphOrInterfaceName = $"{input.GraphOrInterfaceName}_{propertyValue.targetEntityType}";
                }

                if (propertyValue.duration.HasValue)
                {
                    parameters.Add(propertyValue.duration.Value.ToString());
                }
                else if (propertyValue.boolean.HasValue)
                {
                    parameters.Add(propertyValue.boolean.Value ? "TRUE" : "FALSE");
                }
                else if (propertyValue.reference != null)
                {
                    parameters.Add($"{graphOrInterfaceName}_{SanitizeBIdentifier(propertyValue.reference)}.{input.VariableName}");
                }
                else if (propertyValue.referenceList != null)
                {
                    parameters.Add("{" + string.Join(", ", propertyValue.referenceList.Select(x => $"{graphOrInterfaceName}_{SanitizeBIdentifier(x)}.{input.VariableName}")) + "}");
                }
                else
                {
                    // Empty set
                    parameters.Add("{}");
                }
            }
            else if (input.IsNow)
            {
                parameters.Add("SYS_NOW");
            }
            else
            {
                var graphOrInterfaceName = input.GraphOrInterfaceName;
                if (input.GraphOrInterfaceName != null && spec.Interfaces.Any(i => i.Name == input.GraphOrInterfaceName))
                {
                    graphOrInterfaceName = $"{input.GraphOrInterfaceName}_{entityType.Name}";
                }
                // Input refers to graph or interface belonging to the same entity instance
                parameters.Add($"{graphOrInterfaceName}_{entity}.{input.VariableName}");
            }
        }

        if (parameters.Count == 0)
        {
            return ""; // No inputs, return empty string instead of ()
        }

        return $"({string.Join(", ", parameters)})";
    }

    private static string GenerateSystemContent(Specification spec, JObject specificAppConfig)
    {
        var entities = spec.EntityTypes.SelectMany(x => specificAppConfig[x.Name]?.Select(instance => (EntityType: x, InstanceName: SanitizeBIdentifier(instance["name"]?.ToString()))) ?? []).ToList();
        var graphs = from entity in entities
                     join graph in spec.Graphs on entity.EntityType.Name equals graph.Terms.Entity_type
                     select (Graph: graph, InstanceName: entity.InstanceName, GraphInstanceName: $"{graph.Name}_{entity.InstanceName}");

        var interfaces = from entity in entities
                         from intf in entity.EntityType.Interfaces
                         join systemIntf in spec.Interfaces on intf.Key equals systemIntf.Name
                         select (Interface: systemIntf, intf.Value, EntityType: entity.EntityType, InterfaceInstanceName: entity.InstanceName);

        var schedule = new List<(Graph graph, string instanceName, string graphInstanceName)>();

        foreach (var schedulerGroup in spec.Schedule.Groups)
        {
            var iterations = schedulerGroup.Iterations > 0 ? schedulerGroup.Iterations : 1;
            for (var i = 0; i < iterations; i++)
            {
                if (schedulerGroup.Grouping == GroupsGrouping.By_graph)
                {
                    foreach (var graphReference in schedulerGroup.Entries)
                    {
                        foreach (var entity in specificAppConfig[graphReference.Entity_type]?.Select(x => SanitizeBIdentifier(x["name"]?.ToString())) ?? [])
                        {
                            schedule.Add(graphs.Single(x => x.GraphInstanceName == $"{graphReference.Graph}_{entity}"));
                        }
                    }
                }
                else if (schedulerGroup.Grouping == GroupsGrouping.By_instance)
                {
                    var entityType = schedulerGroup.Entries.First().Entity_type;
                    foreach (var entity in specificAppConfig[entityType]?.Select(x => SanitizeBIdentifier(x["name"]?.ToString())) ?? [])
                    {
                        foreach (var graphReference in schedulerGroup.Entries)
                        {
                            schedule.Add(graphs.Single(x => x.GraphInstanceName == $"{graphReference.Graph}_{entity}"));
                        }
                    }
                }
                else
                {
                    throw new TransformerException($"Unsupported grouping type: {schedulerGroup.Grouping}");
                }
            }
        }

        return @$"MACHINE System
INCLUDES
  {string.Join(", ", graphs.Select(g => $"{g.Graph.Name}_{g.InstanceName}.{g.Graph.Name}")
    .Concat(interfaces.Select(i => $"{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}.{i.Interface.Name}_{i.EntityType.Name}")))}
INITIALISATION
  {graphs.Select(g => $"{g.GraphInstanceName}.InitialTransition({ProvideInputsToGraphInstance(spec, g.Graph, g.InstanceName, specificAppConfig, "0")})").Aggregate((a, b) => a + ";\n  " + b)}
OPERATIONS
  BigStep({ProvideInputsToSystem(spec, interfaces)}, SYS_NOW) =
    BEGIN
      {string.Join(";\n      ", interfaces.SelectMany(i => i.Value.Inputs?.Select(input => $"{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}.Set_{input.Key}({i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key})") ?? []))};
      {schedule.Select(graph => $"{graph.graphInstanceName}.Transition({ProvideInputsToGraphInstance(spec, graph.graph, graph.instanceName, specificAppConfig, "SYS_NOW")})").Aggregate((a, b) => a + ";\n      " + b)};
      {interfaces.Select(i => $"{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}.ComputeOutputs{ProvideInputsToInterfaceInstance(spec, i.EntityType.Name, i.Interface.Name, i.InterfaceInstanceName, specificAppConfig)}").Aggregate((a, b) => a + " ||\n      " + b)}
    END
END//MACHINE";
    }

  private static string ProvideInputsToSystem(Specification spec, IEnumerable<(Interface Interface, InterfaceAssignment intf, EntityType EntityType, string InterfaceInstanceName)> interfaces)
  {
    var inputs = new List<string>();
    foreach (var intf in interfaces)
    {
        foreach (var input in intf.intf.Inputs ?? new Dictionary<string, InterfaceInputField>())
        {
            inputs.Add($"{intf.Interface.Name}_{intf.EntityType.Name}_{intf.InterfaceInstanceName}_{input.Key}");
        }
    }
    return string.Join(", ", inputs);
  }
}
