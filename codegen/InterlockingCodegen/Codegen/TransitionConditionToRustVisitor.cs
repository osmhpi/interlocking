using Antlr4.Runtime.Misc;

namespace FormalInterlocking.Codegen;

// Visitor for converting GraphParser.ExpressionContext to Rust code for transition conditions
// This version does NOT use EvalContext, but uses pre-computed term values (with _value suffix)
public class TransitionConditionToRustVisitor : GraphBaseVisitor<string>
{
  public TransitionConditionToRustVisitor() {}

  public override string VisitExpression(GraphParser.ExpressionContext context)
  {
    return Visit(context.orExpr());
  }
  public override string VisitOrExpr(GraphParser.OrExprContext context)
  {
    var parts = context.andExpr().Select(Visit).ToList();
    return string.Join(" || ", parts);
  }
  public override string VisitAndExpr(GraphParser.AndExprContext context)
  {
    var parts = context.notExpr().Select(Visit).ToList();
    return string.Join(" && ", parts);
  }
  public override string VisitNotExpr(GraphParser.NotExprContext context)
  {
    if (context.NOT() != null)
      return $"!({Visit(context.notExpr())})";
    return Visit(context.atom());
  }
  public override string VisitAtom(GraphParser.AtomContext context)
  {
    if (context.termReference() != null)
      return Visit(context.termReference());
    if (context.expression() != null)
      return $"({Visit(context.expression())})";
    if (context.comparison() != null)
      return Visit(context.comparison());
    return "/* unsupported atom */ false";
  }
  public override string VisitComparison(GraphParser.ComparisonContext context)
  {
    var left = Visit(context.variableReference());
    var op = Visit(context.compOp());
    var right = Visit(context.valueReference());
    return $"{left} {op} {right}";
  }
  public override string VisitCompOp(GraphParser.CompOpContext context)
  {
    if (context.EQUAL() != null) return "==";
    if (context.NOTEQUAL() != null) return "!=";
    return "/* unsupported op */";
  }
  public override string VisitTermReference(GraphParser.TermReferenceContext context)
  {
    // Always use the _value field for the term
    var names = context;
    // e.g. ZoneOccupied -> self.zone_occupied_value
    return $"self.{names.GetText()}_value";
  }

  public override string VisitVariableReference(GraphParser.VariableReferenceContext context)
  {
    // Always use the _value field for the term
    if (context.graphOrInterfaceName() == null)
    {
      // e.g. ZoneOccupied -> self.zone_occupied_value
      return $"self.{context.variableName().GetText()}_value";
    }
    else if (context.graphOrInterfaceName() != null && context.variableName() != null)
    {
      // e.g. SCI_TDS.ZoneOccupied -> self.zone_occupied_value
      return $"self.{context.variableName().GetText()}_value";
    }
    else
    {
      return "/* unsupported ref */ false";
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
