%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYSTYPE char *
struct SymbolTable
{
	char type[20];
	char variable_name[32];
	char scope[10];
	int decl[1][1];
	int changes[10][1];
	struct SymbolTable *next;
}typedef s_table;
int no_entries=-1;
s_table st[100];
int insert(char* tp,char* var_name,int line,int col)
{
	no_entries++;
	strcpy(st[no_entries].type,tp);
	strcpy(st[no_entries].variable_name,var_name);
	st[no_entries].decl[0][0]=line;
	st[no_entries].decl[0][1]=col;

}
int lookup(char* var_name){
	int i;
	if(no_entries<0){return -1;}
	for(i=0;i<no_entries;i++)
	{
		printf("\n");
		//printf("%s  %s\n",st[i].variable_name,var_name);
		if(strcmp(st[i].variable_name,var_name)==0)
			return i;
	}
	return -1;
}
int flag=0;
%}

%token  T_K_WHILE T_K_TRUE T_K_RETURN T_K_FLOAT  T_K_PRINT T_COMMA T_K_CHAR T_SEMICOLON T_COLON T_RPAREN T_K_IF T_K_INTEGER T_LPAREN T_K_FALSE T_K_ELSE T_K_BOOLEAN T_FLOAT T_LB T_RB T_INT T_OP_ADD T_OP_SUB T_OP_MUL T_OP_DI T_CHAR T_STRING T_OP_NOT T_OP_OR  T_OP_AND T_OP_EQ T_OP_GT T_OP_NE T_OP_GE T_OP_LT T_OP_LE T_ID T_RBR T_LBR T_OP_AS T_K_DOUBLE T_K_SHORT T_K_VOID


%%

start: pos start|pos
pos: while|S|ifelse|if
ifelse: if else


if:T_K_IF T_LPAREN RELEXPR T_RPAREN T_LBR S T_RBR{printf("\n if");};
else :T_K_ELSE T_LBR S T_RBR//{printf("else");};
while : T_K_WHILE T_LPAREN RELEXPR T_RPAREN T_LBR S T_RBR//{printf("\n while");};

S: ASSIGN S|ASSIGN|asexpr S |asexpr;


ASSIGN:T_K_TYPE T_ID T_OP_AS Y T_SEMICOLON  {insert($1,$2,@2.last_line,@2.first_column);} | T_K_TYPE T_ID T_SEMICOLON  {insert($1,$2,@2.last_line,@2.first_column);} | T_K_TYPE T_ID T_LB T_INT T_RB T_SEMICOLON  {insert($1,$2,@2.last_line,@2.first_column);};
Y:T_DATA|expr

RELEXPR: B relop B;
B : T_ID {if(lookup($1)<0){printf("\n%d:%d:%s\n",yylloc.first_line/2+1,yylloc.first_column,$1); yyerror("error variable referenced before assigned");}} | T_INT 


T_K_TYPE : T_K_INTEGER | T_K_FLOAT | T_K_CHAR |T_K_BOOLEAN ;
T_DATA : T_INT | T_FLOAT |T_K_FALSE|T_K_TRUE|T_CHAR ;
expr : x op expr|T_ID|T_INT;
x : T_ID {if(lookup($1)<0){printf("\n%d:%d:%s\n",yylloc.first_line/2+1,yylloc.first_column,$1); yyerror("error variable referenced before assigned");}} | T_INT 
op : T_OP_ADD | T_OP_SUB | T_OP_MUL | T_OP_DI;
relop : T_OP_EQ | T_OP_GT | T_OP_NE | T_OP_GE | T_OP_LT | T_OP_LE ;

asexpr : T_ID T_OP_AS B T_SEMICOLON {if(lookup($1)<0){printf("\n%d:%d:%s\n",yylloc.first_line/2+1,yylloc.first_column,$1); yyerror("error variable referenced before assigned");}} | T_ID T_OP_AS B op B T_SEMICOLON {if(lookup($1)<0){printf("\n%d:%d:%s\n",yylloc.first_line/2+1,yylloc.first_column,$1); yyerror("error variable referenced before assigned");}}
%%

int yyerror(char *msg)
{
 printf("%s",msg);
 printf("invalid syntax %d:%d\n",yylloc.first_line/2+1,yylloc.first_column);
 flag=1;
}

main()
{
 extern FILE* yyin;
 extern FILE* yyout;
 yyin=fopen("1.c","r");
 yyout=fopen("2.c","w");
 yyparse();
 if(flag){printf("compilation failed");}
 int counter=0;
for (counter=0;counter<=no_entries;counter++){
 printf("\n%s  %s  %d  %d",st[counter].type,st[counter].variable_name,st[counter].decl[0][0],st[counter].decl[0][1]);
 }
}
