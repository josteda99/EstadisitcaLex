/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
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
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_SIN_TAB_H_INCLUDED
# define YY_YY_SIN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    ID = 260,
    NUMBER = 261,
    FOR = 262,
    WHILE = 263,
    COM = 264,
    BCOM = 265,
    LT = 266,
    LE = 267,
    EQ = 268,
    NE = 269,
    GT = 270,
    GE = 271,
    PRINT = 272,
    LG = 273,
    RG = 274,
    LR = 275,
    RR = 276,
    AB = 277,
    OB = 278,
    ADD = 279,
    SUB = 280,
    MUL = 281,
    DIV = 282,
    POT = 283,
    FALSE = 284,
    TRUE = 285,
    LF = 286,
    RF = 287,
    ASIG = 288,
    RETURN = 289,
    ARITOP = 290,
    FUN = 291,
    RELOP = 292,
    GROUP = 293,
    ARRAY = 294,
    BINOP = 295,
    FUNCTION = 296,
    SEMICOLON = 297,
    COMMAN = 298,
    END = 299,
    UMINUS = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 20 "sin.y"

    char *name;
    int number;
    double num;

#line 109 "sin.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SIN_TAB_H_INCLUDED  */
