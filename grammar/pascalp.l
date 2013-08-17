/* pascalp.l - a lexical analyzer for Pascal-P4

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

%{
#include "y.tab.h"
%}

%option noyywrap yylineno

%x COMMENT
%%

[ \t\n]

"(*"    		    BEGIN COMMENT;
<COMMENT>(.|\n)
<COMMENT>"*)"       BEGIN INITIAL;

[0-9]+		        return INTCONST;
[0-9]+(\.[0-9]+)?(e[+-]?[0-9]+)?	return REALCONST;

''                  yyerror("empty string literal");
'([^']|'')*'        return STRINGCONST; /* string or char literal */

".."		        return COLON; /* .. and : are interchangeable in Pascal-P */
":"	    	        return COLON;
":="        		return BECOMES;
"."	            	return PERIOD;
"<"	               	return LTOP;
"<="        		return LEOP;
"<>"        		return NEOP;
">"	             	return GTOP;
">="        		return GEOP;
"("         		return LPARENT;
"+"	               	return PLUS;
"-"	            	return MINUS;
"*"	               	return MUL;
"/"	            	return RDIV;
")"	               	return RPARENT;
"="	            	return EQOP;
","	               	return COMMA;
"["	               	return LBRACK;
"]"	               	return RBRACK;
"^"     	    	return ARROW;
";"	               	return SEMICOLON;

"program"	        return PROGRAMSY;
"label"		        return LABELSY;
"procedure"	        return PROCEDURESY;
"const"		        return CONSTSY;
"type"		        return TYPESY;
"array"		        return ARRAYSY;
"packed"	        return PACKEDSY;
"of"		        return OFSY;
"end"		        return ENDSY;
"file"		        return FILESY;
"record"	        return RECORDSY;
"set"		        return SETSY;
"var"       		return VARSY;
"case"      		return CASESY;
"forward"       	return FORWARDSY;
"function"      	return FUNCTIONSY;
"begin"	        	return BEGINSY;
"else"	        	return ELSESY;
"if"	        	return IFSY;
"then"	        	return THENSY;
"do"	        	return DOSY;
"downto"        	return DOWNTOSY;
"for"	        	return FORSY;
"repeat"        	return REPEATSY;
"while"     		return WHILESY;
"to"        		return TOSY;
"until"	        	return UNTILSY;
"with"      		return WITHSY;
"not"       		return NOTSY;
"div"       		return IDIV;
"mod"	          	return IMOD;
"and"		        return ANDOP;
"or"		        return OROP;
"in"		        return INOP;
"goto"		        return GOTOSY;

[a-z][a-z0-9]*	    return IDENT;

.                   yyerror("invalid character");
