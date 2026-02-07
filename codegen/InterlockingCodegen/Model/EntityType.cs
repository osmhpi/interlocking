namespace FormalInterlocking.Model;

partial class InterfaceInputField
{
  public ExpressionParser.ValueReferenceContext? ParsedDefault { get; set; }
}

partial class InterfaceOutputField
{
  public ExpressionParser.ValueReferenceContext? ParsedDefault { get; set; }
  public Dictionary<ExpressionParser.ValueReferenceContext, ExpressionParser.ExpressionContext> ParsedMapping { get; set; } = [];
}
