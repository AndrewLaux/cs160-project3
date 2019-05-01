%{
    #include <cstdlib>
    #include <cstdio>
    #include <iostream>

    #define YYDEBUG 1

    int yylex(void);
    void yyerror(const char *);
%}

%error-verbose

/* WRITEME: List all your tokens here */
%token T_TRUE T_FALSE
%token T_IDENTIFIER
%token T_EQUALS T_AND T_NOT T_OR
%token T_DOT T_SEMICOLON T_NEWLINE T_EOF T_COMMA T_EXTENDS
%token T_OPENPAREN T_CLOSEPAREN T_OPENBRACE T_CLOSEBRACE T_RETURN T_RTYPE 
%token T_PLUS T_MINUS T_DIVIDE T_MULT T_GREATER T_GREATEREQ
%token T_IF T_ELSE T_WHILE T_DO T_NEW
%token T_PRINT
%token T_NUM
%token T_INTEGER T_BOOLEAN

/* WRITEME: Specify precedence here */
%left T_GREATER T_GREATEREQ
%left T_PLUS T_MINUS 
%left T_DIVIDE T_MULT
%right T_NOT T_UNARYMINUS




%%

Start: C Class
      ;

C: %empty
  | C Class 
  ;

Class: T_IDENTIFIER T_OPENBRACE Members Methods T_CLOSEBRACE
  | T_IDENTIFIER T_EXTENDS T_IDENTIFIER T_OPENBRACE Members Methods T_CLOSEBRACE
  ;

Members: %empty
        | Members Type T_IDENTIFIER T_SEMICOLON 
        ;

Methods: %empty
        | T_IDENTIFIER T_OPENPAREN Parameters T_CLOSEPAREN T_RTYPE Type T_OPENBRACE Body T_CLOSEBRACE Methods
        ;

Body: Declarations Statements Return
    ;

Statements: %empty
  | Assignment Statements
  | Call Statements
  | If Statements
  | While Statements
  | Do Statements
  | Print Statements
  ;

Assignment: T_IDENTIFIER T_EQUALS Exp T_SEMICOLON
  | T_IDENTIFIER T_DOT T_IDENTIFIER T_EQUALS Exp T_SEMICOLON
  ;

Call: MethodCall T_SEMICOLON Statements
  ;

If: T_IF Exp T_OPENBRACE Statements T_CLOSEBRACE
  | T_IF Exp T_OPENBRACE Statements T_CLOSEBRACE T_ELSE T_OPENBRACE Statements T_CLOSEBRACE
  ;

While: T_WHILE Exp T_OPENBRACE Statements T_CLOSEBRACE
  ;

Do: T_DO T_OPENBRACE Statements T_CLOSEBRACE T_WHILE T_OPENPAREN Exp T_CLOSEPAREN T_SEMICOLON
  ;


Print: T_PRINT Exp T_SEMICOLON
  ;



Declarations: %empty
  | Declarations Type T_IDENTIFIER List T_SEMICOLON 
  ;

Return: %empty
  | T_RETURN Exp T_SEMICOLON
  ;

List: %empty
  | T_COMMA T_IDENTIFIER List
  ;

Parameters: %empty
  | Type T_IDENTIFIER
  | Parameters T_COMMA Type T_IDENTIFIER
  ;
      

Type: T_BOOLEAN
  |  T_INTEGER
  |  T_IDENTIFIER
  ;

Exp: Exp T_PLUS Exp
  | Exp T_MINUS Exp
  | Exp T_MULT Exp
  | Exp T_DIVIDE Exp
  | Exp T_GREATER Exp
  | Exp T_GREATEREQ Exp
  | Exp T_EQUALS Exp
  | Exp T_AND Exp
  | Exp T_OR Exp
  | T_NOT Exp
  | T_MINUS Exp %prec T_UNARYMINUS
  | T_IDENTIFIER
  | T_IDENTIFIER T_DOT T_IDENTIFIER
  | MethodCall
  | T_OPENPAREN Exp T_CLOSEPAREN
  | T_NUM
  | T_TRUE
  | T_FALSE
  | T_NEW T_IDENTIFIER
  | T_NEW MethodCall
  ;

MethodCall: T_IDENTIFIER T_OPENPAREN Arguments T_CLOSEPAREN
  | T_IDENTIFIER T_DOT T_IDENTIFIER T_OPENPAREN Arguments T_CLOSEPAREN
  ;

Arguments: %empty 
  | A
  ;

A: A T_COMMA Exp
  | Exp
  ;

%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(1);
}
