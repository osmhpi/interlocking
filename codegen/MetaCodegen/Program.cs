using FormalInterlocking.MetaCodegen;

var schemaFiles = new[]
{
    ("entity_type.schema.json", "EntityType.Generated.cs"),
    ("enums.schema.json", "Enums.Generated.cs"),
    ("interface.schema.json", "Interface.Generated.cs"),
    ("schedule.schema.json", "Schedule.Generated.cs"),
    ("graph.terms.schema.json", "GraphTerms.Generated.cs")
};

foreach (var (schema, output) in schemaFiles)
{
    var schemaPath = Path.Combine("..", "..", "language", schema);
    var outputPath = Path.Combine("..", "InterlockingCodegen", "Model", output);
    await SchemaToCSharp.Generate(schemaPath, outputPath);
}
