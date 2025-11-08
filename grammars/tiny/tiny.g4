// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true, alignSemicolons hanging, alignColons hanging

grammar tiny;

program
    : 'BEGIN' stmt_list 'END' EOF
    ;

stmt_list
    : stmt_list stmt
    | stmt
    ;

stmt
    : assign_stmt
    | read_stmt
    | write_stmt
    ;

assign_stmt
    : ident ':=' expr
    ;

read_stmt
    : 'READ' id_list
    ;

write_stmt
    : 'WRITE' expr_list
    ;

id_list
    : id_list ',' ident
    | ident
    ;

expr_list
    : expr_list ',' expr
    | expr
    ;

expr
    : expr op factor
    | factor
    ;

factor
    : ident
    | integer
    ;

integer
    : '-'? NUMBER
    ;

op
    : '+'
    | '-'
    ;

ident
    : ID
    ;

ID
    : ('a' .. 'z' | 'A' .. 'Z')+
    ;

NUMBER
    : ('0' .. '9')+
    ;

WS
    : [ \r\n] -> skip
    ;