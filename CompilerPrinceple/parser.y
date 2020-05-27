%error-verbose
%locations
%{
#include "stdio.h"
#include "math.h"
#include "string.h"
#include "def.h"
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
int yylex();
void yyerror(const char* fmt, ...);
void display(struct ASTNode *,int);
void semantic_Analysis0(struct ASTNode *T);
%}

%union {
	int    type_int;
	float  type_float;
	char   type_id[32];

    char   type_char;
    char   type_string[32];
    char   struct_name[32];
    struct ASTNode *ptr;
};

//  %type 定义非终结符的语义值类型
%type  <ptr> program ExtDefList ExtDef  Specifier ExtDecList FuncDec CompSt VarList VarDec ParamDec Stmt StmList DefList Def DecList Dec Exp Args Arraylist CaseStmtList CaseStmt DefaultStmt ForDec StructSpecifier OptTag Tag

//% token 定义终结符的语义值类型
%token <type_int> INT              /*指定INT的语义值是type_int，有词法分析得到的数值*/
%token <type_id> ID  RELOP TYPE    /*指定ID,RELOP 的语义值是type_id，有词法分析得到的标识符字符串*/
%token <type_float> FLOAT          /*指定ID的语义值是type_id，有词法分析得到的标识符字符串*/
%token <type_char> CHAR
%token <type_string> STRING

%token STRUCT
%token DPLUS LP RP LC RC LB RB SEMI COMMA DOT     /*用bison对该文件编译时，带参数-d，生成的.tab.h中给这些单词进行编码，可在lex.l中包含parser.tab.h使用这些单词种类码*/
/*以下为接在上述token后依次编码的枚举常量，作为AST结点类型标记*/
%token PLUS MINUS STAR DIV MOD ASSIGNOP PLUS_ASSIGN_OP MINUS_ASSIGN_OP MULT_ASSIGN_OP DIV_ASSIGN_OP MOD_ASSIGN_OP AND OR NOT AUTOPLUS AUTOMINUS IF ELSE WHILE RETURN FOR CONTINUE BREAK SWITCH CASE DEFAULT COLON
%token EXT_DEF_LIST EXT_VAR_DEF FUNC_DEF FUNC_DEC EXT_DEC_LIST PARAM_LIST PARAM_DEC VAR_DEF DEC_LIST DEF_LIST COMP_STM STM_LIST EXP_STMT IF_THEN IF_THEN_ELSE ARRAY_LIST ARRAY_ID
%token FUNC_CALL ARGS FUNCTION PARAM ARG CALL LABEL GOTO JLT JLE JGT JGE EQ NEQ FOR_DEC STRUCT_DEF STRUCT_DEC STRUCT_NAME ACCESS_MEMBER
%token SWITCH_STMT CASE_STMT DEFAULT_STMT CASE_STMT_LIST


%left ASSIGNOP PLUS_ASSIGN_OP MINUS_ASSIGN_OP MULT_ASSIGN_OP DIV_ASSIGN_OP MOD_ASSIGN_OP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV MOD
%left AUTOPLUS AUTOMINUS
%right UMINUS NOT DPLUS
%left LB RB LP RP DOT

%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE

%%
// for exp1: 
// program: ExtDefList    {printf("\n\033[1;32m══════════════\nProgram start:\n══════════════\n\033[0m\n语法树根节点Root\n");display($1,0);}     //显示语法树,语义分析

// for exp2:
program: ExtDefList    {printf("\n\033[1;32m═══════════════\nAnalysis start:\n═══════════════\n\033[0m\n");semantic_Analysis0($1);}     //显示语法树,语义分析
         ; 
ExtDefList: {$$=NULL;}
          | ExtDef ExtDefList {$$=mknode(2,EXT_DEF_LIST,yylineno,$1,$2);}   //每一个EXTDEFLIST的结点，其第1棵子树对应一个外部变量声明或函数
          ;  
ExtDef:   Specifier ExtDecList SEMI   {$$=mknode(2,EXT_VAR_DEF,yylineno,$1,$2);}   //该结点对应一个外部变量声明
         |Specifier FuncDec CompSt    {$$=mknode(3,FUNC_DEF,yylineno,$1,$2,$3);}         //函数定义
         | error SEMI   {$$=NULL;}
         ;
Specifier:  TYPE    {$$=mknode(0,TYPE,yylineno);strcpy($$->type_id,$1);$$->type=!strcmp($1,"int")?INT:FLOAT;}   
         | StructSpecifier {}
           ;  

// struct:
// -------------------------------------------------------------------------------------------
StructSpecifier: STRUCT OptTag LC DefList RC {$$=mknode(2, STRUCT_DEF, yylineno, $2,$4);}
               | STRUCT Tag {$$=mknode(1, STRUCT_DEF, yylineno, $2);}
               ;
OptTag: {$$=NULL;}
       | ID {$$=mknode(0, STRUCT_NAME, yylineno);strcpy($$->struct_name, $1);}
       ;
Tag: ID {$$=mknode(0, STRUCT_NAME, yylineno); strcpy($$->struct_name, $1);}

Arraylist:  LB INT RB                 {$$=mknode(0,ARRAY_LIST,yylineno);$$->type_int=$2;}
          | LB INT RB Arraylist       {$$=mknode(2,ARRAY_LIST,yylineno,$2,$4);}
        ;
// -------------------------------------------------------------------------------------------

ExtDecList:  VarDec      {$$=$1;}       /*每一个EXT_DECLIST的结点，其第一棵子树对应一个变量名(ID类型的结点),第二棵子树对应剩下的外部变量名*/
           | VarDec COMMA ExtDecList {$$=mknode(2,EXT_DEC_LIST,yylineno,$1,$3);}
           ;  
VarDec:  ID          {$$=mknode(0,ID,yylineno);strcpy($$->type_id,$1);}   //ID结点，标识符符号串存放结点的type_id
        | ID Arraylist {$$=mknode(1,ARRAY_LIST,yylineno,$2);strcpy($$->type_id,$1);} 
        | ID Arraylist ASSIGNOP Exp {$$=mknode(1,ARRAY_LIST,yylineno,$2);strcpy($$->type_id,$1);} 
        | ID ASSIGNOP Exp {$$=mknode(0,ID,yylineno);strcpy($$->type_id,$1);} 
         ;

FuncDec: ID LP VarList RP   {$$=mknode(1,FUNC_DEC,yylineno,$3);strcpy($$->type_id,$1);}//函数名存放在$$->type_id
		|ID LP  RP   {$$=mknode(0,FUNC_DEC,yylineno);strcpy($$->type_id,$1);$$->ptr[0]=NULL;}//函数名存放在$$->type_id

        ;  
VarList: ParamDec  {$$=mknode(1,PARAM_LIST,yylineno,$1);}
        | ParamDec COMMA  VarList  {$$=mknode(2,PARAM_LIST,yylineno,$1,$3);}
        ;
ParamDec: Specifier VarDec         {$$=mknode(2,PARAM_DEC,yylineno,$1,$2);}
         ;

CompSt: LC DefList StmList RC    {$$=mknode(2,COMP_STM,yylineno,$2,$3);}
       ;
StmList: {$$=NULL; }  
        | Stmt StmList  {$$=mknode(2,STM_LIST,yylineno,$1,$2);}
        ;
Stmt:   Exp SEMI    {$$=mknode(1,EXP_STMT,yylineno,$1);}
      | CompSt      {$$=$1;}      //复合语句结点直接最为语句结点，不再生成新的结点
      | RETURN Exp SEMI   {$$=mknode(1,RETURN,yylineno,$2);}
      | IF LP Exp RP Stmt %prec LOWER_THEN_ELSE   {$$=mknode(2,IF_THEN,yylineno,$3,$5);}
      | IF LP Exp RP Stmt ELSE Stmt   {$$=mknode(3,IF_THEN_ELSE,yylineno,$3,$5,$7);}
      | WHILE LP Exp RP Stmt {$$=mknode(2,WHILE,yylineno,$3,$5);}
      
      // add more statements:
      | FOR LP ForDec RP Stmt {$$=mknode(2,FOR,yylineno,$3,$5);}
      | CONTINUE SEMI {$$=mknode(0,CONTINUE, yylineno);}
      | BREAK SEMI {$$=mknode(0,BREAK,yylineno);}
      | SWITCH LP Exp RP LC CaseStmtList RC {$$=mknode(2, SWITCH_STMT, yylineno, $3, $6);}
      ;

DefaultStmt: DEFAULT COLON StmList {$$=mknode(1, DEFAULT_STMT, yylineno, $3);}
        ;

CaseStmt: CASE INT COLON StmList {$$=mknode(1, CASE_STMT, yylineno, $4);$$->type_int=$2;$$->type=INT;}
        | CASE CHAR COLON StmList {$$=mknode(1, CASE_STMT, yylineno, $4);$$->type_char=$2;$$->type=CHAR;}
        ;

CaseStmtList: 
          {$$=NULL;}
        | CaseStmt CaseStmtList {$$=mknode(2, CASE_STMT_LIST, yylineno, $1, $2);}
        | DefaultStmt {$$=mknode(1, CASE_STMT_LIST, yylineno,$1);}
        ;

// CaseType: INT {$$=mknode(0,INT,yylineno);$$->type_int=$1;$$->type=INT;}
//         | CHAR {$$=mknode(0,CHAR,yylineno);$$->type_char=$1;$$->type=CHAR;}
//         ;

ForDec: Exp SEMI Exp SEMI Exp {$$=mknode(3, FOR_DEC, yylineno, $1, $3, $5);}
      | SEMI Exp SEMI {$$=mknode(1,FOR_DEC, yylineno, $2);}
      ;


DefList: {$$=NULL; }
        | Def DefList {$$=mknode(2,DEF_LIST,yylineno,$1,$2);}
        | error SEMI   {$$=NULL;}
        ;
Def:    Specifier DecList SEMI {$$=mknode(2,VAR_DEF,yylineno,$1,$2);}
        ;
DecList: Dec  {$$=mknode(1,DEC_LIST,yylineno,$1);}
       | Dec COMMA DecList  {$$=mknode(2,DEC_LIST,yylineno,$1,$3);}
	   ;
Dec:     VarDec  {$$=$1;}
//        | VarDec ASSIGNOP Exp  {$$=mknode(2,ASSIGNOP,yylineno,$1,$3);strcpy($$->type_id,"ASSIGNOP");}
       ;
Exp:    Exp ASSIGNOP Exp {$$=mknode(2,ASSIGNOP,yylineno,$1,$3);strcpy($$->type_id,"ASSIGNOP");}
      | Exp PLUS_ASSIGN_OP Exp {$$=mknode(2,PLUS_ASSIGN_OP,yylineno,$1,$3);strcpy($$->type_id, "PLUS_ASSIGN_OP");}
      | Exp MINUS_ASSIGN_OP Exp {$$=mknode(2,MINUS_ASSIGN_OP,yylineno,$1,$3);strcpy($$->type_id, "MINUS_ASSIGN_OP");}
      | Exp MULT_ASSIGN_OP Exp {$$=mknode(2, MULT_ASSIGN_OP,yylineno,$1,$3);strcpy($$->type_id,"MULT_ASSIGN_OP");}
      | Exp DIV_ASSIGN_OP Exp {$$=mknode(2,DIV_ASSIGN_OP,yylineno,$1,$3);strcpy($$->type_id,"DIV_ASSIGN_OP");}
      | Exp MOD_ASSIGN_OP Exp {$$=mknode(2,MOD_ASSIGN_OP,yylineno,$1,$3);strcpy($$->type_id, "MOD_ASSIGN_OP");}
      | Exp AND Exp   {$$=mknode(2,AND,yylineno,$1,$3);strcpy($$->type_id,"AND");}
      | Exp OR Exp    {$$=mknode(2,OR,yylineno,$1,$3);strcpy($$->type_id,"OR");}
      | Exp RELOP Exp {$$=mknode(2,RELOP,yylineno,$1,$3);strcpy($$->type_id,$2);}
      | Exp PLUS Exp  {$$=mknode(2,PLUS,yylineno,$1,$3);strcpy($$->type_id,"PLUS");}
      | Exp MINUS Exp {$$=mknode(2,MINUS,yylineno,$1,$3);strcpy($$->type_id,"MINUS");}
      | Exp STAR Exp  {$$=mknode(2,STAR,yylineno,$1,$3);strcpy($$->type_id,"STAR");}
      | Exp DIV Exp   {$$=mknode(2,DIV,yylineno,$1,$3);strcpy($$->type_id,"DIV");}
      | Exp MOD Exp   {$$=mknode(2,MOD,yylineno,$1,$3);strcpy($$->type_id,"MOD");}
      | Exp AUTOPLUS  {$$=mknode(1,AUTOPLUS,yylineno,$1);strcpy($$->type_id, "RPAUTOPLUS");}
      | Exp AUTOMINUS {$$=mknode(1,AUTOMINUS,yylineno,$1);strcpy($$->type_id,"RPAUTOMINUS");}
      | AUTOPLUS Exp  {$$=mknode(1,AUTOPLUS,yylineno,$2);strcpy($$->type_id, "LPAUTOPLUS");}
      | AUTOMINUS Exp {$$=mknode(1,AUTOMINUS,yylineno,$2);strcpy($$->type_id, "LPAUTOMINUS");}
      | LP Exp RP     {$$=$2;}
      | MINUS Exp %prec UMINUS   {$$=mknode(1,UMINUS,yylineno,$2);strcpy($$->type_id,"UMINUS");}
      | NOT Exp       {$$=mknode(1,NOT,yylineno,$2);strcpy($$->type_id,"NOT");}
      | DPLUS  Exp      {$$=mknode(1,DPLUS,yylineno,$2);strcpy($$->type_id,"DPLUS");}
      |   Exp DPLUS      {$$=mknode(1,DPLUS,yylineno,$1);strcpy($$->type_id,"DPLUS");}
      | ID LP Args RP {$$=mknode(1,FUNC_CALL,yylineno,$3);strcpy($$->type_id,$1);}
      | ID LP RP      {$$=mknode(0,FUNC_CALL,yylineno);strcpy($$->type_id,$1);}
      | ID            {$$=mknode(0,ID,yylineno);strcpy($$->type_id,$1);}
      | INT           {$$=mknode(0,INT,yylineno);$$->type_int=$1;$$->type=INT;}
      | FLOAT         {$$=mknode(0,FLOAT,yylineno);$$->type_float=$1;$$->type=FLOAT;}
      | CHAR          {$$=mknode(0,CHAR,yylineno);$$->type_char=$1;$$->type=CHAR;}
      | STRING        {$$=mknode(0,STRING,yylineno);strcpy($$->type_string,$1);$$->type=STRING;}
      | ID Arraylist  {$$=mknode(1,ARRAY_ID,yylineno,$2);strcpy($$->type_id,$1);}
//       | ID Arraylist ASSIGNOP Exp  {$$=mknode(2,ASSIGNOP,yylineno,$1, $4);strcpy($$->type_id,$1);}
      | LB Args RB    {$$=$2;}
      | Exp DOT ID    {$$=mknode(1,ACCESS_MEMBER,yylineno,$1); strcpy($$->type_id,$3);}
      ;
Args:    Exp COMMA Args    {$$=mknode(2,ARGS,yylineno,$1,$3);}
       | Exp               {$$=mknode(1,ARGS,yylineno,$1);}
       ;
       
%%

int main(int argc, char *argv[]){
	yyin=fopen(argv[1],"r");
	if (!yyin) return 0;
	yylineno=1;

        printf("\033[1;32m═══════\nTokens:\n═══════\n\033[0m");
	yyparse();
	return 0;
	}

#include<stdarg.h>
void yyerror(const char* fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fprintf(stderr, "\033[0;31mERR(%d, %d): ", yylloc.first_line,yylloc.first_column);
    vfprintf(stderr, fmt, ap);
    fprintf(stderr, ".\033[0m\n");
}