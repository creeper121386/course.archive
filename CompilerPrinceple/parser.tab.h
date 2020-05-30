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
    WRONGID = 260,
    RELOP = 261,
    TYPE = 262,
    FLOAT = 263,
    CHAR = 264,
    STRING = 265,
    STRUCT = 266,
    DPLUS = 267,
    LP = 268,
    RP = 269,
    LC = 270,
    RC = 271,
    LB = 272,
    RB = 273,
    SEMI = 274,
    COMMA = 275,
    DOT = 276,
    PLUS = 277,
    MINUS = 278,
    STAR = 279,
    DIV = 280,
    MOD = 281,
    ASSIGNOP = 282,
    PLUS_ASSIGN_OP = 283,
    MINUS_ASSIGN_OP = 284,
    MULT_ASSIGN_OP = 285,
    DIV_ASSIGN_OP = 286,
    MOD_ASSIGN_OP = 287,
    AND = 288,
    OR = 289,
    NOT = 290,
    AUTOPLUS = 291,
    AUTOMINUS = 292,
    IF = 293,
    ELSE = 294,
    WHILE = 295,
    RETURN = 296,
    FOR = 297,
    CONTINUE = 298,
    BREAK = 299,
    SWITCH = 300,
    CASE = 301,
    DEFAULT = 302,
    COLON = 303,
    EXT_DEF_LIST = 304,
    EXT_VAR_DEF = 305,
    FUNC_DEF = 306,
    FUNC_DEC = 307,
    EXT_DEC_LIST = 308,
    PARAM_LIST = 309,
    PARAM_DEC = 310,
    VAR_DEF = 311,
    DEC_LIST = 312,
    DEF_LIST = 313,
    COMP_STM = 314,
    STM_LIST = 315,
    EXP_STMT = 316,
    IF_THEN = 317,
    IF_THEN_ELSE = 318,
    LAST_ARRAY_DIM = 319,
    ARRAY_DIMS = 320,
    ARRAY_DEC = 321,
    ARRAY_ID = 322,
    VAR_DEC = 323,
    ARRAY_ACCESS = 324,
    FUNC_CALL = 325,
    ARGS = 326,
    FUNCTION = 327,
    PARAM = 328,
    ARG = 329,
    CALL = 330,
    LABEL = 331,
    GOTO = 332,
    JLT = 333,
    JLE = 334,
    JGT = 335,
    JGE = 336,
    EQ = 337,
    NEQ = 338,
    FOR_DEC = 339,
    STRUCT_DEF = 340,
    STRUCT_DEC = 341,
    STRUCT_NAME = 342,
    ACCESS_MEMBER = 343,
    SWITCH_STMT = 344,
    CASE_STMT = 345,
    DEFAULT_STMT = 346,
    CASE_STMT_LIST = 347,
    UMINUS = 348,
    LOWER_THEN_ELSE = 349
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 21 "parser.y" /* yacc.c:1909  */

	int    type_int;
	float  type_float;
	char   type_id[32];

    char   type_char;
    char   type_string[32];
    char   struct_name[32];
    struct ASTNode *ptr;

#line 160 "parser.tab.h" /* yacc.c:1909  */
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
