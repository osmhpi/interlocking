grammar Graph;
import Expression;

// Parser rules

diagram      : STARTUML diagramName? diagramBody ENDUML ;
diagramName  : graphOrInterfaceName ;
diagramBody  : (transition | stateDecl | pseudostateDecl | comment | NEWLINE)* ;

transition   : stateRef ARROW stateRef (COLON transitionLabel)? NEWLINE ;
stateDecl    : stateRef COLON assignment NEWLINE
            | 'state' stateRef LBRACE diagramBody RBRACE NEWLINE
            ;

pseudostateDecl : 'state' pseudostateName PSEUDOSTATE NEWLINE ;
pseudostateName : NAME_CAMELCASE | NAME_ALL_LOWERCASE ;

stateRef     : INITIAL_STATE_NAME | pseudostateName | stateName ;
stateName    : NAME_UPPER_SNAKE_CASE | NAME_ALL_UPPERCASE ;

transitionLabel : priority? labelText ;
priority     : LBRACK INT RBRACK ;
labelText    : expression? ;

comment      : COMMENT ;

termRef      : (NAME_PASCALCASE | NAME_ALL_UPPERCASE) ;

// Override the atom rule to allow a direct term name (NAME)
atom
    : '(' expression ')'
    | comparison
    | termRef
    ;

// Lexer rules
STARTUML     : '@startuml' WS* ;
ENDUML       : '@enduml' WS* ;
ARROW        : '-->' | '-left->' | '-right->' | '\u2192' ;
COLON        : ':' ;
LBRACK       : '[' ;
RBRACK       : ']' ;
LBRACE       : '{';
RBRACE       : '}';
INITIAL_STATE_NAME   : '[*]' ;
INT          : [0-9]+ ;
COMMENT      : '//' ~[\r\n]* ;
NEWLINE      : ('\r'? '\n')+ ;
WS           : [ \t]+ -> skip ;
PSEUDOSTATE  : '<<choice>>' ;
