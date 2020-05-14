%{
#include "parser.tab.h"
#include "string.h"
#include "def.h"
int yycolumn=1;
#define YY_USER_ACTION    	yylloc.first_line=yylloc.last_line=yylineno; \
	yylloc.first_column=yycolumn;	yylloc.last_column=yycolumn+yyleng-1; yycolumn+=yyleng;
typedef union {
    // define token:
	int type_int;
	float type_float;
	char type_id[32];

    char type_char;
	char type_string[32];
    char struct_name[32];

	struct node *ptr;
} YYLVAL;
#define YYSTYPE YYLVAL

%}
%option yylineno

ID                  [A-Za-z][A-Za-z0-9]*  
INT                 [0-9]+
FLOAT               ([0-9]*\.[0-9]+)|([0-9]+\.)
CHAR                \'(\\.|[^'\\])\'        
/* 转义+任意字符 | 非单引号字符 | 不能出现单独的 \ */
STRING              \"(\\.|[^"\\])*\"       
/* 同上，并允许长度为0~n */
LINE_COMMENT        \/\/[^\n]*


%%
{LINE_COMMENT}  {printf("%-14s %s\n", "LINECOMMENT", yytext);}
\/\*(\s|\n|[^\/])*?\*\/ {printf("BLOCKCOMMENT:\n%s\n<BLOCKCOMMENT-END>\n", yytext);}

{INT}           {printf("%-14s %s\n", "INT", yytext); yylval.type_int=atoi(yytext); return INT;}
{FLOAT}         {printf("%-14s %s\n", "FLOAT", yytext); yylval.type_float=atof(yytext); return FLOAT;}
{CHAR}          {printf("%-14s %s\n", "CHAR", yytext);yylval.type_char=yytext[1];return CHAR;}
{STRING}        {printf("%-14s %s\n", "STRING", yytext);strcpy(yylval.type_string,yytext);return STRING;}
"int"           {printf("%-14s %s\n", "TYPE", yytext); strcpy(yylval.type_id, yytext);return TYPE;}
"float"         {printf("%-14s %s\n", "TYPE", yytext); strcpy(yylval.type_id, yytext);return TYPE;}
"char"          {printf("%-14s %s\n", "TYPE", yytext); strcpy(yylval.type_id, yytext);return TYPE;}
"string"        {printf("%-14s %s\n", "TYPE", yytext); strcpy(yylval.type_id, yytext);return TYPE;}
"return"        {printf("%-14s %s\n", "RETURN", yytext); return RETURN;}
"if"            {printf("%-14s %s\n", "IF", yytext); return IF;}
"else"          {printf("%-14s %s\n", "ELSE", yytext); return ELSE;}
"while"         {printf("%-14s %s\n", "WHILE", yytext); return WHILE;}
"for"           {printf("%-14s %s\n", "FOR", yytext); return FOR;}
"continue"      {printf("%-14s %s\n", "CONTINUE", yytext);return CONTINUE;}
"break"         {printf("%-14s %s\n", "BREAK", yytext); return BREAK;}
"struct"        {printf("%-14s %s\n", "STRUCT", yytext);return STRUCT;}
{ID}            {printf("%-14s %s\n", "ID", yytext); strcpy(yylval.type_id,  yytext); return ID;}
";"			    {printf("%-14s %s\n", "SEMI", yytext); return SEMI;}
","			    {printf("%-14s %s\n", "COMMA", yytext); return COMMA;}
"="			    {printf("%-14s %s\n", "ASSIGNOP", yytext); return ASSIGNOP;}
"+"			    {printf("%-14s %s\n", "PLUS", yytext); return PLUS;}
"-"			    {printf("%-14s %s\n", "MINUS", yytext); return MINUS;}
"*"			    {printf("%-14s %s\n", "STAR", yytext); return STAR;}
"/"			    {printf("%-14s %s\n", "DIV", yytext); return DIV;}
"&&"            {printf("%-14s %s\n", "AND", yytext); return AND;}
"||"            {printf("%-14s %s\n", "OR", yytext); return OR;}
"!"			    {printf("%-14s %s\n", "NOT", yytext); return NOT;}
"("			    {printf("%-14s %s\n", "LP", yytext); return LP;}
")"			    {printf("%-14s %s\n", "RP", yytext); return RP;}
"{"			    {printf("%-14s %s\n", "LC", yytext); return LC;}
"}"			    {printf("%-14s %s\n", "RC", yytext); return RC;}
"["             {printf("%-14s %s\n", "LB", yytext);return LB;}
"]"             {printf("%-14s %s\n", "LC", yytext);return RB;}
"."             {printf("%-14s %s\n", "DOT", yytext);return DOT;}
"++"            {printf("%-14s %s\n", "AUTOPLUS", yytext); return AUTOPLUS;}
"--"            {printf("%-14s %s\n", "AUTOMINUS", yytext); return AUTOMINUS;}
"+="            {printf("%-14s %s\n", "PLUSASSIGN", yytext); return PLUS_ASSIGN_OP;}
"-="            {printf("%-14s %s\n", "MINUSASSIGN", yytext); return MINUS_ASSIGN_OP;}
"*="            {printf("%-14s %s\n", "STARASSIGN", yytext);return MULT_ASSIGN_OP;}
"/="            {printf("%-14s %s\n", "DIVASSIGN", yytext);return DIV_ASSIGN_OP;}
"%="            {printf("%-14s %s\n", "MODASSIGN", yytext);return MOD_ASSIGN_OP;}
">"|"<"|">="|"<="|"=="|"!="   {printf("%-14s %s\n", "RELOP", yytext); strcpy(yylval.type_id, yytext);;return RELOP;}
\n            {printf("%-14s \\n\n", "ENDL"); yycolumn=1;}   
[ \r\t]         {}   

.       {printf("Error type A :Mysterious character \"%s\"\n\t at Line %d\n",yytext,yylineno);}
%%

// 和bison联用时，不需要这部分
// void main()
// {
// yylex();
// return 0;
// }


int yywrap()
{
return 1;
}
