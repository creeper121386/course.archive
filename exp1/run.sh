rm parser.tab.c parser.tab.h parser parser.output lex.yy.c
flex lex.l
bison -vd parser.y
gcc -g -o parser lex.yy.c parser.tab.c ast.c
# ./parser test1.sample.c
