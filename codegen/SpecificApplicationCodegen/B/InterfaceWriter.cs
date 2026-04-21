using FormalInterlocking.Model;

static partial class BWriter
{
  public static void WriteInterface(Specification spec, Interface systemInterface, InterfaceAssignment intf, EntityType entityType, string outputPath)
  {
    if (systemInterface == null) throw new ArgumentNullException(nameof(systemInterface));
    if (intf == null) throw new ArgumentNullException(nameof(intf));
    if (entityType == null) throw new ArgumentNullException(nameof(entityType));
    if (string.IsNullOrEmpty(outputPath)) throw new ArgumentException("Output path cannot be null or empty.", nameof(outputPath));

    var directory = Path.GetDirectoryName(outputPath);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var content = GenerateInterfaceContent(spec, systemInterface, intf, entityType);
    File.WriteAllText(outputPath, content);
  }

  private static string? GenerateInterfaceContent(Specification spec, Interface systemInterface, InterfaceAssignment intf, EntityType entityType)
  {
    return @$"MACHINE {systemInterface.Name}_{entityType.Name}
SEES Enums
VARIABLES
INVARIANT
INITIALIZATION
OPERATIONS
END//MACHINE
";
  }
}
