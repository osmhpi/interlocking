using Antlr4.Runtime.Misc;

static partial class BWriter
{
  private class ReferenceExtractor : ExpressionBaseVisitor<List<string>>
  {
    public override List<string> VisitExpression([NotNull] ExpressionParser.ExpressionContext context)
    {
      if (context.orExpression() != null)
      {
        return Visit(context.orExpression());
      }
      return new List<string>();
    }

    public override List<string> VisitOrExpression([NotNull] ExpressionParser.OrExpressionContext context)
    {
      var inputs = new List<string>();
      foreach (var andExpr in context.andExpression())
      {
        inputs.AddRange(Visit(andExpr));
      }
      return inputs;
    }

    public override List<string> VisitAndExpression([NotNull] ExpressionParser.AndExpressionContext context)
    {
      var inputs = new List<string>();
      foreach (var notExpr in context.notExpression())
      {
        inputs.AddRange(Visit(notExpr));
      }
      return inputs;
    }

    public override List<string> VisitNotExpression([NotNull] ExpressionParser.NotExpressionContext context)
    {
      var inputs = new List<string>();
      if (context.notExpression() != null)
      {
        inputs.AddRange(Visit(context.notExpression()));
      }
      else if (context.atom() != null)
      {
        inputs.AddRange(Visit(context.atom()));
      }
      return inputs;
    }

    public override List<string> VisitAtom([NotNull] ExpressionParser.AtomContext context)
    {
      var inputs = new List<string>();
      if (context.comparison() != null)
      {
        inputs.AddRange(Visit(context.comparison()));
      }
      else if (context.expression() != null)
      {
        inputs.AddRange(Visit(context.expression()));
      }
      else if (context.quantifierExpression() != null)
      {
        inputs.AddRange(Visit(context.quantifierExpression()));
      }
      else if (context.timeoutExpression() != null)
      {
        inputs.AddRange(Visit(context.timeoutExpression()));
      }
      return inputs;
    }

    public override List<string> VisitComparison([NotNull] ExpressionParser.ComparisonContext context)
    {
      return Visit(context.variableReference());
    }

    public override List<string> VisitQuantifierExpression([NotNull] ExpressionParser.QuantifierExpressionContext context)
    {
      var variableReferences = Visit(context.variableReference());
      // Prefix variable references with quantifier property name
      var propertyName = context.propertyName().GetText()[1..];
      return variableReferences.Select(v => $"{propertyName}_{v}").ToList();
    }

    public override List<string> VisitTimeoutExpression([NotNull] ExpressionParser.TimeoutExpressionContext context)
    {
      return Visit(context.variableReference());
    }

    public override List<string> VisitVariableReference([NotNull] ExpressionParser.VariableReferenceContext context)
    {
      if (context.graphOrInterfaceName() == null)
      {
        return [];
      }

      if (context.propertyName() != null)
      {
        return [$"{context.propertyName().GetText()[1..]}_{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}"];
      }

      return [$"{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}"];
    }
  }
}
