using static ExpressionParser;

namespace FormalInterlocking.Model;

partial class Term
{
  public ExpressionContext? ParsedTree { get; set; }
}

partial class Variable
{
  public ValueReferenceContext? ParsedDefault { get; set; }
}
