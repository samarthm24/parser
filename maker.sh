yacc -d java.y
lex java.l
gcc lex.yy.c y.tab.c  -ll -ly -w
./a.out
