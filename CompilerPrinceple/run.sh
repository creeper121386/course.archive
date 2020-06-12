#!/bin/bash
printf "\033c"
echo "compiling..."
rm parser.tab.c parser.tab.h parser parser.output lex.yy.c
flex lex.l
bison -vd parser.y
gcc -g -o parser lex.yy.c parser.tab.c ast.c semanticAnalysis.c

echo "rrunning..."
# ./parser test1.sample.c
# ./parser test2.sample.c
./parser test3.sample.c
