#include "def.h"
#include "parser.tab.h"

struct ASTNode *mknode(int num, int kind, int pos, ...)
{
    struct ASTNode *T = (struct ASTNode *)calloc(sizeof(struct ASTNode), 1);
    int i = 0;
    T->kind = kind;
    T->pos = pos;
    va_list pArgs; // 这里原代码有问题，NULL初始化会报错
    va_start(pArgs, pos);
    for (i = 0; i < num; i++)
        T->ptr[i] = va_arg(pArgs, struct ASTNode *);
    while (i < 4)
        T->ptr[i++] = NULL;
    va_end(pArgs);
    return T;
}

char *map_type(char *type_str, int code)
{
    switch (code)
    {
    case INT:
        // return "int";
        strcpy(type_str, "int");
        break;
    case FLOAT:
        // return "float";
        strcpy(type_str, "float");
        break;
    case CHAR:
        // return "char";
        strcpy(type_str, "char");
        break;
    case STRING:
        // return "string";
        strcpy(type_str, "string");
        break;

    default:
        // return "unknown";
        strcpy(type_str, "unknown");
        break;
    }

    return type_str;
}

void display(struct ASTNode *T, int indent)
{ //对抽象语法树的先根遍历
    int i = 1;
    struct ASTNode *T0;
    char type_str[10];
    if (T)
    {
        switch (T->kind)
        {
        case EXT_DEF_LIST:
            display(T->ptr[0], indent); //显示该外部定义（外部变量和函数）列表中的第一个
            display(T->ptr[1], indent); //显示该外部定义列表中的其它外部定义
            break;
        case EXT_VAR_DEF:
            // 左子树为TYPE,右子树为变量(ExtDecList)
            printf("%*c外部变量定义：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3); //显示外部变量类型
            printf("%*c变量名：\n", indent + 3, ' ');
            display(T->ptr[1], indent + 6); //显示变量列表
            break;
        case TYPE:
            printf("%*c类型： %s\n", indent, ' ', T->type_id);
            break;
        case EXT_DEC_LIST:
            display(T->ptr[0], indent); //依次显示外部变量名，
            display(T->ptr[1], indent); //后续还有相同的，仅显示语法树此处理代码可以和类似代码合并
            break;
        case FUNC_DEF:
            printf("%*c函数定义：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3); //显示函数返回类型
            display(T->ptr[1], indent + 3); //显示函数名和参数
            display(T->ptr[2], indent + 3); //显示函数体
            break;
        case FUNC_DEC:
            printf("%*c函数名：%s\n", indent, ' ', T->type_id);
            if (T->ptr[0])
            {
                printf("%*c函数形参：\n", indent, ' ');
                display(T->ptr[0], indent + 3); //显示函数参数列表
            }
            else
                printf("%*c无参函数\n", indent + 3, ' ');
            break;
        case PARAM_LIST:
            display(T->ptr[0], indent); //依次显示全部参数类型和名称，
            display(T->ptr[1], indent);
            break;
        case PARAM_DEC:
            // 根据类型不同打印信息:
            switch (T->ptr[0]->type)
            {
            case INT:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "int", T->ptr[1]->type_id);
                break;
            case FLOAT:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "float", T->ptr[1]->type_id);
                break;
            case CHAR:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "char", T->ptr[1]->type_id);
                break;
            case STRING:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "string", T->ptr[1]->type_id);
                break;
            case STRUCT:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "struct", T->ptr[1]->type_id);
                break;
            default:
                printf("%*c类型：%s, 参数名：%s\n", indent, ' ', "unknown", T->ptr[1]->type_id);
                break;
            }
            break;
        case EXP_STMT:
            printf("%*c表达式语句：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            break;
        case RETURN:
            printf("%*c返回语句：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            break;
        case COMP_STM:
            printf("%*c-----------------\n", indent, ' ');
            printf("%*c复合语句：(%d)\n", indent, ' ', T->pos);
            printf("%*c变量定义部分：\n", indent + 3, ' ');
            display(T->ptr[0], indent + 6); //显示定义部分
            printf("%*c其他语句部分：\n", indent + 3, ' ');
            display(T->ptr[1], indent + 6); //显示语句部分
            break;
        case STM_LIST:
            display(T->ptr[0], indent); //显示第一条语句
            display(T->ptr[1], indent); //显示剩下语句
            break;
        case WHILE:
            printf("%*cWHILE语句：(%d)\n", indent, ' ', T->pos);
            printf("%*c循环条件：\n", indent + 3, ' ');
            display(T->ptr[0], indent + 6); //显示循环条件
            printf("%*c循环体：(%d)\n", indent + 3, ' ', T->pos);
            display(T->ptr[1], indent + 6); //显示循环体
            break;
        case FOR:
            printf("%*cFOR语句：(%d)\n", indent, ' ', T->pos);
            printf("%*c循环条件：\n", indent + 3, ' ');
            display(T->ptr[0], indent + 3 * 2);
            printf("%*c循环体：(%d)\n", indent + 3, ' ', T->pos);
            display(T->ptr[1], indent + 3 * 2);
            break;
        case FOR_DEC:
            display(T->ptr[0], indent + 3 * 2);
            display(T->ptr[1], indent + 3 * 2);
            display(T->ptr[2], indent + 3 * 2);
            break;
        case CONTINUE:
            printf("%*cCONTINUE语句：(%d)\n", indent, ' ', T->pos);
            break;
        case BREAK:
            printf("%*cBREAK语句：(%d)\n", indent, ' ', T->pos);
            break;
        case SWITCH_STMT:
            printf("%*cSWITCH语句：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            display(T->ptr[1], indent + 3);
            break;

        case CASE_STMT_LIST:
            display(T->ptr[0], indent);
            display(T->ptr[1], indent);
            break;

        case CASE_STMT:
            printf("%*cCASE语句：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            display(T->ptr[1], indent + 3);
            break;

        case DEFAULT_STMT:
            printf("%*cDEFAULT语句：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            break;

        case IF_THEN:
            printf("%*cIF_THEN语句：(%d)\n", indent, ' ', T->pos);
            printf("%*c判断条件：\n", indent + 3, ' ');
            display(T->ptr[0], indent + 6); //显示条件
            printf("%*cIF体：(%d)\n", indent + 3, ' ', T->pos);
            display(T->ptr[1], indent + 6); //显示if子句
            break;
        case IF_THEN_ELSE:
            printf("%*cIF_THEN_ELSE语句：(%d)\n", indent, ' ', T->pos);
            printf("%*c判断条件：\n", indent + 3, ' ');
            display(T->ptr[0], indent + 6); //显示条件
            printf("%*cIF体：(%d)\n", indent + 3, ' ', T->pos);
            display(T->ptr[1], indent + 6); //显示if子句
            printf("%*cELSE体：(%d)\n", indent + 3, ' ', T->pos);
            display(T->ptr[2], indent + 6); //显示else子句
            break;
        case DEF_LIST:
            printf("deflist\n");
            display(T->ptr[0], indent); //显示该局部变量定义列表中的第一个
            display(T->ptr[1], indent); //显示其它局部变量定义
            break;
        case VAR_DEF:
            printf("%*c局部变量定义：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3); //显示变量类型
            display(T->ptr[1], indent + 3); //显示该定义的全部变量名
            break;
        case DEC_LIST:
            // 局部变量定义列表: 例如 int a, b, c=1;
            printf("%*c变量名：\n", indent, ' ');
            T0 = T;
            while (T0)
            {
                if (T0->ptr[0]->kind == ASSIGNOP)
                // 带初始化表达式的
                {
                    printf("%*c %s ASSIGNOP\n ", indent + 6, ' ', T0->ptr[0]->ptr[0]->type_id);
                    display(T0->ptr[0]->ptr[1], indent + strlen(T0->ptr[0]->ptr[0]->type_id) + 7); //显示初始化表达式
                }
                else
                    // 不带初始化表达式
                    display(T0->ptr[0], indent + strlen(T0->ptr[0]->type_id)); //显示初始化表达式
                // printf("%*c %s\n", indent + 6, ' ', T0->ptr[0]->type_id);
                T0 = T0->ptr[1];
            }
            break;
        case ARRAY_DEC: // int array
            printf("%*c数组名：%s\n", indent, ' ', T->type_id);
            display(T->ptr[0], indent);
            display(T->ptr[1], indent);
            break;
        // case LAST_ARRAY_DIM:        // 例如[10]
        //     printf("%*c数组长度：%d\n", indent, ' ', T->type_int);
        //     // display(T->ptr[0], indent);
        //     // display(T->ptr[1], indent);
        //     break;
        // case ARRAY_DIMS:        // 例如[10][20]
        //     //  结构:
        //     //       ARRAY_DIMS (type_int = 维数1)
        //     //       /        \
        //     //   NULL      ARRAY_DIMS  (type_int = 维数2)
        //     //            /          \
        //     //         NULL      LAST_ARRAY_DIM  (type_int = 维数3)

        //     printf("%*c维度：%d\n", indent, ' ', T->type_int);
        //     display(T->ptr[0], indent);
        //     break;
        case ARRAY_DIMS: // 例如[10][20]
            printf("%*c(ARRAY_DIMS)数组维度\n", indent, ' ');
            display(T->ptr[0], indent);
            display(T->ptr[1], indent);
            break;
        case ARRAY_ID:
            printf("%*c(ARRAY_ID)数组访问：(%d)\n", indent, ' ', T->pos);
            // printf("%*c访问下标：\n", indent, ' ');
            display(T->ptr[0], indent + 3);
            break;
        case STRUCT_DEF:
            printf("%*c结构定义：(%d)\n", indent, ' ', T->pos);
            display(T->ptr[0], indent + 3);
            display(T->ptr[1], indent + 3);
            break;
        case STRUCT_NAME:
            printf("%*c结构名：%s\n", indent, ' ', T->struct_name);
            break;
        case ID:
            // printf("\033[0;32m%*cID： %s, type: %s(%d)\n\033[0m", indent, ' ', T->type_id, map_type(type_str, T->type), T->type);
            printf("\033[0;32m%*cID： %s\n\033[0m", indent, ' ', T->type_id);
            break;
        case INT:
            printf("%*cINT：%d\n", indent, ' ', T->type_int);
            break;
        case FLOAT:
            printf("%*cFLAOT：%f\n", indent, ' ', T->type_float);
            break;
        case CHAR:
            printf("%*cCHAR: %c\n", indent, ' ', T->type_char);
            break;
        case STRING:
            printf("%*cSTRING: %s\n", indent, ' ', T->type_string);
            break;
        case ASSIGNOP:
        case PLUS_ASSIGN_OP:
        case MINUS_ASSIGN_OP:
        case MULT_ASSIGN_OP:
        case DIV_ASSIGN_OP:
        case MOD_ASSIGN_OP:
        case AND:
        case OR:
        case RELOP:
        case PLUS:
        case AUTOPLUS:
        case AUTOMINUS:
        case MINUS:
        case STAR:
        case DIV:
            printf("%*c%s\n", indent, ' ', T->type_id);
            display(T->ptr[0], indent + 3);
            display(T->ptr[1], indent + 3);
            break;
        case MOD:
            printf("%*c%s\n", indent, ' ', T->type_id);
            display(T->ptr[0], indent + 3);
            display(T->ptr[1], indent + 3);
            break;
        case ACCESS_MEMBER:
            printf("%*c(ACCESS_MEMBER) 结构体访问：\n", indent, ' ');
            display(T->ptr[0], indent + 3);
            printf("%*c访问成员变量：%s\n", indent + 3, ' ', T->type_id);
            break;
        case NOT:
        case UMINUS:
            printf("%*c%s\n", indent, ' ', T->type_id);
            display(T->ptr[0], indent + 3);
            break;
        case FUNC_CALL:
            printf("%*c函数调用：(%d)\n", indent, ' ', T->pos);
            printf("%*c函数名：%s\n", indent + 3, ' ', T->type_id);
            display(T->ptr[0], indent + 3);
            break;
        case ARGS:
            i = 1;
            while (T)
            { //ARGS表示实际参数表达式序列结点，其第一棵子树为其一个实际参数表达式，第二棵子树为剩下的
                struct ASTNode *T0 = T->ptr[0];
                printf("%*c实参%d：\n", indent, ' ', i++);
                display(T0, indent + 3);
                T = T->ptr[1];
            }
            //                    printf("%*c第%d个实际参数表达式：\n",indent,' ',i);
            //                  display(T,indent+3);
            printf("\n");
            break;
        default:
            printf("\033[01;33m!!! TYPE UNKNOWN.\n\033[0m");
            break;
        }
    }
}