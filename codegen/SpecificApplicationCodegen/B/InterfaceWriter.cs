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
    var inputs = intf.Inputs ?? new Dictionary<string, InterfaceInputField>();
    var outputs = intf.Outputs ?? new Dictionary<string, InterfaceOutputField>();

    var allInputs = CollectAllInputsToInterface(spec, intf);

    return @$"MACHINE {systemInterface.Name}_{entityType.Name}
SEES Enums
VARIABLES
  {inputs.Select(t => $"{t.Key}")
    .Concat(outputs.Select(t => $"{t.Key}"))
    .Aggregate((a, b) => a + ",\n  " + b)}
INVARIANT
  {inputs.Select(v => $"{v.Key} : {(v.Value.Type == "boolean" ? "BOOL" : v.Value.Type)}")
    .Concat(outputs.Select(v => $"{v.Key} : {(v.Value.Type == "boolean" ? "BOOL" : v.Value.Type)}"))
    .Aggregate((a, b) => a + " &\n  " + b)}
INITIALIZATION
  {inputs.Select(t => $"{t.Key} := {new TermWriter().VisitValueReference(t.Value.ParsedDefault!)}")
    .Concat(outputs.Select(v => $"{v.Key} := {new TermWriter().VisitValueReference(v.Value.ParsedDefault!)}"))
    .Aggregate((a, b) => a + ";\n  " + b)}
OPERATIONS
  ComputeOutputs({string.Join(", ", allInputs)}) =
    BEGIN
      {string.Join(" ||\n      ", outputs.Select(t => WriteMapping(t.Key, t.Value.ParsedDefault, t.Value.ParsedMapping)))}
    END
END//MACHINE
";
  }

  private static string WriteMapping(string key, ExpressionParser.ValueReferenceContext? parsedDefault, Dictionary<ExpressionParser.ValueReferenceContext, ExpressionParser.ExpressionContext> parsedMapping)
  {
    // (t.Value.ParsedMapping != null ? new TermWriter().Visit(t.Value.ParsedTree) : t.Value.Default.ToString().ToUpper())}"
    var lines = new List<string>();
    var first = true;
    foreach (var mapping in parsedMapping)
    {
      if (first)
        lines.Add($"IF {new TermWriter().VisitExpression(mapping.Value)} = TRUE THEN");
      else
        lines.Add($"ELSIF {new TermWriter().VisitExpression(mapping.Value)} = TRUE THEN");
      lines.Add($"  {key} := {new TermWriter().VisitValueReference(mapping.Key)}");
      first = false;
    }

    if (parsedMapping.Count > 0)
    {
      lines.Add("ELSE");
    }

    lines.Add($"  {key} := {new TermWriter().VisitValueReference(parsedDefault!)}");

    if (parsedMapping.Count > 0)
    {
      lines.Add("END");
    }

    return string.Join("\n      ", lines);
  }

  private static List<string> CollectAllInputsToInterface(Specification spec, InterfaceAssignment intf)
  {
      var inputs = new List<string>();

      // From terms
      foreach (var term in (intf.Outputs ?? new Dictionary<string, InterfaceOutputField>()).SelectMany(x => x.Value.ParsedMapping))
      {
          foreach (var input in new ReferenceExtractor().Visit(term.Value) ?? [])
          {
              inputs.Add(input.ToBString());
          }
      }

      // Remove duplicates but keep defined order
      return inputs.Distinct().ToList();
  }
}
