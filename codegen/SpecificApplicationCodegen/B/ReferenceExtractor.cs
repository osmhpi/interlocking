using Antlr4.Runtime.Misc;

static partial class BWriter
{
  record Reference(string? GraphOrInterfaceName, string VariableName, string? PropertyName, bool IsNow)
  {
    public string ToBString()
    {
      if (PropertyName != null)
      {
        return $"{PropertyName}_{GraphOrInterfaceName}_{VariableName}";
      }
      else if (GraphOrInterfaceName != null)
      {
        return $"{GraphOrInterfaceName}_{VariableName}";
      }
      else if (IsNow)
      {
        return "NOW";
      }
      else
      {
        return VariableName;
      }
    }
  }

  private class ReferenceExtractor : ExpressionBaseVisitor<List<Reference>>
  {
    public override List<Reference> VisitExpression([NotNull] ExpressionParser.ExpressionContext context)
    {
      if (context.orExpression() != null)
      {
        return Visit(context.orExpression());
      }
      return new List<Reference>();
    }

    public override List<Reference> VisitOrExpression([NotNull] ExpressionParser.OrExpressionContext context)
    {
      var inputs = new List<Reference>();
      foreach (var andExpr in context.andExpression())
      {
        inputs.AddRange(Visit(andExpr));
      }
      return inputs;
    }

    public override List<Reference> VisitAndExpression([NotNull] ExpressionParser.AndExpressionContext context)
    {
      var inputs = new List<Reference>();
      foreach (var notExpr in context.notExpression())
      {
        inputs.AddRange(Visit(notExpr));
      }
      return inputs;
    }

    public override List<Reference> VisitNotExpression([NotNull] ExpressionParser.NotExpressionContext context)
    {
      var inputs = new List<Reference>();
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

    public override List<Reference> VisitAtom([NotNull] ExpressionParser.AtomContext context)
    {
      var inputs = new List<Reference>();
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

    public override List<Reference> VisitComparison([NotNull] ExpressionParser.ComparisonContext context)
    {
      return Visit(context.variableReference());
    }

    public override List<Reference> VisitQuantifierExpression([NotNull] ExpressionParser.QuantifierExpressionContext context)
    {
      var variableReferences = Visit(context.variableReference());
      // Prefix variable references with quantifier property name
      var propertyName = context.propertyName().GetText()[1..];
      return variableReferences.Select(v => new Reference(v.GraphOrInterfaceName, v.VariableName, propertyName, false)).ToList();
    }

    public override List<Reference> VisitTimeoutExpression([NotNull] ExpressionParser.TimeoutExpressionContext context)
    {
      return Visit(context.variableReference());
    }

    public override List<Reference> VisitVariableReference([NotNull] ExpressionParser.VariableReferenceContext context)
    {
      if (context.graphOrInterfaceName() == null)
      {
        return [];
      }

      if (context.propertyName() != null)
      {
        return [new Reference(context.graphOrInterfaceName().GetText(), context.variableName().GetText(), context.propertyName().GetText()[1..], false)];
      }

      return [new Reference(context.graphOrInterfaceName().GetText(), context.variableName().GetText(), null, false)];
    }
  }
}
