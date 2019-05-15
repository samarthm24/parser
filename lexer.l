%{
    #include<stdio.h>
    #include"y.tab.h"
    int yyerror();
    int yycolumn;
   #define YY_USER_ACTION yylloc.first_line =yylloc.last_line = yylineno; \
   yylloc.first_column = yycolumn; yylloc.last_column = yycolumn + yyleng -1; \
    yycolumn +=yyleng;

%}
%option yylineno
letter [a-zA-Z];
digit [0-9];


%%
[\n]				{yylineno++;yycolumn=0;}
\/\/.*				{}
\/\*(.\n)*\*\/		{}
","   			 	{yylval=strdup(yytext); return T_COMMA; }
";"   			 	{ yylval=strdup(yytext); return T_SEMICOLON; }
":"   			 	{yylval=strdup(yytext); return T_COLON; }
")"   			 	{yylval=strdup(yytext); return  T_RPAREN; }
"("   			 	{yylval=strdup(yytext); return  T_LPAREN; }
"["   			 	{yylval=strdup(yytext); return T_LB;}
"]"   			 	{yylval=strdup(yytext); return T_RB; }
"}"   			 	{yylval=strdup(yytext); return  T_RBR; }
"{"   			 	{yylval=strdup(yytext); return  T_LBR; }
"+"   			 	{yylval=strdup(yytext); return T_OP_ADD; }
"-"   			 	{yylval=strdup(yytext); return T_OP_SUB; }
"*"   			 	{yylval=strdup(yytext); return T_OP_MUL; }
"/"   			 	{yylval=strdup(yytext); return T_OP_DI; }
"<"   			 	{yylval=strdup(yytext); return T_OP_LT; }
"<="   			 {yylval=strdup(yytext); return T_OP_LE; }
"<>"   			 {yylval=strdup(yytext); return T_OP_NE; }
">="   			 {yylval=strdup(yytext); return T_OP_GE; }
">"   			 	{yylval=strdup(yytext); return T_OP_GT; }
"=="   			 	{yylval=strdup(yytext); return T_OP_EQ; }
"="   			 	{yylval=strdup(yytext); return T_OP_AS; }
"&&"   			 {yylval=strdup(yytext); return T_OP_AND; }
"||"   			 {yylval=strdup(yytext); return T_OP_OR; }
"!"   			 	{yylval=strdup(yytext); return T_OP_NOT; }

["][.]*["]      	{yylval=strdup(yytext); return T_STRING;}
['][.][']		{yylval=strdup(yytext);return T_CHAR;}

[-]?[0-9]+       {yylval=strdup(yytext); return T_INT;}
[-]?[0-9]+[.][0-9]+       { yylval=strdup(yytext);return T_FLOAT;}
[0-9]*"."[E|e][+|-]?[0-9]* {yylval=strdup(yytext);return T_FLOAT;} 
"boolean"   		 { yylval=strdup(yytext);return T_K_BOOLEAN; }
"else"   			 { yylval=strdup(yytext);return T_K_ELSE; }
"false"   			 { yylval=strdup(yytext);return T_K_FALSE; }
"int"   		 	{yylval=strdup(yytext);return T_K_INTEGER; }
"if"   			 {yylval=strdup(yytext); return T_K_IF; }
"char"   			 {yylval=strdup(yytext); return T_K_CHAR; }
"double"   			 {yylval=strdup(yytext); return T_K_DOUBLE; }
"print"   			 {yylval=strdup(yytext); return T_K_PRINT; }
"float"   			 {yylval=strdup(yytext); return T_K_FLOAT; }
"return"   		 {yylval=strdup(yytext); return T_K_RETURN; }
"true"   			 {yylval=strdup(yytext); return T_K_TRUE; }
"short"   			 {yylval=strdup(yytext); return T_K_SHORT; }
"void"   			 {yylval=strdup(yytext); return T_K_VOID; }
"while"         	{yylval=strdup(yytext); return T_K_WHILE; }
[a-zA-Z][0-9a-zA-Z]*        {yylval=strdup(yytext);return T_ID;}
%%
