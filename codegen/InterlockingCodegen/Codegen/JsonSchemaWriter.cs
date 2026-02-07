namespace FormalInterlocking.Codegen;

public static class JsonSchemaWriter
{
  public static void WriteJsonSchema(string outputPath, Model.Specification specification)
  {
    var builtinProperties = new Dictionary<string, Model.ConceptProperty>
    {
      ["name"] = new Model.ConceptProperty
      {
        Description = "The name of the concept instance.",
        Type = "string",
        Min = new Model.Cardinality(1),
        Max = new Model.Cardinality(1)
      }
    };

    // Build a JSON schema that allows an object with one property per concept
    // Each property is an object with the concept's parameters as properties
    var schema = new Dictionary<string, object?>
    {
      ["$schema"] = "http://json-schema.org/draft-07/schema#",
      ["title"] = "Entities",
      ["type"] = "object",
      ["properties"] = specification.EntityTypes.ToDictionary(
        concept => concept.Name,
        concept => new {
          type = "array",
          items = new {
            type = "object",
            properties = (concept.Properties ?? new Dictionary<string, Model.ConceptProperty>())
              .Concat(builtinProperties).ToDictionary(
              p => p.Key,
              p => {
                var min = p.Value.Min?.Value;
                var max = p.Value.Max?.Value;
                var isUnbounded = p.Value.Max != null && p.Value.Max.IsUnbounded;
                var propType = p.Value.Type == "boolean" ? "boolean" :
                               p.Value.Type == "integer" ? "integer" :
                               p.Value.Type == "number" ? "number" :
                               p.Value.Type == "string" ? "string" :
                               p.Value.Type == "duration" ? "integer" :
                               "object";
                var propSchema = new Dictionary<string, object?>
                {
                  ["type"] = propType,
                  ["description"] = p.Value.Description
                };
                if (min.HasValue && min.Value > 0)
                  propSchema["minItems"] = min.Value;
                if (max.HasValue && max.Value > 0)
                  propSchema["maxItems"] = max.Value;
                if (isUnbounded)
                  propSchema.Remove("maxItems");
                // If cardinality allows multiple, wrap in array
                if ((min.HasValue && min.Value > 1) || (max.HasValue && (max.Value > 1 || isUnbounded)))
                {
                  return new Dictionary<string, object?> {
                    ["type"] = "array",
                    ["items"] = propSchema,
                    ["minItems"] = min,
                    ["maxItems"] = isUnbounded ? null : max
                  };
                }
                // If this property is a reference to another concept (not a primitive type)
                bool isReference = !(propType == "boolean" || propType == "integer" || propType == "number" || propType == "string");
                if (isReference)
                {
                  // Single reference
                  if (max == 1)
                  {
                    return new Dictionary<string, object?> {
                      ["type"] = "string",
                      ["description"] = p.Value.Description
                    };
                  }
                  // Multiple references
                  else
                  {
                    return new Dictionary<string, object?> {
                      ["type"] = "array",
                      ["items"] = new Dictionary<string, object?> { ["type"] = "string" },
                      ["description"] = p.Value.Description,
                      ["minItems"] = min,
                      ["maxItems"] = isUnbounded ? null : max
                    };
                  }
                }
                return propSchema;
              }
            ),
            required = concept.Properties?.Where(p => p.Value.Min != null && p.Value.Min.Value > 0).Select(p => p.Key).Append("name").ToArray(),
            additionalProperties = false
          },
          minItems = 0
        }
      ),
      ["additionalProperties"] = false
    };

    var json = Newtonsoft.Json.JsonConvert.SerializeObject(schema, Newtonsoft.Json.Formatting.Indented);
    File.WriteAllText(outputPath, json);
  }
}
