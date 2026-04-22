using FormalInterlocking.Model;

static partial class BWriter
{
  internal static void WriteEnums(Enums enums, string v)
  {
    if (enums == null) throw new ArgumentNullException(nameof(enums));
    if (string.IsNullOrEmpty(v)) throw new ArgumentException("Output path cannot be null or empty.", nameof(v));

    var directory = Path.GetDirectoryName(v);
    if (directory != null && !Directory.Exists(directory))
    {
      Directory.CreateDirectory(directory);
    }

    var lines = new List<string>();
    lines.Add("MACHINE Enums");
    lines.Add("SETS");

    foreach (var enumDef in enums.Enums1)
    {
      var enumName = char.ToUpperInvariant(enumDef.Key[0]) + enumDef.Key.Substring(1);
      lines.Add($"  E_{enumName} = {{{string.Join(", ", enumDef.Value.Enum.Select(v => enumName + "_" + char.ToUpperInvariant(v[0]) + v.Substring(1)))}}};");
    }
    lines[^1] = lines[^1].TrimEnd(';');
    lines.Add("END");

    File.WriteAllText(v, string.Join("\n", lines));
  }
}
