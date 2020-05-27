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

// #define DEBUG 1
#define DEBUG 0
%}
%option yylineno

ID                  [A-Za-z][A-Za-z0-9]*
WRONGID				[0-9]+[A-Za-z][A-Za-z0-9]*
INT                 [0-9]+
FLOAT               ([0-9]*\.[0-9]+)|([0-9]+\.)
CHAR                \'(\\.|[^'\\])\'        
/* 转义+任意字符 | 非单引号字符 | 不能出现单独的 \ */
STRING              \"(\\.|[^"\\])*\"       
/* 同上，并允许长度为0~n */
LINE_COMMENT        \/\/[^\n]*


%%
{LINE_COMMENT}  {if(DEBUG) printf("%-11s  %s\n", "LINECOMMENT", yytext);}
\/\*(\s|\n|[^\/])*?\*\/ {if(DEBUG) printf("<BLOCKCOMMENT-START>\n%s\n<BLOCKCOMMENT-END>\n", yytext);}

{INT}           {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "INT", yytext, yylineno, yycolumn); yylval.type_int=atoi(yytext); return INT;}
{FLOAT}         {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "FLOAT", yytext, yylineno, yycolumn); yylval.type_float=atof(yytext); return FLOAT;}
{CHAR}          {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "CHAR", yytext, yylineno, yycolumn);yylval.type_char=yytext[1];return CHAR;}
{STRING}        {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "STRING", yytext, yylineno, yycolumn);strcpy(yylval.type_string,yytext);return STRING;}
"int"           {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "TYPE", yytext, yylineno, yycolumn); strcpy(yylval.type_id, yytext);return TYPE;}
"float"         {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "TYPE", yytext, yylineno, yycolumn); strcpy(yylval.type_id, yytext);return TYPE;}
"char"          {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "TYPE", yytext, yylineno, yycolumn); strcpy(yylval.type_id, yytext);return TYPE;}
"string"        {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "TYPE", yytext, yylineno, yycolumn); strcpy(yylval.type_id, yytext);return TYPE;}
"return"        {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "RETURN", yytext, yylineno, yycolumn); return RETURN;}
"if"            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "IF", yytext, yylineno, yycolumn); return IF;}
"else"          {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "ELSE", yytext, yylineno, yycolumn); return ELSE;}
"while"         {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "WHILE", yytext, yylineno, yycolumn); return WHILE;}
"for"           {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "FOR", yytext, yylineno, yycolumn); return FOR;}
"continue"      {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "CONTINUE", yytext, yylineno, yycolumn);return CONTINUE;}
"break"         {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "BREAK", yytext, yylineno, yycolumn); return BREAK;}
"struct"        {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "STRUCT", yytext, yylineno, yycolumn);return STRUCT;}
"switch" 		{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "SWITCH", yytext, yylineno, yycolumn);return SWITCH;}
"case"   		{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "CASE", yytext, yylineno, yycolumn);return CASE;}
"default" 		{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "DEFAULT", yytext, yylineno, yycolumn);return DEFAULT;}
{ID}            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "ID", yytext, yylineno, yycolumn); strcpy(yylval.type_id,  yytext); return ID;}
";"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "SEMI", yytext, yylineno, yycolumn); return SEMI;}
","			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "COMMA", yytext, yylineno, yycolumn); return COMMA;}
":"      		{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "COLON", yytext, yylineno, yycolumn);return COLON;}
"="			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "ASSIGNOP", yytext, yylineno, yycolumn); return ASSIGNOP;}
"+"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "PLUS", yytext, yylineno, yycolumn); return PLUS;}
"-"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "MINUS", yytext, yylineno, yycolumn); return MINUS;}
"*"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "STAR", yytext, yylineno, yycolumn); return STAR;}
"/"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "DIV", yytext, yylineno, yycolumn); return DIV;}
"&&"            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "AND", yytext, yylineno, yycolumn); return AND;}
"||"            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "OR", yytext, yylineno, yycolumn); return OR;}
"!"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "NOT", yytext, yylineno, yycolumn); return NOT;}
"("			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "LP", yytext, yylineno, yycolumn); return LP;}
")"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "RP", yytext, yylineno, yycolumn); return RP;}
"{"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "LC", yytext, yylineno, yycolumn); return LC;}
"}"			    {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "RC", yytext, yylineno, yycolumn); return RC;}
"["             {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "LB", yytext, yylineno, yycolumn);return LB;}
"]"             {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "LC", yytext, yylineno, yycolumn);return RB;}
"."             {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "DOT", yytext, yylineno, yycolumn);return DOT;}
"++"            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "AUTOPLUS", yytext, yylineno, yycolumn); return AUTOPLUS;}
"--"            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "AUTOMINUS", yytext, yylineno, yycolumn); return AUTOMINUS;}
"+="            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "PLUSASSIGN", yytext, yylineno, yycolumn); return PLUS_ASSIGN_OP;}
"-="            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "MINUSASSIGN", yytext, yylineno, yycolumn); return MINUS_ASSIGN_OP;}
"*="            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "STARASSIGN", yytext, yylineno, yycolumn);return MULT_ASSIGN_OP;}
"/="            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "DIVASSIGN", yytext, yylineno, yycolumn);return DIV_ASSIGN_OP;}
"%="            {if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "MODASSIGN", yytext, yylineno, yycolumn);return MOD_ASSIGN_OP;}


">"|"<"|">="|"<="|"=="|"!="   	{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "RELOP", yytext, yylineno, yycolumn); strcpy(yylval.type_id, yytext);;return RELOP;}
\n            					{if(DEBUG) printf("%-11s  │  %-10s  at (%d, %d)\n", "ENDL", "\\n", yylineno, yycolumn); yycolumn=1;}   
[ \r\t]         				{}   
{WRONGID}       				{printf("\033[0;31mERR: ID can't start with number. unexpected: %s in (%d, %d)\n\033[0m", yytext, yylineno, yycolumn); strcpy(yylval.type_id,  yytext); return ID;}
.       						{printf("Error type A :Mysterious character \"%s\"\n\t at Line %d\n",yytext,yylineno);}
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
