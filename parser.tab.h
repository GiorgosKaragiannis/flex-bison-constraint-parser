/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    T_VAR = 258,                   /* T_VAR  */
    T_PAR = 259,                   /* T_PAR  */
    T_SET_OF = 260,                /* T_SET_OF  */
    T_BOOL = 261,                  /* T_BOOL  */
    T_INT = 262,                   /* T_INT  */
    T_FLOAT = 263,                 /* T_FLOAT  */
    T_INTERSECT = 264,             /* T_INTERSECT  */
    T_UNION = 265,                 /* T_UNION  */
    T_DIFF = 266,                  /* T_DIFF  */
    T_CONSTRAINT = 267,            /* T_CONSTRAINT  */
    T_AND = 268,                   /* T_AND  */
    T_OR = 269,                    /* T_OR  */
    T_IMPLIES = 270,               /* T_IMPLIES  */
    T_TRUE = 271,                  /* T_TRUE  */
    T_FALSE = 272,                 /* T_FALSE  */
    T_SUBSET = 273,                /* T_SUBSET  */
    T_IN = 274,                    /* T_IN  */
    T_SOLVE = 275,                 /* T_SOLVE  */
    T_SATISFY = 276,               /* T_SATISFY  */
    T_MAXIMIZE = 277,              /* T_MAXIMIZE  */
    T_DOTDOT = 278,                /* T_DOTDOT  */
    T_GE = 279,                    /* T_GE  */
    T_LE = 280,                    /* T_LE  */
    T_NUM = 281,                   /* T_NUM  */
    T_ID = 282                     /* T_ID  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 22 "parser.y"

    char *sval;
    struct {
        float val;
        int type;
    } valNum;
    ParType pType;

#line 100 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
