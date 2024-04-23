%{
#define YYSTYPE char*
#include "y.tab.h"
#include <stdio.h>
extern void yyerror(const char*); // declare the error handling function
extern YYSTYPE yylval;
%}

/* Regular definitions */
digit [0-9]
letter [a-zA-Z]
id {letter}({letter}|{digit}|_)*
digits {digit}+
opFraction (\.{digits})?
opExponent ([Ee][\+\-]?{digits})?
number {digits}{opFraction}{opExponent}

%option yylineno

%%

\/\/(.*)               ; // ignore comments
[\t\n ]                ; // ignore whitespaces

"int"                  {return T_INT;}
"char"                 {return T_CHAR;}
"double"               {return T_DOUBLE;}
"float"                {return T_FLOAT;}
"main"                 {return T_MAIN;}
"for"                  {return T_FOR;}
"while"                {return T_WHILE;}
"do"                   {return T_DO;}
"switch"               {return T_SWITCH;}
"case"                 {return T_CASE;}
"default"              {return T_DEFAULT;}
"break"                {return T_BREAK;}
"if"		       {return T_IF;}
"else"                 {return T_ELSE;}

\".*\"                 {yylval=strdup(yytext); return T_STRLITERAL;}
\".\"                  {yylval=strdup(yytext); return T_CHARLITERAL;}

"("                    {return *yytext;}
")"                    {return *yytext;}
"."                    {return *yytext;}
","                    {return *yytext;}
"{"                    {return *yytext;}
"}"                    {return *yytext;}
"*"                    {return *yytext;}
"+"                    {return *yytext;}
";"                    {return *yytext;}
"-"                    {return *yytext;}
"/"                    {return *yytext;}
"="                    {return *yytext;}
">"                    {return *yytext;}
"<"                    {return *yytext;}
"["                    {return *yytext;}
"]"                    {return *yytext;}
":"                    {return *yytext;}

"&&"                   {return T_LOGICAND;}
"||"                   {return T_LOGICOR;}
"!"                    {return T_NOT;}
"++"                   {return T_INC;}
"--"                   {return T_DEC;}
"stdio.h"              {return STD;}
"#include"	       {return INCLUDE;}

{number}               {yylval=strdup(yytext); return T_NUM;}
{id}                   {yylval=strdup(yytext); return T_ID;}

.                      {} // anything else => ignore

%%

int yywrap()
{
    return 1;
}


