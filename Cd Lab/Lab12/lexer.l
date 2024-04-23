%{
#include<stdio.h>
#include "y.tab.h"
int yywrap();
int yylineno;
%}

start	\/\*
end	\*\/
letter [a-zA-Z]
digit [0-9]
identifier {letter}(_|{letter}|{digit})*
fractional_part (\.{digit})?
exponent_part ([Ee][+-]?{digit}+)?
numeric_literal {sign}{digit}+{fractional_part}{exponent_part}
string_literal \".*\"
sign [+-]?

%%

\/\/(.*) ;
\/\*(.*\n)*.*\*\/  {};

void 	return VOID;
int	return INT;
float	return FLOAT;
char	return CHAR;
bool	return BOOL;
if	return IF;
else	return ELSE;
for	return FOR;
while	return WHILE;
do	return DO;
break	return BREAK;
double	return DOUBLE;
static 	return STATIC;
main	return MAIN;
#include return INCLUDE;
"<"(.+)".h>" return HEADER;
"<"	return LT;
">"	return GT;
"++"	return INC;
"--"	return DEC;
"||"	return OR;
"&&"	return AND;
"!"	return LNOT;
"("	return SCOMB;
")"	return ECOMB;
">="	return GTE;	
"<="	return LTE;
"=="	return EQ;
"!="	return NE;
"["	return SSQB;
"]"	return ESQB;
"{"	return SCURB;
"}"	return ECURB;
"switch" return SWITCH;   // Added for switch statement
"case"	return CASE;     // Added for switch statement
"default" return DEFAULT; // Added for switch statement
{identifier}	return ID;
{numeric_literal}	return VNUM;
{string_literal}	return STRLIT;
\r	;
[' '|'\t']	;
\n	++yylineno;
.	return *yytext;

%%
int yywrap()
{
return 1;
}