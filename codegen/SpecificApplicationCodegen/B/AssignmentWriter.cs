using Antlr4.Runtime.Misc;

static partial class BWriter
{
  private class AssignmentWriter : GraphBaseVisitor<string>
  {
    public override string VisitExpression([NotNull] GraphParser.ExpressionContext context)
    {
      return $"bool({Visit(context.orExpression())})";
    }

    public override string VisitOrExpression([NotNull] GraphParser.OrExpressionContext context)
    {
      return string.Join(" or ", context.andExpression().Select(Visit));
    }

    override public string VisitAndExpression([NotNull] GraphParser.AndExpressionContext context)
    {
      return string.Join(" & ", context.notExpression().Select(Visit));
    }

    public override string VisitNotExpression([NotNull] GraphParser.NotExpressionContext context)
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

    public override string VisitAtom([NotNull] GraphParser.AtomContext context)
    {
      if (context.comparison() != null)
      {
        return Visit(context.comparison());
      }
      else if (context.expression() != null)
      {
        return "(" + Visit(context.expression()) + ")";
      }
      return "";
    }

    public override string VisitTimeoutExpression([NotNull] GraphParser.TimeoutExpressionContext context)
    {
      if (context.valueReference() != null)
      {
        var reference = context.valueReference();
        return $"NOW >= {Visit(context.variableReference())} + {Visit(reference)}";
      }

      return $"NOW >= {Visit(context.variableReference())}";
    }

    public override string VisitQuantifierExpression([NotNull] GraphParser.QuantifierExpressionContext context)
    {
        var variableReference = $"{context.propertyName().GetText()[1..]}_{context.variableReference().graphOrInterfaceName().GetText()}_{context.variableReference().variableName().GetText()}";
        if (context.GetChild(0).GetText() == "All")
        {
            if (context.comparisonOperator().GetText() == "==")
            {
                return $"{{{Visit(context.valueReference())}}} = {variableReference}";
            }
            else if (context.comparisonOperator().GetText() == "!=")
            {
                return $"{Visit(context.valueReference())} /: {variableReference}";
            }
        }
        else if (context.GetChild(0).GetText() == "Any")
        {
            if (context.comparisonOperator().GetText() == "==")
            {
                return $"{Visit(context.valueReference())} : {variableReference}";
            }
            else if (context.comparisonOperator().GetText() == "!=")
            {
                return $"{{{Visit(context.valueReference())}}} /= {variableReference}";
            }
        }
        return "";
    }

    public override string VisitComparison([NotNull] GraphParser.ComparisonContext context)
    {
      return $"{Visit(context.variableReference())} {Visit(context.comparisonOperator())} {Visit(context.valueReference())}";
    }

    public override string VisitVariableReference([NotNull] GraphParser.VariableReferenceContext context)
    {
      if (context.graphOrInterfaceName() == null)
      {
        return context.variableName().GetText();
      }

      if (context.propertyName() == null)
      {
          return $"{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}";
      }

      return $"{context.propertyName().GetText()[1..]}_{context.graphOrInterfaceName().GetText()}_{context.variableName().GetText()}";
    }

    public override string VisitValueReference([NotNull] GraphParser.ValueReferenceContext context)
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
      if (context.durationLiteral() != null)
      {
        if (context.durationLiteral().NOW() != null)
        {
          return "NOW";
        }
        else
        {
          return context.durationLiteral().NUMBER().GetText();
        }
      }
      if (context.noneLiteral() != null)
      {
        return "0"; // timestamp of 0 represents None
      }

      return context.GetText();
    }

    public override string VisitQualifiedName([NotNull] GraphParser.QualifiedNameContext context)
    {
      return $"{context.enumerationTypeName().GetText()}_{context.enumerationLiteralName().GetText()}";
    }

    public override string VisitPropertyName([NotNull] GraphParser.PropertyNameContext context)
    {
      return context.GetText()[1..];
    }

    public override string VisitAssignment([NotNull] GraphParser.AssignmentContext context)
    {
      return $"{Visit(context.variableReference())} := {Visit(context.valueReference())};";
    }

    public override string VisitComparisonOperator([NotNull] GraphParser.ComparisonOperatorContext context)
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
