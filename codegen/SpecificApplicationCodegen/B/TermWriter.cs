using Antlr4.Runtime.Misc;

static partial class BWriter
{
  private class TermWriter : ExpressionBaseVisitor<string>
  {
    public override string VisitExpression([NotNull] ExpressionParser.ExpressionContext context)
    {
      return Visit(context.orExpression());
    }

    public override string VisitOrExpression([NotNull] ExpressionParser.OrExpressionContext context)
    {
      return string.Join(" OR ", context.andExpression().Select(Visit));
    }

    override public string VisitAndExpression([NotNull] ExpressionParser.AndExpressionContext context)
    {
      return string.Join(" AND ", context.notExpression().Select(Visit));
    }

    public override string VisitNotExpression([NotNull] ExpressionParser.NotExpressionContext context)
    {
      if (context.notExpression() != null)
      {
        return "NOT " + Visit(context.notExpression());
      }
      else if (context.atom() != null)
      {
        return Visit(context.atom());
      }
      return "";
    }

    public override string VisitAtom([NotNull] ExpressionParser.AtomContext context)
    {
      if (context.comparison() != null)
      {
        return Visit(context.comparison());
      }
      else if (context.expression() != null)
      {
        return "(" + Visit(context.expression()) + ")";
      }
      else if (context.quantifierExpression() != null)
      {
        return Visit(context.quantifierExpression());
      }
      else if (context.timeoutExpression() != null)
      {
        return Visit(context.timeoutExpression());
      }
      return "";
    }

    public override string VisitTimeoutExpression([NotNull] ExpressionParser.TimeoutExpressionContext context)
    {
      if (context.valueReference() != null)
      {
        var reference = context.valueReference();
        return $"NOW >= {Visit(context.variableReference())} + {Visit(reference)}";
      }

      return $"NOW >= {Visit(context.variableReference())}";
    }

    public override string VisitQuantifierExpression([NotNull] ExpressionParser.QuantifierExpressionContext context)
    {
        var variableReference = $"{context.propertyName().GetText()[1..]}_{context.variableReference().graphOrInterfaceName().GetText()}_{context.variableReference().variableName().GetText()}";
        if (context.GetChild(0).GetText() == "All")
        {
            return $"!({context.quantifierVariableName().GetText()}).({context.quantifierVariableName().GetText()} : dom({variableReference}) => {variableReference}({context.quantifierVariableName().GetText()}) = {Visit(context.valueReference())} )";
        }
        else if (context.GetChild(0).GetText() == "Any")
        {
            return $"{Visit(context.valueReference())} : {variableReference}";
        }
        return "";
    }

    public override string VisitComparison([NotNull] ExpressionParser.ComparisonContext context)
    {
      return $"{Visit(context.variableReference())} {Visit(context.comparisonOperator())} {Visit(context.valueReference())}";
    }

    public override string VisitVariableReference([NotNull] ExpressionParser.VariableReferenceContext context)
    {
      if (context.graphOrInterfaceName() == null)
      {
        return context.variableName().GetText();
      }

      if (context.propertyName() == null)
      {
          return $"{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}";
      }

      return $"{context.propertyName().GetText()}_{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}";
    }

    public override string VisitValueReference([NotNull] ExpressionParser.ValueReferenceContext context)
    {
      if (context.qualifiedName() != null)
      {
        return Visit(context.qualifiedName());
      }
      if (context.propertyName() != null)
      {
        return Visit(context.propertyName());
      }
      if (context.booleanLiteral() != null)
      {
        return context.booleanLiteral().GetText().ToUpper();
      }

      return context.GetText();
    }

    public override string VisitQualifiedName([NotNull] ExpressionParser.QualifiedNameContext context)
    {
      return $"{context.enumerationTypeName().GetText()}_{context.enumerationLiteralName().GetText()}";
    }

    public override string VisitPropertyName([NotNull] ExpressionParser.PropertyNameContext context)
    {
      return context.GetText()[1..];
    }

    public override string VisitComparisonOperator([NotNull] ExpressionParser.ComparisonOperatorContext context)
    {
      return context.GetText() switch
      {
        "==" => "=",
        "!=" => "/=",
        _ => throw new NotSupportedException($"Unsupported comparison operator: {context.GetText()}")
      };
    }
  }
}
