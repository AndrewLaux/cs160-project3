%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <stdio.h>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
	void yyerror(const char *);
%}

/* WRITEME: Write any definitions here. You can find information on
            //definitions here:
            //ftp://ftp.gnu.org/old-gnu/Manuals/flex-2.5.4/html_mono/flex.html#SEC10 */
numbers ([0-9])+
alpha ([a-zA-Z])+
identifier {alpha}({numbers}|{alpha})*



/* WRITEME: If you are going to use start conditions, write them here.
            //You can find more information on start conditions here:
            //ftp://ftp.gnu.org/old-gnu/Manuals/flex-2.5.4/html_mono/flex.html#SEC11
            //You will probably want to use exclusive conditions rather
            //than inclusive conditions (use the %x instead of the %s). */
%x COMMENT

%%

  /* WRITEME: Write your Flex token rules here */

"/*"            { BEGIN(COMMENT); }
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT><<EOF>>  { yyerror("dangling comment"); }
<COMMENT,INITIAL>"\n"  ;
<COMMENT>.   ;

"\t"              ;
" "               ;
"true"            { return T_TRUE; }
"false"           { return T_FALSE; }
"equals"          { return T_EQUALS; }
"and"             { return T_AND; }
"not"             { return T_NOT; }
"or"              { return T_OR; }
"return"          { return T_RETURN; } 
"do"              { return T_DO; }
"while"           { return T_WHILE; }
"if"              { return T_IF; }
"else"            { return T_ELSE; }
"boolean"         { return T_BOOLEAN;}
"integer"         { return T_INTEGER;}
"new"             { return T_NEW; }
"extends"         { return T_EXTENDS;}
"print"           { return T_PRINT; }
"->"              { return T_RTYPE; }
","               { return T_COMMA; }
"+"               { return T_PLUS; }
"-"               { return T_MINUS; }
"*"               { return T_MULT; }
"/"               { return T_DIVIDE; }
">"               { return T_GREATER; }
">="              { return T_GREATEREQ; }
"="               { return T_EQUALS; }
";"               { return T_SEMICOLON; }
"."               { return T_DOT; }
"("               { return T_OPENPAREN; }
")"               { return T_CLOSEPAREN; }
"{"               { return T_OPENBRACE; }
"}"               { return T_CLOSEBRACE; }
{identifier}      { return T_IDENTIFIER; }
{numbers}         { return T_NUM; }
<<EOF>>           { return 0; }
.                 { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
