## 实验一 词法语法分析

- 词法分析：`lex.l`
- 语法分析：`parser.y`
- 被解析代码：`sample.c`

## 已完成：

- char类型、int类型和float类型，字符串
- 算术运算、比较运算、自增自减运算和复合赋值
- if语句、while语句和break、continue语句、for语句
- 结构语句、数组、多维数组、数组作为左值
- 词法报错，例如对变量名以数字开头的语句`int 2a;`进行报错
- 分析表溯源：`parser.output`

## 使用

- 编译：`./run.sh`
- 运行：`./parser sample.c`