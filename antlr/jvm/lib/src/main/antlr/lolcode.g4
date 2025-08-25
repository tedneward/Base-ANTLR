/*
Reference: https://github.com/jynnantonix/lolcode/blob/master/BNFGrammar.txt
*/
grammar lolcode;

program: comment? opening code_block? closing? EOF;
   
opening
   : 'HAI' version?
   ;

version
   : '1.0'
   | '1.1'
   | '1.2'
   ;

closing
   : 'KTHXBYE'
   ;

code_block: statement+;

statement
   : declaration
   | expression
   | comment
   | print_block
   | input_block
   | assignment
   | if_block
   | loop
   | func_decl
   /*
   | import
    */
   ;

comment
   : SINGLE_LINE_COMMENT 
   | MULTI_LINE_COMMENT
   ;

declaration
   : 'I HAS A' LABEL 
   | 'I HAS A' LABEL 'ITZ' expression
   ;

print_block
   : 'VISIBLE' expression* 'MKAY?'?
   ;

input_block
   : 'GIMMEH' LABEL
   ;

assignment
   : LABEL 'R' expression
   ;

loop
   : 'IM IN YR' LABEL 'WILE' expression code_block 'IM OUTTA YR' LABEL
   ;

if_block
   : expression ', O RLY?' 'YA RLY' code_block 'OIC'
   | expression ', O RLY?' 'YA RLY' code_block 'NO WAI' elseBlock=code_block 'OIC'
   ;

else_if_block
   : 'MEBBE' expression code_block else_if_block
   | 'MEBBE' expression code_block
   ;

func_decl
   : 'HOW DUZ I' name=LABEL (('YR' LABEL) ('AN YR' LABEL)*)? code_block 'IF U SAY SO'
   ;

/*
import
   : 'CAN HAS' LABEL '?'
   ;
*/

expression
   : func_call
   | maths
   | comparison
   | logical
   | unary_op
   | atom=ATOM
   | label=LABEL
   ;

maths
   : op=('PRODUKT OF'|'QUOSHUNT OF'|'MOD OF') left=expression 'AN' right=expression
   | op=('SUM OF'|'DIFF OF') left=expression 'AN' right=expression
   ;

comparison
   : op=('BOTH SAEM'|'DIFFRINT'|'BIGGR OF'|'SMALLR OF') left=expression 'AN' right=expression
   ;

logical
   : op=('ALL OF'|'ANY OF') expression ('AN' expression)* 'MKAY?'
   | op=('BOTH OF'|'EITHER OF') left=expression 'AN' right=expression
   ;

unary_op
   : 'NOT' expression
   ;

func_call
   : name=LABEL (('YR' expression) ('AN YR' expression)*)? 'MKAY?'
   ;

ATOM
   : 'WIN'
   | 'FAIL'
   | 'NOOB'
   | ('0' .. '9')+
   | ('0' .. '9')* '.' ('0' .. '9')*
   | '-' ('0' .. '9')+
   | '-' ('0' .. '9')* '.' ('0' .. '9')*
   | STRING
   ;

LABEL
   : ('a' .. 'z' | 'A' .. 'Z') ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_')*
   ;

STRING
   : '"' ('\'"' | ~ '"')* '"'
   ;

NEWLINE
   : ('\r'? '\n' | '\r' | '\n')+ -> skip
   ;

WS
   : (' ' | '\t') -> skip
   ;

SINGLE_LINE_COMMENT
   : 'BTW' ~('\r' | '\n')* -> skip
   ;

MULTI_LINE_COMMENT
   : 'OBTW' .*? 'TLDR' -> skip
   ;

/* ============= 
   Not going to use types but here's the declarations for posterity's sake
   ============= 
cast
   : 'MAEK' expression 'A' < type >
   ;
type
   : 'YARN'
   | 'NUMBR'
   | 'NUMBAR'
   | 'TROOF'
   | 'BUKKIT'
   ;
 */
