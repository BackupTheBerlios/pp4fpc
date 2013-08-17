/* pascalp.y - a syntaxic analyzer for Pascal-P4

   Copyright (c) 2013 by Christophe Staiesse

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/* Aims to recognize the same language as the Pascal-P4 compiler that is 
   commented in the book "Pascal Implementation" by Steven Pemberton and
   Martin Daniels.

   There is one expected shift/reduce conflict due to dangling else issue.

   Compile:
     make or:
     yacc -d pascalp.y
     lex pascalp.l
     cc y.tab.c lex.yy.c -o ppparser
   
   You can test it with pcom.pas preprocessed by ppp.pas.
*/

%{
#include <stdio.h>
#include <stdlib.h>

int yylineno;
%}

%token GOTOSY PROGRAMSY IDENT SEMICOLON ARRAYSY LABELSY CONSTSY FORWARDSY
%token DOSY DOWNTOSY FORSY REPEATSY WHILESY TOSY UNTILSY WITHSY  CASESY
%token PROCEDURESY PACKEDSY OFSY FILESY ENDSY SETSY VARSY THENSY RECORDSY 
%token FUNCTIONSY BEGINSY BECOMES TYPESY IFSY ELSESY INOP NOTSY IDIV IMOD
%token ANDOP OROP

%token LTOP LEOP GTOP GEOP NEOP EQOP PLUS MINUS MUL RDIV 

%token COMMA PERIOD COLON ARROW LBRACK RBRACK LPARENT RPARENT

%token REALCONST INTCONST STRINGCONST

%%

/* procedure programme */

program:
    PROGRAMSY IDENT file_id_list_opt SEMICOLON block PERIOD ;

file_id_list_opt:
    LPARENT id_list RPARENT
    |
    ;

id_list:
    id_list COMMA IDENT
    | IDENT
    ;

/* procedure block */

block:
    label_decl_block_opt const_decl_block_opt type_decl_block_opt
    var_decl_block_opt procedure_decl_block_opt body;

procedure_decl_block_opt:
    procedure_decl_block_opt procedure_decl
    |
    ;

/* procedure labeldeclaration */

label_decl_block_opt:
    LABELSY label_list SEMICOLON
    |
    ;

label_list:
    label_list COMMA INTCONST
    | INTCONST
    ;

/* procedure constdeclaration */

const_decl_block_opt:
    CONSTSY const_decl_list
    |
    ;

const_decl_list:
    const_decl_list const_decl
    | const_decl
    ;

const_decl: IDENT EQOP constant SEMICOLON ;

/* procedure constant */

constant:
    STRINGCONST /* string or char literal */
    | scalar_constant
    | PLUS scalar_constant
    | MINUS scalar_constant
    ;

scalar_constant:
    IDENT
    | INTCONST
    | REALCONST
    ;

/* procedure typedeclaration */

type_decl_block_opt:
    TYPESY type_decl_list
    |
    ;

type_decl_list:
    type_decl_list type_decl
    | type_decl
    ;

type_decl :
    IDENT EQOP type SEMICOLON ;

/* procedure typ */

type:
    simple_type
    | ARROW IDENT
    | packed_opt ARRAYSY LBRACK simple_type RBRACK OFSY type
    | packed_opt RECORDSY record_body ENDSY 
    | packed_opt SETSY OFSY simple_type
    | packed_opt FILESY /* not implemented */
    ;

packed_opt:
    PACKEDSY
    |
    ;

/* procedure simpletype */

simple_type: 
    LPARENT id_list RPARENT
    | IDENT
    | constant COLON constant
    ;

/* procedure fieldlist */

record_body:
    record_field_list record_case ; /* Note: SEMICOLON optional before CASESY */

record_field_list:
    record_field_list SEMICOLON record_field 
    | record_field 
    ;

record_field:
    id_list COLON type
    | /* allows empty block, SEMICOLON at end of block and consecutive SEMICOLONs */
    ;

record_case:
    CASESY IDENT COLON IDENT OFSY record_case_field_list
    |
    ;

record_case_field_list:
    record_case_field_list SEMICOLON record_case_field
    | record_case_field
    ;

record_case_field:
    constant_list COLON LPARENT record_body RPARENT 
    | /* allows empty block, SEMICOLON at end of block and consecutive SEMICOLONs */
    ;

constant_list: 
    constant_list COMMA constant
    | constant
    ;

/* procedure vardeclaration */

var_decl_block_opt:
    VARSY var_decl_list
    |
    ;

var_decl_list:
    var_decl_list var_decl
    | var_decl
    ;

var_decl:
    id_list COLON type SEMICOLON ;

/* procedure procdeclaration */

procedure_decl:
    PROCEDURESY IDENT parameter_list_opt SEMICOLON FORWARDSY SEMICOLON
    | FUNCTIONSY IDENT parameter_list_opt COLON IDENT SEMICOLON FORWARDSY SEMICOLON
    | PROCEDURESY IDENT parameter_list_opt SEMICOLON block SEMICOLON
    | FUNCTIONSY IDENT parameter_list_opt COLON IDENT SEMICOLON block SEMICOLON
    ;

/* procedure parameterlist */

parameter_list_opt:
    LPARENT parameter_decl_list RPARENT
    |
    ;

parameter_decl_list:
    parameter_decl_list SEMICOLON parameter_decl
    | parameter_decl
    ;

parameter_decl:
    PROCEDURESY id_list /* not implemented */
    | FUNCTIONSY id_list COLON IDENT /* not implemented */
    | VARSY id_list COLON IDENT
    | id_list COLON IDENT
    ;

/* procedure body */

body:
    BEGINSY statement_list ENDSY;

statement_list:
    statement_list SEMICOLON statement
    | statement /* compound statements are allowed */
    ;

/* procedure statement */

statement:
    statement_no_label
    | INTCONST COLON statement_no_label
    ;

statement_no_label:
    assignment
    | call
    | compound_statement
    | goto_statement
    | if_statement
    | case_statement
    | while_statement
    | repeat_statement
    | for_statement
    | with_statement
    | /* allows empty block, SEMICOLON at end of block and consecutive SEMICOLONs */
    ;  

/* procedure call */

call:
    IDENT
    | call_with_args
    ;

call_with_args:
    IDENT LPARENT argument_list RPARENT ;

argument_list:
    argument_list COMMA argument
    | argument
    ;

argument:
    expression
    | expression COLON expression /* only valid with write and writeln */
    ;

/* procedure assignment */

assignment:
    selector BECOMES expression ;

/* procedure selector */

selector:
    selector LBRACK expression_list RBRACK
    | selector PERIOD IDENT
    | selector ARROW
    | IDENT
    ;

expression_list:
    expression_list COMMA expression
    | expression
    ;

/* procedure compoundstatement */

compound_statement:
    BEGINSY statement_list ENDSY ;

/* procedure gotostatement */

goto_statement:
    GOTOSY INTCONST ;

/* procedure ifstatement */

if_statement:
    IFSY expression THENSY statement
    | IFSY expression THENSY statement ELSESY statement /* shift-reduce conflict */
    ;

/* procedure casestatement */

case_statement:
    CASESY expression OFSY case_list ENDSY;

case_list:
    case_list SEMICOLON case
    | case
    ;

case:
    constant_list COLON statement
    | /* allows empty block, SEMICOLON at end of block and consecutive SEMICOLONs */
    ;

/* procedure whilestatement */

while_statement:
    WHILESY expression DOSY statement ;

/* procedure repeatstatement */

repeat_statement:
    REPEATSY statement_list UNTILSY expression

/* procedure forstatement */

for_statement: 
    FORSY IDENT BECOMES expression TOSY expression DOSY statement ;
    | FORSY IDENT BECOMES expression DOWNTOSY expression DOSY statement ;

/* procedure withstatement */

with_statement:
    WITHSY selector_list DOSY statement
    ;

selector_list:
    selector_list COMMA selector
    | selector
    ;

/* procedure expression */

expression: 
    simple_expression
    | expression INOP simple_expression
    | expression LTOP simple_expression
    | expression LEOP simple_expression
    | expression GTOP simple_expression
    | expression GEOP simple_expression
    | expression NEOP simple_expression
    | expression EQOP simple_expression
    ;

/* procedure simpleexpression */

simple_expression:
    term
    | PLUS term
    | MINUS term
    | simple_expression PLUS term
    | simple_expression MINUS term
    | simple_expression OROP term
    ;

/* procedure term */

term:
    factor
    | term MUL factor
    | term RDIV factor
    | term IDIV factor
    | term IMOD factor
    | term ANDOP factor
    ;

/* procedure factor */

factor:
    selector /* variable access or function call without args */
    | call_with_args
    | INTCONST
    | REALCONST
    | STRINGCONST /* string or char literal */
    | LPARENT expression RPARENT
    | NOTSY factor
    | LBRACK expression_list_opt RBRACK
    ;

expression_list_opt:
    expression_list
    |
    ;

%%

int yyerror (char *s)
{
    fprintf (stderr, "%s near line %d\n", s, yylineno);
    exit(1);
}

int main() {
    return yyparse()?1:0;
}
