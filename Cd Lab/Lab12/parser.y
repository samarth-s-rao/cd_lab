%{
#include<stdio.h>
#include<stdlib.h>
int yylex();
void yyerror(char* msg);
extern int yylineno;
extern char *yytext;
%}

%token VOID INT FLOAT DOUBLE CHAR STATIC ID INCLUDE HEADER MAIN DO WHILE IF ELSE FOR BOOL BREAK INC DEC STRLIT VNUM LT GT GTE LTE EQ NE OR AND LNOT SCOMB ECOMB SSQB ESQB SCURB ECURB SWITCH CASE DEFAULT
%start P
%%

P : S {printf("Valid Syntax\n"); YYACCEPT;}
  ;


S : INCLUDE HEADER S
  | STATIC S
  | MAINF S
  | DECLR ';' S
  | ASSGN ';' S
  | SWITCH SCOMB ID ECOMB SCURB CaseList DefaultCase ECURB ';' S
  |
  ;

DECLR : TYPE List_Var 
      | TYPE Array_Decl   
      | s
      ;

Array_Decl : ID sqaure_decl  
           ;

sqaure_decl : SSQB VNUM ESQB sqaure_decl
            | 
            ;

List_Var : List_Var ',' ID | ID 
         ;




TYPE : VOID | INT | FLOAT | CHAR | BOOL | DOUBLE 
     ;


ASSGN : TYPE ID '=' EXPR | ID '=' EXPR | STRLIT | TYPE ID '=' EXPR ',' ASSGN 
      ;

EXPR : EXPR RELOP E | E | ID INC | ID DEC | LNOT ID | S | EXPR '&&' EXPR
     ;

RELOP : GTE | LTE | EQ | NE | OR | AND | LT | GT
      ;

E : E'+'T | E'-'T | T
  ;

T : T'*'F | T'/'F | F
  ;

F : SCOMB EXPR ECOMB | ID | VNUM
  ;

MAINF : TYPE MAIN SCOMB Empty_ListVar ECOMB SCURB Stmt ECURB
     ;

Empty_ListVar : List_Var
              |
              ;

Stmt : SingleStmt Stmt | Block Stmt | BREAK ';'
     |
     ;

Ifelstmt : SingleStmt Stmt | Block Stmt
         ;

SingleStmt : DECLR ';' | ASSGN ';' | IF SCOMB COND ECOMB Ifelstmt | IF SCOMB COND ECOMB Ifelstmt ELSE Ifelstmt | LOOP | DO Block WHILE COND ';'
           | SWITCH SCOMB ID ECOMB SCURB CaseList DefaultCase ECURB 
           ;

Block : SCURB Stmt ECURB
      ;

LOOP : WHILE SCOMB COND ECOMB LOOP2
      | FOR SCOMB ASSGN ';' COND ';' UNARY ECOMB LOOP2 
      ;

UNARY : INC ID | ID INC | DEC ID| ID DEC | ID INC ',' ID INC | INC ID ',' INC ID | DEC ID ',' DEC ID | ID DEC ',' ID DEC
	; 

COND : EXPR | ASSGN 
     ;

LOOP2 : SCURB Stmt ECURB 
      |
      ;

CaseList : CASE VNUM ':' Stmt CaseList
         |
         ;

DefaultCase : DEFAULT ':' Stmt
            |
            ;

s : error;
%%

void yyerror(char* msg)
{
    printf("Error: %s, line number: %d, token: %s\n", msg, yylineno, yytext);
}

int main()
{
    yyparse();
}
