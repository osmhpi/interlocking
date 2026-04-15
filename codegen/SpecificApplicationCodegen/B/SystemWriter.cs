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

    private static string GenerateSystemContent(Specification spec, JObject specificAppConfig)
    {
        var entities = spec.EntityTypes.SelectMany(x => specificAppConfig[x.Name]?.Select(instance => (EntityType: x, InstanceName: SanitizeBIdentifier(instance["name"]?.ToString()))) ?? []).ToList();
        var graphs = from entity in entities
                     join graph in spec.Graphs on entity.EntityType.Name equals graph.Terms.Entity_type
                     select (Graph: graph, InstanceName: entity.InstanceName);

        var schedule = new List<string>();

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
                            schedule.Add($"{graphReference.Graph}_{entity}");
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
                            schedule.Add($"{graphReference.Graph}_{entity}");
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
INITIALISATION
  {graphs.Select(g => $"{g.Graph.Name}_{g.InstanceName}.InitialTransition").Aggregate((a, b) => a + " ||\n  " + b)}
OPERATIONS
  BigStep =
    BEGIN
      {schedule.Select(graph => $"{graph}.Transition").Aggregate((a, b) => a + ";\n      " + b)}
    END
END//MACHINE";
    }
}
