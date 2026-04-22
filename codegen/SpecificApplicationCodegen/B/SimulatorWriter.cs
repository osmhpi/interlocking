using System.Data;
using FormalInterlocking.Model;
using Newtonsoft.Json.Linq;

static partial class BWriter
{
    public static void WriteSimulator(Specification spec, JObject specificAppConfig, string outputPath)
    {
        var content = GenerateSimulatorContent(spec, specificAppConfig);
        File.WriteAllText(outputPath, content);
    }

    private static string GenerateSimulatorContent(Specification spec, JObject specificAppConfig)
    {
        var entities = spec.EntityTypes.SelectMany(x => specificAppConfig[x.Name]?.Select(instance => (EntityType: x, InstanceName: SanitizeBIdentifier(instance["name"]?.ToString()))) ?? []).ToList();
        var interfaces = from entity in entities
                         from intf in entity.EntityType.Interfaces
                         join systemIntf in spec.Interfaces on intf.Key equals systemIntf.Name
                         select (Interface: systemIntf, intf.Value, EntityType: entity.EntityType, InterfaceInstanceName: entity.InstanceName);

        return @$"MACHINE Simulator
SEES
  Enums
INCLUDES
  System
DEFINITIONS
  VISB_SVG_FILE == ""trackplan.svg"";
  VISB_SVG_UPDATES1== rec(`id`:""W1R"",visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES2== rec(`id`:""W2R"",visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_RIGHT));
VARIABLES
  {string.Join(",\n  ", interfaces.SelectMany(i => i.Value.Inputs?.Select(input => $"SIM_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key}") ?? []).Append("SIM_TIME"))}
INVARIANT
  {string.Join(" &\n  ", interfaces.SelectMany(i => i.Value.Inputs?.Select(input => $"SIM_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key} : {(input.Value.Type == "boolean" ? "BOOL" : "E_" + input.Value.Type)}") ?? []).Append("SIM_TIME : INTEGER"))}
INITIALIZATION
  {string.Join(" ||\n  ", interfaces.SelectMany(i => i.Value.Inputs?.Select(input => $"SIM_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key} := {InitialValueFor(spec, i, input)}") ?? []).Append("SIM_TIME := 0"))}
OPERATIONS
  EmptyTick =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      BigStep({ProvideSimulationInputs(spec, interfaces)}, SIM_TIME)
    END
END//MACHINE";
    }

  private static string ProvideSimulationInputs(Specification spec, IEnumerable<(Interface Interface, InterfaceAssignment intf, EntityType EntityType, string InterfaceInstanceName)> interfaces)
  {
    var inputs = new List<string>();
    foreach (var intf in interfaces)
    {
        foreach (var input in intf.intf.Inputs ?? new Dictionary<string, InterfaceInputField>())
        {
            inputs.Add($"SIM_{intf.Interface.Name}_{intf.EntityType.Name}_{intf.InterfaceInstanceName}_{input.Key}");
        }
    }
    return string.Join(", ", inputs);
  }

  private static string InitialValueFor(Specification spec, (Interface Interface, InterfaceAssignment Value, EntityType EntityType, string InterfaceInstanceName) i, KeyValuePair<string, InterfaceInputField> input)
  {
    if (input.Value.Type == "boolean")
    {
        return "FALSE";
    }
    else if (input.Value.Type == "OccupancyStatus")
    {
        return "OccupancyStatus_VACANT";
    }
    else
    {
        return new TermWriter().VisitValueReference(input.Value.ParsedDefault!);
    }
  }
}
