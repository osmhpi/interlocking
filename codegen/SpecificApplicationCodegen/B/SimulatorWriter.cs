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
  VISB_SVG_UPDATES1== rec(`id`:""W1"",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE or SCICC_Transit_W1_R_PLUS_.Active = TRUE or SCICC_Transit_W1_R_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES2== rec(`id`:""G11"",fill: IF SCICC_Zone_G11.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G11_PLUS_.Active = TRUE or SCICC_Transit_G11_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES3== rec(`id`:""G12"",fill: IF SCICC_Zone_G12.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G12_PLUS_.Active = TRUE or SCICC_Transit_G12_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES4== rec(`id`:""W1L2"",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES5== rec(`id`:""W2L2"",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES6== rec(`id`:""W1R"",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_R_PLUS_.Active = TRUE or SCICC_Transit_W1_R_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END,visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES7== rec(`id`:""W2"",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE or SCICC_Transit_W2_R_PLUS_.Active = TRUE or SCICC_Transit_W2_R_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES8== rec(`id`:""G21"",fill: IF SCICC_Zone_G21.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_G21_PLUS_.Active = TRUE or SCICC_Transit_G21_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END);
  VISB_SVG_UPDATES9== rec(`id`:""W2R"",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_R_PLUS_.Active = TRUE or SCICC_Transit_W2_R_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END,visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_RIGHT));
  VISB_SVG_UPDATES10== rec(`id`:""W1L"",fill: IF SCICC_Zone_W1.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W1_L_PLUS_.Active = TRUE or SCICC_Transit_W1_L_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END,visibility: bool(SCICC_Point_W1.CurrentPosition = EulynxEndPosition_LEFT));
  VISB_SVG_UPDATES11== rec(`id`:""W2L"",fill: IF SCICC_Zone_W2.CurrentOccupancy = OccupancyStatus_OCCUPIED THEN IF SCICC_Transit_W2_L_PLUS_.Active = TRUE or SCICC_Transit_W2_L_MINUS_.Active = TRUE THEN ""green"" ELSE ""gray"" END ELSE ""red"" END,visibility: bool(SCICC_Point_W2.CurrentPosition = EulynxEndPosition_LEFT));
  VISB_SVG_UPDATES12== rec(`id`:""A"",fill: IF SCICC_Signal_A.signal_open = TRUE THEN ""green"" ELSE ""red"" END);
  VISB_SVG_UPDATES13== rec(`id`:""N2"",fill: IF SCICC_Signal_N2.signal_open = TRUE THEN ""green"" ELSE ""red"" END);
  VISB_SVG_UPDATES14== rec(`id`:""N1"",fill: IF SCICC_Signal_N1.signal_open = TRUE THEN ""green"" ELSE ""red"" END);
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
    END;
  {string.Join(";\n  ", interfaces.SelectMany(i => i.Value.Inputs?.Select(input => @$"Set_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key}(value) =
    BEGIN
      SIM_TIME := SIM_TIME + 150;
      SIM_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key} := value;
      BigStep({ProvideSimulationInputs(spec, interfaces)}, SIM_TIME);
      {(input.Value.Kind == InterfaceInputFieldKind.Discrete ? $"SIM_{i.Interface.Name}_{i.EntityType.Name}_{i.InterfaceInstanceName}_{input.Key} := {new TermWriter().VisitValueReference(input.Value.ParsedDefault!)}" : "skip")}
    END") ?? []))}
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
