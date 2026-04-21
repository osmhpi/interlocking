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


    record PropertyValue(int? duration, bool? boolean, string? reference, List<string>? referenceList);
    private static string ProvideInputsToGraphInstance(Specification spec, Graph graph, string entity, JObject specificAppConfig)
    {
        var entityType = spec.EntityTypes.Single(e => graph.Terms.Entity_type == e.Name);
        var propertyMap = new Dictionary<string, PropertyValue>();

        foreach (var property in entityType.Properties)
        {
            if (property.Value.Type == "duration")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<int?>();
                propertyMap[property.Key] = new PropertyValue(duration: propertyValueOfInstance ?? 0, boolean: null, reference: null, referenceList: null);
            }
            else if (property.Value.Type == "boolean")
            {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToObject<bool?>();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: propertyValueOfInstance ?? false, reference: null, referenceList: null);
            }
            else
            {
              var linkedEntityType = spec.EntityTypes.Single(e => e.Name == property.Value.Type);
              if (!property.Value.Max.IsUnbounded)
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.ToString();
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: propertyValueOfInstance, referenceList: null);
              }
              else
              {
                var propertyValueOfInstance = specificAppConfig[entityType.Name]?.Single(x => SanitizeBIdentifier(x["name"]?.ToString()) == entity)?[property.Key]?.Select(x => x.ToString());
                propertyMap[property.Key] = new PropertyValue(duration: null, boolean: null, reference: null, referenceList: propertyValueOfInstance?.ToList());
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

        if (graph.Terms.Variables.Any(x => x.Value.Type == "timestamp"))
        {
            inputs.Add(new Reference(null, "", null, true)); // Add NOW as implicit input for time-based conditions
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
                    parameters.Add($"{input.GraphOrInterfaceName}_{SanitizeBIdentifier(propertyValue.reference)}.{input.VariableName}");
                }
                else if (propertyValue.referenceList != null)
                {
                    parameters.Add("{" + string.Join(", ", propertyValue.referenceList.Select(x => $"{input.GraphOrInterfaceName}_{SanitizeBIdentifier(x)}.{input.VariableName}")) + "}");
                }
                else
                {
                    // Empty set
                    parameters.Add("{}");
                }
            }
            else if (input.IsNow)
            {
                parameters.Add(input.ToBString());
            }
            else
            {
                // Input refers to graph or interface belonging to the same entity instance
                parameters.Add($"{input.GraphOrInterfaceName}_{entity}.{input.VariableName}");
            }
        }

        return string.Join(", ", parameters);
    }

    private static string GenerateSystemContent(Specification spec, JObject specificAppConfig)
    {
        var entities = spec.EntityTypes.SelectMany(x => specificAppConfig[x.Name]?.Select(instance => (EntityType: x, InstanceName: SanitizeBIdentifier(instance["name"]?.ToString()))) ?? []).ToList();
        var graphs = from entity in entities
                     join graph in spec.Graphs on entity.EntityType.Name equals graph.Terms.Entity_type
                     select (Graph: graph, InstanceName: entity.InstanceName, GraphInstanceName: $"{graph.Name}_{entity.InstanceName}");

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

        return @$"MACHINE Interlocking
INCLUDES {string.Join(", ", graphs.Select(g => $"{g.Graph.Name}_{g.InstanceName}.{g.Graph.Name}"))}
DEFINITIONS
  VISB_SVG_FILE == ""trackplan.svg"";
  VISB_SVG_UPDATES1== rec(`id`:""W1R"",visibility: bool(W1.State = RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:""W2R"",visibility: bool(W2.State = RIGHT));
VARIABLES
  NOW
INVARIANT
  NOW : INT
INITIALISATION
  NOW := 0;
  {graphs.Select(g => $"{g.GraphInstanceName}.InitialTransition({ProvideInputsToGraphInstance(spec, g.Graph, g.InstanceName, specificAppConfig)})").Aggregate((a, b) => a + " ||\n  " + b)}
OPERATIONS
  BigStep =
    BEGIN
      NOW := NOW + 150;
      {schedule.Select(graph => $"{graph.graphInstanceName}.Transition({ProvideInputsToGraphInstance(spec, graph.graph, graph.instanceName, specificAppConfig)})").Aggregate((a, b) => a + ";\n      " + b)}
    END
END//MACHINE";
    }
}
