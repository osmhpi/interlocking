using Antlr4.Runtime.Misc;
using FormalInterlocking.Codegen;

// Visitor for converting GraphParser.ExpressionContext to Rust code for transition conditions
// This version does NOT use EvalContext, but uses pre-computed term values (with _value suffix)
public class TransitionConditionToBVisitor : GraphBaseVisitor<string>
{
  public TransitionConditionToBVisitor() {}

  public override string VisitExpression(GraphParser.ExpressionContext context)
  {
    return Visit(context.orExpression());
  }
  public override string VisitOrExpression(GraphParser.OrExpressionContext context)
  {
    var parts = context.andExpression().Select(Visit).ToList();
    return string.Join(" or ", parts);
  }
  public override string VisitAndExpression(GraphParser.AndExpressionContext context)
  {
    var parts = context.notExpression().Select(Visit).ToList();
    return string.Join(" & ", parts);
  }
  public override string VisitNotExpression(GraphParser.NotExpressionContext context)
  {
    if (context.NOT() != null)
      return $"not({Visit(context.notExpression())})";
    return Visit(context.atom());
  }
  public override string VisitAtom(GraphParser.AtomContext context)
  {
    if (context.termReference() != null)
      return $"{Visit(context.termReference())} = TRUE";
    if (context.expression() != null)
      return $"({Visit(context.expression())})";
    if (context.comparison() != null)
      return Visit(context.comparison());
    return "/* unsupported atom */ false";
  }
  public override string VisitComparison(GraphParser.ComparisonContext context)
  {
    var left = Visit(context.variableReference());
    var op = Visit(context.comparisonOperator());
    var right = Visit(context.valueReference());
    return $"{left} {op} {right}";
  }
  public override string VisitComparisonOperator(GraphParser.ComparisonOperatorContext context)
  {
    if (context.EQUAL() != null) return "==";
    if (context.NOTEQUAL() != null) return "!=";
    return "/* unsupported op */";
  }
  public override string VisitTermReference(GraphParser.TermReferenceContext context)
  {
    return context.GetText();
  }

  public override string VisitVariableReference(GraphParser.VariableReferenceContext context)
  {
    if (context.graphOrInterfaceName() == null)
    {
      // e.g. ZoneOccupied
      return context.variableName().GetText();
    }
    else if (context.graphOrInterfaceName() != null && context.variableName() != null)
    {
      // e.g. SCI_TDS.ZoneOccupied -> self.zone_occupied_value
      return $"{context.variableName().GetText()}_value";
    }
    else
    {
      throw new TransformerException($"Unsupported variable reference: {context.GetText()}");
    }
  }
  public override string VisitValueReference(GraphParser.ValueReferenceContext context)
  {
    return context.GetText();
  }
  public override string VisitQualifiedName(GraphParser.QualifiedNameContext context)
  {
    return context.GetText();
  }
}
