using System.Net.Mime;
using Antlr4.Runtime.Misc;
using FormalInterlocking.Model;

namespace FormalInterlocking.Codegen;

// Visitor for converting ExpressionParser.ExpressionContext to Rust code
public class ExpressionToRustVisitor : ExpressionBaseVisitor<string>
{
  private readonly bool _useContext;
  private readonly IDictionary<string, InterfaceAssignment>? _interfaces;
  private readonly Dictionary<string, Interface> _allInterfaces;
  private readonly EntityType? _entityType;

  public ExpressionToRustVisitor(bool useContext = false, EntityType? entityType = null, List<Interface>? interfaces = null)
  {
    _useContext = useContext;
    _interfaces = entityType?.Interfaces;
    _allInterfaces = interfaces?.ToDictionary(i => i.Name, i => i) ?? new Dictionary<string, Interface>();
    _entityType = entityType;
  }

  public override string VisitExpression(ExpressionParser.ExpressionContext context)
  {
    return Visit(context.orExpr());
  }
  public override string VisitOrExpr(ExpressionParser.OrExprContext context)
  {
    var parts = context.andExpr().Select(Visit).ToList();
    if (parts.Count == 1)
      return parts[0];
    // Chain Option logic: propagate None if any part is None
    var expr = parts[0];
    for (int i = 1; i < parts.Count; i++)
    {
      expr = $"match ({expr}, {parts[i]}) {{\n    (Some(a), Some(b)) => Some(a || b),\n    _ => None\n  }}";
    }
    return expr;
  }
  public override string VisitAndExpr(ExpressionParser.AndExprContext context)
  {
    var parts = context.notExpr().Select(Visit).ToList();
    if (parts.Count == 1)
      return parts[0];
    // Chain Option logic: propagate None if any part is None
    var expr = parts[0];
    for (int i = 1; i < parts.Count; i++)
    {
      expr = $"match ({expr}, {parts[i]}) {{\n    (Some(a), Some(b)) => Some(a && b),\n    _ => None\n  }}";
    }
    return expr;
  }
  public override string VisitNotExpr(ExpressionParser.NotExprContext context)
  {
    if (context.NOT() != null)
      return $"!({Visit(context.notExpr())})";
    return Visit(context.atom());
  }
  public override string VisitAtom(ExpressionParser.AtomContext context)
  {
    if (context.expression() != null)
      return $"({Visit(context.expression())})";
    if (context.comparison() != null)
      return Visit(context.comparison());
    if (context.quantifierExpression() != null)
      return Visit(context.quantifierExpression());
    if (context.timeoutExpression() != null)
      return Visit(context.timeoutExpression());
    throw new TransformerException("Unsupported atom expression");
  }

  public override string VisitTimeoutExpression(ExpressionParser.TimeoutExpressionContext context)
  {
    var right = $"{Visit(context.variableReference())}.unwrap_or(timestamp {{ milliseconds: None }})";

    var valueReference = context.valueReference();
    if (valueReference != null)
    {
      var vRef = Visit(valueReference);
      return $"match ({right}.milliseconds, {vRef}) {{\n    (Some(t), Some(d)) => Some(now.milliseconds.unwrap_or(0) >= t + d as u64),\n    _ => None\n  }}";
    }

    return $"match ({right}.milliseconds) {{\n    Some(t) => Some(now.milliseconds.unwrap_or(0) >= t),\n    _ => None\n  }}";
  }

  public override string VisitQuantifierExpression(ExpressionParser.QuantifierExpressionContext context)
  {
    // Example: Any(r in @requested_left_by_routes | Route[r].State == RouteState::PREPARING)
    var quantifier = context.GetChild(0).GetText(); // Any
    var indexerName = context.quantifierVariableName().GetText(); // r
    var propertyName = context.propertyName().NAME_LOWER_SNAKE_CASE()?.GetText() ?? context.propertyName().NAME_ALL_LOWERCASE()?.GetText() ?? throw new TransformerException("Property name not found"); // requested_left_by_routes
    var refVar = context.variableReference(); // Route[r].State
    var valueReference = context.valueReference(); // RouteState::Preparing

    var rustQuant = quantifier == "Any" ? "any" : "all";
    var collection = propertyName;
    var indexField = refVar.propertyName()?.NAME_LOWER_SNAKE_CASE()?.GetText() ?? context.propertyName().NAME_ALL_LOWERCASE()?.GetText() ?? refVar.quantifierVariableName()?.GetText() ?? string.Empty;
    var variable = refVar.variableName().GetText();
    // self.entity.<indexField>.iter().any/all(|name| ctx.<collection>.get(name).unwrap().<variable> == ...)
    var isInterface = refVar.graphOrInterfaceName() != null && _allInterfaces.ContainsKey(refVar.graphOrInterfaceName().GetText());
    var op = context.compOp().GetText();
    var right = Visit(valueReference);
    if (isInterface)
    {
      var property = _entityType?.Properties?.SingleOrDefault(p => p.Key == collection);
      return $"Some(self.entity.{collection}.iter().{rustQuant}(|name| ctx.{property?.Value.Type}_{refVar.graphOrInterfaceName().GetText()}.get(name).unwrap().{variable} {op} Triggerable::Triggered({right})))";
    }

    return $"Some(self.entity.{collection}.iter().{rustQuant}(|name| ctx.{refVar.graphOrInterfaceName().GetText()}.get(name).unwrap().{variable} {op} {right}))";
  }

  public override string VisitComparison(ExpressionParser.ComparisonContext context)
  {
    var left = Visit(context.variableReference());
    var op = Visit(context.compOp());
    var right = Visit(context.valueReference());

    var leftRefersToInterface = context.variableReference().graphOrInterfaceName() != null && _allInterfaces?.ContainsKey(context.variableReference().graphOrInterfaceName().GetText()) == true;
    if (leftRefersToInterface)
    {
      // If either side is None, yield None; otherwise compare and wrap in Some(...)
      return $"match ({left}, Some(Triggerable::Triggered({right}))) {{\n    (Some(l), Some(r)) => Some(l {op} r),\n    _ => None\n  }}";
    }

    // General case: if either side is None, yield None; otherwise compare and wrap in Some(...)
    return $"match ({left}, Some({right})) {{\n    (Some(l), Some(r)) => Some(l {op} r),\n    _ => None\n  }}";
  }
  public override string VisitCompOp(ExpressionParser.CompOpContext context)
  {
    if (context.EQUAL() != null) return "==";
    if (context.NOTEQUAL() != null) return "!=";
    throw new TransformerException("Unsupported comparison operator");
  }
  public override string VisitVariableReference(ExpressionParser.VariableReferenceContext context)
  {
    if (context.quantifierVariableName() != null)
    {
        throw new TransformerException("Quantifier variable references should be handled in VisitQuantifierExpression");
    }

    if ((context.propertyName() != null || context.quantifierVariableName() != null) && _useContext)
    {
      // e.g. Zone[@underlying_zone].State becomes ctx.zone.get(&self.entity.underlying_zone).unwrap().state
      var graph = context.graphOrInterfaceName().GetText();

      // Find out if graph refers to a graph or an interface
      var isGraph = _allInterfaces == null || !_allInterfaces.ContainsKey(graph);
      if (isGraph)
      {
        var indexField = context.propertyName()?.NAME_LOWER_SNAKE_CASE()?.GetText() ?? context.propertyName()?.NAME_ALL_LOWERCASE()?.GetText() ?? context.quantifierVariableName()?.GetText() ?? throw new InvalidOperationException("Expected property name");
        var variable = context.variableName().GetText();

        var property = _entityType?.Properties?.SingleOrDefault(p => p.Key == indexField);
        var isOptional = property?.Value?.Min.Value == 0 && property?.Value?.Max.Value == 1;

        if (isOptional)
        {
          // Use Option<T> for optional properties
          return $"self.entity.{indexField}.as_ref().map(|x| ctx.{graph}.get(x).unwrap().{variable})";
        }

        return $"Some(ctx.{graph}.get(&self.entity.{indexField}).unwrap().{variable})";
      }
      else
      {
        var indexField = context.propertyName()?.NAME_LOWER_SNAKE_CASE()?.GetText() ?? context.propertyName()?.NAME_ALL_LOWERCASE()?.GetText() ?? context.quantifierVariableName()?.GetText() ?? throw new InvalidOperationException("Expected property name");
        var interfaceInput = context.variableName().GetText();

        var property = _entityType?.Properties?.SingleOrDefault(p => p.Key == indexField);
        var isOptional = property?.Value?.Min.Value == 0 && property?.Value?.Max.Value == 1;

        if (isOptional)
        {
          // Use Option<T> for optional properties
          return $"self.entity.{indexField}.as_ref().map(|x| ctx.{property?.Value?.Type}_{graph}.get(x).unwrap().{interfaceInput})";
        }

        return $"Some(ctx.{property?.Value?.Type}_{graph}.get(&self.entity.{indexField}).unwrap().{interfaceInput})";
      }
    }
    else if (_useContext && context.graphOrInterfaceName() != null)
    {
      // e.g. SCI_TDS.occupancy_status in Zone context becomes ctx.zone_sci_tds.get(&self.entity.name).unwrap().occupancy_status
      // or point_lock_right.State in Zone context becomes ctx.point_lock_right.get(&self.entity.name).unwrap().state
      var conceptName = _entityType?.Name ?? "";
      var first = context.graphOrInterfaceName().GetText();
      var variable = context.variableName().GetText();

      if (_interfaces?.ContainsKey(first) == true)
      {
        return $"Some(ctx.{conceptName}_{first}.get(&self.entity.name).unwrap().{variable})";
      }

      return $"Some(ctx.{first}.get(&self.entity.name).unwrap().{variable})";
    }
    else if (context.propertyName() != null)
    {
      // fallback: Zone[underlying_zone].State
      var graph = context.graphOrInterfaceName().GetText();
      var index = context.propertyName().GetText();
      var variable = context.variableName().GetText();
      return $"Some({graph}[{index}].{variable})";
    }
    else if (context.graphOrInterfaceName() != null && context.variableName() != null)
    {
      // e.g. SCI_TDS.occupancy_status
      var graph = context.graphOrInterfaceName().GetText();
      var variable = context.variableName().GetText();
      return $"Some({graph}.{variable})";
    }
    else
    {
      // e.g. PreviousPointState
      var variable = context.variableName().GetText();
      return $"Some(self.{variable})";
    }
  }
  public override string VisitValueReference(ExpressionParser.ValueReferenceContext context)
  {
    if (context.qualifiedName() != null)
    {
      return Visit(context.qualifiedName());
    }
    if (context.durationLiteral() != null)
    {
      return Visit(context.durationLiteral());
    }
    if (context.propertyName() != null)
    {
      return Visit(context.propertyName());
    }
    if (context.booleanLiteral() != null)
    {
      return Visit(context.booleanLiteral());
    }
    if (context.noneLiteral() != null)
    {
      return Visit(context.noneLiteral());
    }

    throw new TransformerException("Unsupported value reference");
  }

  public override string VisitQualifiedName(ExpressionParser.QualifiedNameContext context)
  {
    return context.GetText();
  }

  public override string VisitPropertyName([NotNull] ExpressionParser.PropertyNameContext context)
  {
    return $"self.entity.{context.NAME_LOWER_SNAKE_CASE()?.GetText() ?? context.NAME_ALL_LOWERCASE()?.GetText() ?? throw new TransformerException("Property name not found")}";
  }

  public override string VisitDurationLiteral([NotNull] ExpressionParser.DurationLiteralContext context)
  {
    // Convert duration literal, e.g., 1000ms
    var value = context.NUMBER().GetText();
    return $"Some({value})";
  }

  public override string VisitBooleanLiteral([NotNull] ExpressionParser.BooleanLiteralContext context)
  {
    return context.GetText().ToLowerInvariant();
  }

  public override string VisitNoneLiteral([NotNull] ExpressionParser.NoneLiteralContext context)
  {
    return "None";
  }
}
