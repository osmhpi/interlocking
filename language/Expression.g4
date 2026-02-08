// Expression.g4: ANTLR4 grammar for computed boolean expressions in state chart diagrams
grammar Expression;

// Parser rules
assignment
    : variableReference ASSIGN valueReference
    ;

expression
    : orExpr
    ;

orExpr
    : andExpr (OR andExpr)*
    ;

andExpr
    : notExpr (AND notExpr)*
    ;

notExpr
    : NOT notExpr
    | atom
    ;

atom
    : comparison
    | '(' expression ')'
    | quantifierExpression
    | timeoutExpression
    ;

timeoutExpression
    : NOW GTE variableReference (PLUS valueReference)?
    ;

quantifierExpression
    : ('Any' | 'All') '(' quantifierVariableName 'in' propertyName '|' variableReference compOp valueReference ')'
    ;

comparison
    : variableReference compOp valueReference
    ;
compOp
    : EQUAL
    | NOTEQUAL
    ;

propertyName
    : AT (NAME_LOWER_SNAKE_CASE | NAME_ALL_LOWERCASE)
    ;

graphOrInterfaceName
    : (NAME_PASCAL_CASE | NAME_ALL_UPPERCASE)
    ;

variableName
    : (NAME_PASCAL_CASE | NAME_ALL_UPPERCASE)
    ;

quantifierVariableName
    : (NAME_CAMEL_CASE | NAME_ALL_LOWERCASE)
    ;

// Graph or interface variable reference: NAME optionally followed by [NAME], then dot, then variable NAME
// e.g. SCI_TDS.occupancy_status or Zone[@underlying_zone].State
variableReference
    : graphOrInterfaceName (LBRACK (propertyName | quantifierVariableName) RBRACK)? DOT variableName
    | variableName
    ;

valueReference
    : qualifiedName
    | durationLiteral
    | propertyName
    | booleanLiteral
    | noneLiteral
    ;

// Qualified name (e.g., OccupancyStatus::OCCUPIED)
qualifiedName
    : enumerationTypeName DCOLON enumerationLiteralName
    ;

durationLiteral
    : NUMBER MILLISECONDS
    | NOW
    ;

booleanLiteral
    : 'true'
    | 'false'
    ;

noneLiteral
    : 'None'
    ;

enumerationTypeName
    : (NAME_PASCAL_CASE | NAME_ALL_UPPERCASE)
    ;

enumerationLiteralName
    : (NAME_UPPER_SNAKE_CASE | NAME_ALL_UPPERCASE)
    ;

// Lexer rules
AND: '&&';
OR: '||';
NOT: '!';
EQUAL: '==';
NOTEQUAL: '!=';
LBRACK: '[';
RBRACK: ']';
DOT: '.';
DCOLON: '::';
AT: '@';
NOW: 'now';
MILLISECONDS: 'ms';
GTE: '>=';
PLUS: '+';
NAME_ALL_LOWERCASE: [a-z][a-z0-9]*;
NAME_ALL_UPPERCASE: [A-Z][A-Z0-9]*;
NAME_LOWER_SNAKE_CASE: [a-z][a-z0-9_]*;
NAME_CAMEL_CASE: [a-z][A-Za-z0-9]*;
NAME_UPPER_SNAKE_CASE: [A-Z][A-Z0-9_]*;
NAME_PASCAL_CASE: [A-Z][A-Za-z0-9]*;
NUMBER: [0-9]+;
ASSIGN: '=';
PUMLNEWLINE: ('\\n') -> skip;
WS: [ \t\r\n]+ -> skip;
