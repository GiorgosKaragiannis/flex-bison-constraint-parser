%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "types.h"
%}

%option yylineno

ws [ \t]+
newline \n|\x0A|\x0D\x0A

%%

"var"           { return T_VAR; }
"par"           { return T_PAR; }
"set_of"        { return T_SET_OF; }
"bool"          { return T_BOOL; }
"int"           { return T_INT; }
"float"         { return T_FLOAT; }
"intersect"     { return T_INTERSECT; }
"union"         { return T_UNION; }
"diff"          { return T_DIFF; }
"constraint"    { return T_CONSTRAINT; }
"and"           { return T_AND; }
"or"            { return T_OR; }
"==>"           { return T_IMPLIES; }
"true"          { return T_TRUE; }
"false"         { return T_FALSE; }
"subset"        { return T_SUBSET; }
"in"            { return T_IN; }
"solve"         { return T_SOLVE; }
"satisfy"       { return T_SATISFY; }
"maximize"      { return T_MAXIMIZE; }

".."            { return T_DOTDOT; }
">="            { return T_GE; }
"=<"            { return T_LE; }
">"             { return '>'; }
"<"             { return '<'; }
"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
":"             { return ':'; }
";"             { return ';'; }

[0-9]+          { 
    yylval.valNum.val = atof(yytext); 
    yylval.valNum.type = 1; 
    return T_NUM; 
}
[0-9]+\.[0-9]+  { 
    yylval.valNum.val = atof(yytext); 
    yylval.valNum.type = 2; 
    return T_NUM; 
}

[a-zA-Z][a-zA-Z0-9_]* { 
    yylval.sval = strdup(yytext); 
    return T_ID; 
}

{ws}            { /* do nothing */ }
{newline}       { /* Do nothing, yylineno counts automatically */ }
.               { /* Do nothing */ }

%%
