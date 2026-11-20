%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int yylex();
void yyerror (const char * msg);
extern int yylineno;

#include "types.h"
#include "symbolTable.h"

ST_TABLE_TYPE symbolTable;

ParType check_range(int type1, float val1, int type2, float val2);
%}

%define parse.error verbose

%union {
    char *sval;
    struct {
        float val;
        int type;
    } valNum;
    ParType pType;
}

%token T_VAR T_PAR T_SET_OF T_BOOL T_INT T_FLOAT
%token T_INTERSECT T_UNION T_DIFF T_CONSTRAINT
%token T_AND T_OR T_IMPLIES T_TRUE T_FALSE
%token T_SUBSET T_IN T_SOLVE T_SATISFY T_MAXIMIZE
%token T_DOTDOT T_GE T_LE

%token <valNum> T_NUM
%token <sval> T_ID

%type <pType> Base_type Range_type NumExpression BoolExpr BoolArg SetExpression Arg

%nonassoc T_IMPLIES
%left T_OR
%left T_AND
%left '+' '-'
%left '*' '/'

%%

Model : {symbolTable=NULL;} Items
      ;

Items : Item ';' Items
      | error ';' Items
      | /* empty*/
      ;

Item : VarPar_item
     | Constraint_item
     | Solve_item
     ;

VarPar_item : T_VAR Base_type ':' T_ID {
                if (lookup(symbolTable, $4)) {
                    printf("Var %s Already Declared!\n", $4);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $4, $2);
                }
            }
            | T_VAR T_SET_OF Base_type ':' T_ID {
                ParType set_type = ($3 == type_integer) ? type_int_set : type_float_set;
                if (lookup(symbolTable, $5)) {
                    printf("Var %s Already Declared!\n", $5);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $5, set_type);
                }
            }
            | T_VAR Range_type ':' T_ID {
                if ($2 == type_error) { YYERROR; }
                ParType rng_type = ($2 == type_integer) ? type_integer : type_float;
                if (lookup(symbolTable, $4)) {
                    printf("Var %s Already Declared!\n", $4);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $4, rng_type);
                }
            }
            | T_VAR T_SET_OF Range_type ':' T_ID {
                if ($3 == type_error) { YYERROR; }
                ParType set_type = ($3 == type_integer) ? type_int_set : type_float_set;
                if (lookup(symbolTable, $5)) {
                    printf("Var %s Already Declared!\n", $5);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $5, set_type);
                }
            }
            | T_PAR Base_type ':' T_ID {
                ParType par_type = ($2 == type_integer) ? type_par_int : type_par_float;
                if (lookup(symbolTable, $4)) {
                    printf("Var %s Already Declared!\n", $4);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $4, par_type);
                }
            }
            | T_PAR T_SET_OF Range_type ':' T_ID {
                if ($3 == type_error) { YYERROR; }
                ParType par_type = ($3 == type_integer) ? type_par_int_set : type_par_float_set;
                if (lookup(symbolTable, $5)) {
                    printf("Var %s Already Declared!\n", $5);
                    YYERROR;
                } else {
                    addvar(&symbolTable, $5, par_type);
                }
            }
            ;

Base_type : T_BOOL  { $$ = type_bool; }
          | T_INT   { $$ = type_integer; }
          | T_FLOAT { $$ = type_float; }
          ;

Range_type : T_NUM T_DOTDOT T_NUM {
                $$ = check_range($1.type, $1.val, $3.type, $3.val);
           }
           ;

RelOp : '>' | '<' | '=' | T_GE | T_LE
      ;

Set_Ops : T_INTERSECT | T_UNION | T_DIFF
        ;

Constraint_item : T_CONSTRAINT BoolExpr
                ;

BoolExpr : BoolExpr T_IMPLIES BoolExpr { $$ = type_bool; }
         | BoolExpr T_AND BoolExpr     { $$ = type_bool; }
         | BoolExpr T_OR BoolExpr      { $$ = type_bool; }
         | BoolArg                     { $$ = $1; }
         ;

BoolArg : NumExpression RelOp NumExpression {
            if ($1 == type_error || $3 == type_error) { YYERROR; }
            if ($1 != $3) {
                printf("Type missmatch in line %d\n", yylineno);
                YYERROR;
            }
            $$ = type_bool;
        }
        | SetExpression { $$ = type_bool; }
        | T_TRUE  { $$ = type_bool; }
        | T_FALSE { $$ = type_bool; }
        | T_ID {
            if (!lookup(symbolTable, $1)) {
                printf("Undefined Variable %s\n", $1);
                YYERROR;
            } else {
                ParType t = lookup_type(symbolTable, $1);
                if (t != type_bool) {
                    printf("Type missmatch in line %d\n", yylineno);
                    YYERROR;
                }
                $$ = type_bool;
            }
        }
        ;

NumExpression : NumExpression '+' NumExpression {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if ($1 != $3 || ($1 != type_integer && $1 != type_float && $1 != type_par_int && $1 != type_par_float)) {
                    printf("Type missmatch in line %d\n", yylineno);
                    YYERROR;
                }
                $$ = $1;
              }
              | NumExpression '-' NumExpression {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if ($1 != $3) {
                    printf("Type missmatch in line %d\n", yylineno);
                    YYERROR;
                }
                $$ = $1;
              }
              | NumExpression '*' NumExpression {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if ($1 != $3) {
                    printf("Type missmatch in line %d\n", yylineno);
                    YYERROR;
                }
                $$ = $1;
              }
              | NumExpression '/' NumExpression {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if ($1 != $3) {
                    printf("Type missmatch in line %d\n", yylineno);
                    YYERROR;
                }
                $$ = $1;
              }
              | Arg { $$ = $1; }
              ;

SetExpression : Arg T_SUBSET Arg Set_Ops Arg {
                if ($1 == type_error || $3 == type_error || $5 == type_error) { YYERROR; }
                if ($3 != $5) {
                    printf("Type mismatch in sets, line %d\n", yylineno);
                    YYERROR;
                }
                $$ = type_bool;
              }
              | Arg T_SUBSET Arg {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if (($1 != type_int_set && $1 != type_float_set && $1 != type_par_int_set && $1 != type_par_float_set) || 
                    ($3 != type_int_set && $3 != type_float_set && $3 != type_par_int_set && $3 != type_par_float_set)) {
                    printf("Args are not sets, line %d\n", yylineno);
                    YYERROR;
                }
                $$ = type_bool;
              }
              | Arg T_IN Arg {
                if ($1 == type_error || $3 == type_error) { YYERROR; }
                if (($1 == type_integer && ($3 == type_int_set || $3 == type_par_int_set)) || 
                    ($1 == type_float && ($3 == type_float_set || $3 == type_par_float_set)) ||
                    ($1 == type_par_int && ($3 == type_int_set || $3 == type_par_int_set)) ||
                    ($1 == type_par_float && ($3 == type_float_set || $3 == type_par_float_set))) {
                    $$ = type_bool;
                } else {
                    printf("Type mismatch in line %d\n", yylineno);
                    YYERROR;
                }
              }
              ;

Arg : T_NUM { 
        $$ = ($1.type == 1) ? type_integer : type_float; 
    }
    | T_ID {
        if (!lookup(symbolTable, $1)) {
            printf("Undefined Variable %s\n", $1);
            YYERROR;
        } else {
            $$ = lookup_type(symbolTable, $1);
        }
    }
    ;

Solve_item : T_SOLVE SolutionType
           ;

SolutionType : T_SATISFY
             | T_MAXIMIZE T_ID {
                 if (!lookup(symbolTable, $2)) {
                     printf("Undefined Variable %s\n", $2);
                     YYERROR;
                 }
             }
             ;

%%

ParType check_range(int type1, float val1, int type2, float val2) {
    if (type1 != type2) {
        printf("Wrong Ranges declared (line %d). Should be of same type.\n", yylineno);
        return type_error;
    }
    if (val1 >= val2) {
        printf("Wrong Ranges declared (line %d). Should be of same type.\n", yylineno);
        return type_error;
    }
    return (type1 == 1) ? type_integer : type_float;
}

#include "constraints.lex.c"

void yyerror (const char * msg)
{
    /* Αποσιωπούμε το γενικό "syntax error" γιατί τα δικά μας μηνύματα είναι πιο ακριβή (όπως θέλει ο καθηγητής) */
    if (strcmp(msg, "syntax error") != 0) {
        fprintf(stderr,"Error(line %d) : %s\n", yylineno, msg);
    }
}

int main(int argc, char **argv ){
   ++argv, --argc;
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;

   int result = yyparse();

   if (result == 0 && yynerrs == 0)
      printf("Syntax OK!\n");
   else
      printf("There were %d errors in code. Failure!\n", yynerrs);
   return result;
}
