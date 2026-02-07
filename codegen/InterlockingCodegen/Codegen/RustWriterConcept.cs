using FormalInterlocking.Model;
using static ExpressionParser;
using FormalInterlocking.Codegen;

namespace FormalInterlocking.Codegen;

static partial class RustWriter
{
  internal static void WriteEntityTypeInterface(Interface ifaceDefinition, EntityType entityType, InterfaceAssignment iface, string outputPath, Specification specification)
  {
    var lines = new List<string>();
    lines.Add("// Auto-generated Rust interface for entity type-related interface ports");
    lines.Add("");
    lines.Add("use crate::{configuration_types::*, enums::*, eval_context::EvalContext, triggerable::Triggerable};");
    lines.Add("");
    lines.Add("#[derive(Clone)]");
    lines.Add($"pub struct {entityType.Name}_{ifaceDefinition.Name}Struct {{");
    lines.Add($"    pub entity: Entities{entityType.Name}Item,"); // Add the entity item as a field

    // Add fields for each input
    if (iface.Inputs != null)
    {
      foreach (var input in iface.Inputs)
      {
        string rustType;
        if (input.Value.Type == "boolean")
        {
          rustType = "bool";
        }
        else
        {
          var enumType = specification.ResolveRustEnumType(input.Value.Type);
          if (enumType != null)
          {
            rustType = enumType;
          }
          else
          {
            throw new InvalidOperationException($"Input '{input.Key}' in interface '{ifaceDefinition.Name}' of entity type '{entityType.Name}' has unsupported type '{input.Value.Type}'.");
          }
        }
        lines.Add($"    pub {input.Key}: Triggerable<{rustType}>, // input");
      }
    }

    // Add fields for each output
    if (iface.Outputs != null)
    {
      foreach (var output in iface.Outputs)
      {
        string rustType;
        if (output.Value.Type == "boolean")
        {
          rustType = "bool";
        }
        else
        {
          var enumType = specification.ResolveRustEnumType(output.Value.Type);
          if (enumType != null)
          {
            rustType = enumType;
          }
          else
          {
            throw new InvalidOperationException($"Output '{output.Key}' in interface '{ifaceDefinition.Name}' of entity type '{entityType.Name}' has unsupported type '{output.Value.Type}'.");
          }
        }
        lines.Add($"    pub {output.Key}: {rustType}, // output");
      }
    }

    lines.Add("}");
    lines.Add("");

    lines.Add($"impl {entityType.Name}_{ifaceDefinition.Name}Struct {{");
    lines.Add($"    pub fn new(entity: Entities{entityType.Name}Item) -> Self {{");
    lines.Add($"        Self {{");
    lines.Add($"            entity,"); // Add the entity item as a field
    if (iface.Inputs != null)
    {
      foreach (var input in iface.Inputs)
      {
        string defaultValue;
        if (input.Value.Type == "boolean")
        {
          defaultValue = input.Value.Default?.BoolValue == true ? "true" : "false";
        }
        else
        {
          var enumType = specification.ResolveRustEnumType(input.Value.Type);
          if (enumType != null && input.Value.ParsedDefault != null)
          {
            // Use the parsed enum literal
            var enumLiteral = input.Value.ParsedDefault.GetText();
            defaultValue = enumLiteral;
          }
          else
          {
            defaultValue = "Default::default()";
          }
        }
        lines.Add($"            {input.Key}: Triggerable::NotTriggered({defaultValue}),");
      }
    }
    if (iface.Outputs != null)
    {
      foreach (var output in iface.Outputs)
      {
        string defaultValue;
        if (output.Value.Type == "boolean")
        {
          defaultValue = output.Value.Default?.BoolValue == true ? "true" : "false";
        }
        else
        {
          var enumType = specification.ResolveRustEnumType(output.Value.Type);
          if (enumType != null && output.Value.ParsedDefault != null)
          {
            var enumLiteral = output.Value.ParsedDefault.GetText();
            defaultValue = enumLiteral;
          }
          else
          {
            defaultValue = "Default::default()";
          }
        }
        lines.Add($"            {output.Key}: {defaultValue},");
      }
    }
    lines.Add($"        }}");
    lines.Add($"    }}");

    // Add complete_cycle method for all interfaces
    lines.Add($"    pub fn complete_cycle(&mut self, ctx: &EvalContext) {{");
    foreach (var input in (iface.Inputs ?? new Dictionary<string, InterfaceInputField>()).Where(x => x.Value.Kind == InterfaceInputFieldKind.Discrete))
    {
      string defaultValue;
      if (input.Value.Type == "boolean")
      {
        defaultValue = input.Value.Default?.BoolValue == true ? "true" : "false";
      }
      else
      {
        var enumType = specification.ResolveRustEnumType(input.Value.Type);
        if (enumType != null && input.Value.ParsedDefault != null)
        {
          var enumLiteral = input.Value.ParsedDefault.GetText();
          defaultValue = enumLiteral;
        }
        else
        {
          defaultValue = "Default::default()";
        }
      }
      lines.Add($"        self.{input.Key} = Triggerable::NotTriggered({defaultValue});");
    }
    // Compute outputs using ExpressionToRustVisitor
    if (iface.Outputs != null)
    {
      foreach (var output in iface.Outputs)
      {
        // First, apply default value
        string defaultValue;
        if (output.Value.Type == "boolean")
        {
          defaultValue = output.Value.Default?.BoolValue == true ? "true" : "false";
        }
        else
        {
          var enumType = specification.ResolveRustEnumType(output.Value.Type);
          if (enumType != null && output.Value.ParsedDefault != null)
          {
            var enumLiteral = output.Value.ParsedDefault.GetText();
            defaultValue = enumLiteral;
          }
          else
          {
            defaultValue = "Default::default()";
          }
        }
        lines.Add($"        self.{output.Key} = {defaultValue};");

        // Then, apply mappings
        foreach (var mapping in output.Value.ParsedMapping)
        {
          var visitor = new ExpressionToRustVisitor(true, entityType, specification.Interfaces); // pass a flag to enable context-aware codegen
          var exprCode = visitor.Visit(mapping.Value);
          lines.Add($"        if ({exprCode}).unwrap_or(false) {{");
          lines.Add($"            self.{output.Key} = {mapping.Key.GetText()};");
          lines.Add($"        }}");
        }
      }
    }
    lines.Add($"    }}");
    lines.Add($"}}");
    lines.Add("");

    File.WriteAllText(outputPath, string.Join("\n", lines));
  }

  internal static void WriteConceptsModule(List<(string ConceptName, string InterfaceName)> conceptInterfaces, string outputPath, Specification spec)
  {
    var lines = new List<string>();
    lines.Add("// Auto-generated Rust module for concept-related interfaces");
    lines.Add("");

    foreach (var (conceptName, ifaceName) in conceptInterfaces)
    {
      lines.Add($"mod {conceptName}_{ifaceName};");
    }

    lines.Add("");
    lines.Add("// Re-export the interfaces for use in other modules");
    foreach (var (conceptName, ifaceName) in conceptInterfaces)
    {
      var structName = $"{conceptName}_{ifaceName}Struct";
      lines.Add($"pub use {conceptName}_{ifaceName}::{structName};");
    }
    lines.Add("");

    File.WriteAllText(outputPath, string.Join("\n", lines));
  }
}
