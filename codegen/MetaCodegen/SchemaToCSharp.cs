using System;
using System.IO;
using NJsonSchema;
using NJsonSchema.CodeGeneration.CSharp;
using NJsonSchema.CodeGeneration;

namespace FormalInterlocking.MetaCodegen
{
  public static class SchemaToCSharp
  {
    public static async Task Generate(string schemaPath, string outputPath)
    {
      var schema = await JsonSchema.FromFileAsync(schemaPath);
      var settings = new CSharpGeneratorSettings
      {
        Namespace = "FormalInterlocking.Model",
        ClassStyle = CSharpClassStyle.Poco,
        GenerateDataAnnotations = true
      };

      var resolver = new CustomTypeResolver(settings);
      var generator = new CSharpGenerator(schema, settings, resolver);
      var code = generator.GenerateFile();
      File.WriteAllText(outputPath, code);
    }

    private class CustomTypeResolver : CSharpTypeResolver
    {
      public CustomTypeResolver(CSharpGeneratorSettings settings)
          : base(settings)
      {
      }


      public override string Resolve(JsonSchema schema, bool isNullable, string? typeNameHint)
      {
        if (typeNameHint == "Min" || typeNameHint == "Max")
        {
          // Special handling for ConceptProperty.min and ConceptProperty.max
          return "Cardinality";
        }
        if (typeNameHint == "Default" && schema.Type == (JsonObjectType.Number | JsonObjectType.String | JsonObjectType.Boolean))
        {
          // Special handling for InterfaceInputField.default
          return "DefaultValue";
        }
        return base.Resolve(schema, isNullable, typeNameHint);
      }
    }
  }
}
