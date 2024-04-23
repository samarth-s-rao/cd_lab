%{
#include "sym_tab.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char*

int type=-1; //initial declaration of type for symbol table
int vtype=-1; //initial declaration for type checking for symbol table
int scope=0; //initial declaration for scope
int valtype; // Variable to store the type of the value
void yyerror(char* s); // error handling function
int yylex(); // declare the function performing lexical analysis
extern int yylineno; // track the line number
%}

/* declare tokens */
%token T_INT T_CHAR T_DOUBLE T_FLOAT T_STRLITERAL T_CHARLITERAL T_MAIN T_ID T_NUM
%token T_FOR T_WHILE T_DO T_SWITCH T_CASE T_DEFAULT T_BREAK T_IF T_ELSE STD INCLUDE
%token T_LOGICAND T_LOGICOR T_NOT T_INC T_DEC

/* specify start symbol */
%start START

%%

START : PROG { printf("Valid syntax\n"); YYACCEPT; }

PROG :HEADER MAIN PROG /* main function */
     | /* end of program */
     ;

HEADER: INCLUDE '<' STD '>'
     ;

/* Grammar for main function */
MAIN : TYPE T_MAIN '(' ')' '{' {scope++;} STMT '}' {scope--; };

/* statements can be standalone, or parts of blocks */
STMT : DECLR ';' STMT
     | ASSGN ';' STMT
     | BLOCK STMT
     | LOOP STMT
     | SWITCH_STMT STMT
     | IF_STMT STMT
     |
     ;
     /* Grammar for loops */
IF_STMT : T_IF '(' E ')' BLOCK
	| T_IF '(' E ')' BLOCK T_ELSE BLOCK
	;
LOOP : FOR_LOOP
     | WHILE_LOOP
     | DO_WHILE_LOOP
     ;

FOR_LOOP : T_FOR '(' DECLR ';' E ';' DECLR ')' BLOCK
         ;

WHILE_LOOP : T_WHILE '(' E ')' BLOCK
           ;

DO_WHILE_LOOP : T_DO BLOCK T_WHILE '(' E ')' ';'
               ;

/* Grammar for switch statement */
SWITCH_STMT : T_SWITCH '(' E ')' '{' {scope++; } CASE_STMT '}' {scope--; }
            ;

CASE_STMT : CASE_STMT CASE STMT
          | CASE_STMT DEFAULT STMT
          ;

CASE : T_CASE E ':' {
        if(valtype != vtype)
        {
            printf("Type mismatch in case statement\n");
            yyerror($2);
        }
        else
        {
            printf("Adding CASE value: %s\n", $2);
        }
    }
    ;

DEFAULT : T_DEFAULT ':';

BLOCK : '{' {scope++;} STMT '}' {scope--;};



/* Grammar for variable declaration */
DECLR : TYPE LISTVAR {
                    printf("Declaration of type  with list of variables\n");
                }
      | TYPE '[' T_NUM ']' LISTVAR {
                    printf("Declaration of type with array of size  and list of variables\n");
                }
      |LISTVAR
      ; /* always terminate with a ; */

LISTVAR : LISTVAR ',' VAR {
                            printf("Additional variable in the list\n");
                        }
        | VAR {
                printf("First variable in the list\n");
            }
        ;


VAR : T_ID '=' E {
                if(check_sym_tab($1))
                {
                if (retrieve_scope($1) != scope) {
                    // Insert a new entry into the symbol table
                    insert_symbol($1, size(type), type, yylineno, scope);
                }
            
                    printf("Variable %s already declared\n",$1);
                    insert_val($1,$3,yylineno,scope);
                    //yyerror($1);
                }
                else
                {
                    insert_symbol($1,size(type),type,yylineno,scope);
                    insert_val($1,$3,yylineno,scope);
                    printf("Inserting variable %s  %s\n", $1,$3);
                }
            }
    | T_ID '[' T_NUM ']' {
                if(check_sym_tab($1))
                {
                    printf("Variable %s already declared\n",$1);
                    yyerror($1);
                }
                else
                {
                    insert_symbol($1,size(type) * atoi($3),type,yylineno,scope);
                    printf("Inserting array variable %s\n", $1);
                }
            }
    
    | T_ID T_INC {
        if(check_sym_tab($1))
        {
            char* value=retrieve_val($1);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$1);
                yyerror($1);
            }
            else
            {
                int val = atoi(value) + 1;
                sprintf($$,"%d",val);
                insert_val($1,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
    | T_ID T_DEC {
        if(check_sym_tab($2))
        {
            char* value=retrieve_val($2);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$2);
                yyerror($2);
            }
            else
            {
                int val = atoi(value) - 1;
                sprintf($$,"%d",val);
                insert_val($2,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
    | T_INC T_ID {
        if(check_sym_tab($2))
        {
            char* value=retrieve_val($2);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$2);
                yyerror($2);
            }
            else
            {
                int val = atoi(value) + 1;
                sprintf($$,"%d",val);
                insert_val($2,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
    | T_DEC T_ID {
        if(check_sym_tab($2))
        {
            char* value=retrieve_val($2);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$2);
                yyerror($2);
            }
            else
            {
                int val = atoi(value) - 1;
                sprintf($$,"%d",val);
                insert_val($2,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
    
    | T_ID
    ;



ASSGN : T_ID '[' T_NUM ']' '=' E {
                if(!check_sym_tab($1))
                {
                    printf("Variable %s not declared\n",$1);
                    yyerror($1);
                }
                else
                {
                    int index = atoi($3);
                    if (index >= 0 && index < 5) // Assuming a fixed array size of 5
                    {
                        char* value = retrieve_val($1);
                        if (value != "~")
                        {
                            sprintf(value + index, "%s", $6);
                            printf("Assigning value to array %s[%d]\n", $1, index);
                        }
                        else
                        {
                            printf("Array %s not initialized\n", $1);
                            yyerror($1);
                        }
                    }
                    else
                    {
                        printf("Array index out of bounds\n");
                        yyerror($3);
                    }
                }
            }
      ;

E : E T_LOGICOR T {
        if (vtype == 2 && valtype == 2)
            sprintf($$, "%d", (atoi($1) || atoi($3)));
        else {
            printf("Type mismatch in logical operation\n");
            yyerror($$);
            $$ = "~";
        }
    }
  | E T_LOGICAND T {
        if (vtype == 2 && valtype == 2)
            sprintf($$, "%d", (atoi($1) && atoi($3)));
        else {
            printf("Type mismatch in logical operation\n");
            yyerror($$);
            $$ = "~";
        }
    }
  | T_NOT T {
        if (vtype == 2 && valtype == 2){
                   sprintf($$, "%d", !(atoi($2)));
                   printf("entered here %s",$$);}
        else {
            printf("Type mismatch in logical operation\n");
            yyerror($$);
            $$ = "~";
        }
    }
  | E '>' T
  | E '<' T
  | E '<''=' T
  | E '>''=' T
  | E '=''=' T

  
  | E '+' T {
                if(vtype==2 && valtype==2)
                    sprintf($$,"%d",(atoi($1)+atoi($3)));
                else if(vtype==3 && valtype==3)
                    sprintf($$,"%f",(atof($1)+atof($3)));
                else
                {
                    printf("Type mismatch in arithmetic operation\n");
                    yyerror($$);
                    $$="~";
                }
            }
  | E '-' T {
                if(vtype==2 && valtype==2)
                    sprintf($$,"%d",(atoi($1)-atoi($3)));
                else if(vtype==3 && valtype==3)
                    sprintf($$,"%f",(atof($1)-atof($3)));
                else
                {
                    printf("Type mismatch in arithmetic operation\n");
                    yyerror($$);
                    $$="~";
                }
            }
  | T
  ;

T : T '*' F {
                if(vtype==2 && valtype==2)
                    sprintf($$,"%d",(atoi($1)*atoi($3)));
                else if(vtype==3 && valtype==3)
                    sprintf($$,"%f",(atof($1)*atof($3)));
                else
                {
                    printf("Type mismatch in arithmetic operation\n");
                    yyerror($$);
                    $$="~";
                }
            }
  | T '/' F {
                if(vtype==2 && valtype==2)
                    sprintf($$,"%d",(atoi($1)/atoi($3)));
                else if(vtype==3 && valtype==3)
                    sprintf($$,"%f",(atof($1)/atof($3)));
                else
                {
                    printf("Type mismatch in arithmetic operation\n");
                    yyerror($$);
                    $$="~";
                }
            }
  | F
  ;

F : '(' E ')' {$$ = $2;}
  | T_ID {
        if(check_sym_tab($1))
        {
            char* value=retrieve_val($1);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$1);
                yyerror($1);
            }
            else
            {
                $$=strdup(value);
                vtype=type_check(value);
                valtype=retrieve_type($1);
            }
        }
    }
  | T_ID '[' E ']' {
        if(check_sym_tab($1))
        {
            char* value=retrieve_val($1);
            if(value=="~")
            {
                printf("Array %s not initialized\n" ,$1);
                yyerror($1);
            }
            else
            {
                int index = atoi($3);
                if (index >= 0 && index < 5) // Assuming a fixed array size of 5
                {
                    sprintf($$, "%c", value[index]);
                    vtype=retrieve_type($1);
                    valtype=vtype;
                }
                else
                {
                    printf("Array index out of bounds\n");
                    yyerror($3);
                    $$ = "~";
                }
            }
        }
    }
  | T_NUM {
        $$=strdup($1);
        vtype=type_check($1);
        valtype=vtype;
    }
  | T_STRLITERAL {
        $$=strdup($1);
        vtype=-1;
        valtype=-1;
    }
  | T_CHARLITERAL {
        $$=strdup($1);
        vtype=1;
        valtype=1;
    }
  | T_INC T_ID {
        if(check_sym_tab($2))
        {
            char* value=retrieve_val($2);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$2);
                yyerror($2);
            }
            else
            {
                int val = atoi(value) + 1;
                sprintf($$,"%d",val);
                //$$=strdup(val);
                insert_val($2,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
  | T_DEC T_ID {
        if(check_sym_tab($2))
        {
            char* value=retrieve_val($2);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$2);
                yyerror($2);
            }
            else
            {
                int val = atoi(value) - 1;
                sprintf($$,"%d",val);
                insert_val($2,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
  | T_ID T_INC {
        if(check_sym_tab($1))
        {
            char* value=retrieve_val($1);
            if(value=="~")
            {
                printf("Variable %s not initialized\n" ,$1);
                yyerror($1);
            }
            else
            {
                int val = atoi(value) + 1;
                sprintf($$,"%d",val);
                insert_val($1,$$,yylineno,scope);
                vtype=2;
                valtype=2;
            }
        }
    }
  ;

TYPE : T_INT {type = INT;} //INT=2
     | T_FLOAT {type = FLOAT;} //FLOAT=3
     | T_DOUBLE {type = DOUBLE;} //DOUBLE=4
     | T_CHAR {type = CHAR;} //CHAR=1
     ;

%%

/* error handling function */
void yyerror(char* s)
{
    printf("Error :%s at %d \n",s,yylineno);
}

/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
    t=init_table();
    yyparse();
    display_sym_tab();

return 0;
}
