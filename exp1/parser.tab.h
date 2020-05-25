/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
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
    INT = 258,
    ID = 259,
    RELOP = 260,
    TYPE = 261,
    FLOAT = 262,
    CHAR = 263,
    STRING = 264,
    STRUCT = 265,
    DPLUS = 266,
    LP = 267,
    RP = 268,
    LC = 269,
    RC = 270,
    LB = 271,
    RB = 272,
    SEMI = 273,
    COMMA = 274,
    DOT = 275,
    PLUS = 276,
    MINUS = 277,
    STAR = 278,
    DIV = 279,
    MOD = 280,
    ASSIGNOP = 281,
    PLUS_ASSIGN_OP = 282,
    MINUS_ASSIGN_OP = 283,
    MULT_ASSIGN_OP = 284,
    DIV_ASSIGN_OP = 285,
    MOD_ASSIGN_OP = 286,
    AND = 287,
    OR = 288,
    NOT = 289,
    AUTOPLUS = 290,
    AUTOMINUS = 291,
    IF = 292,
    ELSE = 293,
    WHILE = 294,
    RETURN = 295,
    FOR = 296,
    CONTINUE = 297,
    BREAK = 298,
    EXT_DEF_LIST = 299,
    EXT_VAR_DEF = 300,
    FUNC_DEF = 301,
    FUNC_DEC = 302,
    EXT_DEC_LIST = 303,
    PARAM_LIST = 304,
    PARAM_DEC = 305,
    VAR_DEF = 306,
    DEC_LIST = 307,
    DEF_LIST = 308,
    COMP_STM = 309,
    STM_LIST = 310,
    EXP_STMT = 311,
    IF_THEN = 312,
    IF_THEN_ELSE = 313,
    ARRAY_LIST = 314,
    ARRAY_ID = 315,
    FUNC_CALL = 316,
    ARGS = 317,
    FOR_DEC = 318,
    STRUCT_DEF = 319,
    STRUCT_NAME = 320,
    ACCESS_MEMBER = 321,
    UMINUS = 322,
    LOWER_THEN_ELSE = 323
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "parser.y" /* yacc.c:1909  */

	int    type_int;
	float  type_float;
	char   type_id[32];

    char   type_char;
    char   type_string[32];
    char   struct_name[32];
    struct ASTNode *ptr;

#line 134 "parser.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
