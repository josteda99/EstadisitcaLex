%{
#include <stdio.h>
int yylex();
int yyerror(char *s);

%}

%token STRING 
%token NUM 
%token OTHER 
%token SEMICOLON

%type <name> STRING
%type <number> NUM

%union{
	  char name[20];
    int number;
}

%%


linea       : linea expr '\n'             {printf("%g\n, $2");}
            | linea '\n'
            | ;

expr        : expr '+' expr               {$$ = $1 + $3;}
            | expr '-' expr               {$$ = $1 - $3;}
            | expr '*' expr               {$$ = $1 * $3;}
            | expr '/' expr               {$$ = $1 / $3;}
            | '(' expr ')'                {$$ = $2;}
            | '-' expr  %prec UMINUS      {$$ = - $2;}
            | num;

stat        : if_stat                     {$$ = $1;}
            | for_stat                    {$$ = $1;}
            | while_stat                  {$$ = $1;}
            | print_stat                  {$$ = $1;}
            | condition                   {$$ = $1;}
            | asig                        {$$ = $1;}
            | num                         {$$ = $1;}
            | cont                        {$$ = $1;}
            | array                       {$$ = $1;}
            | matrix                      {$$ = $1;}
            | call_function               {$$ = $1;};

for_stat    : 'for' '(' asig ';' condition ';' cont ')' '{' stat '}';

while_stat  : 'while''(' condition ')' '{'stat'}';

print_stat  : 'print' '(' 'id' ')';

condition   : (bool_cond | num_cond) (('&''&' | '|''|') condition)? ;

bool_cond   : 'id' 
            | 'id' neq_eq (true | false);

neq_eq      : '==' 
            | '!=';

num_cond    : 'id' oper num;

oper        : neq_eq                      
            | '<'                         
            | '<='                        
            | '>='                        
            | '>' ;                       

num         : 'number';

cont        : '+''+'num                   {$$ = ++ $3}
            | '-''-'num                   {$$ = -- $3}
            | num'+''+'                   {$$ = $1 ++}
            | num'-''-'                   {$$ = $1 --};

array       : '[' (num ',')* ']':

matrix      : '[' (array',')* ']';

asig        : 'id' ( '[' num ']' ( '[' num ']' )? )? '=' (expr | array | matrix);

function    : fun 'id' '(' 'id'* ')' '{' stat ('return' ('id' | num))? '}'

call_function : 'id' '(' 'id'* ')' ;   

if_stat     : 'if' '(' condition ')' '{' stat'}' ('else' '{'stat'}' )?; 


prog: stmts;

stmts:
      | stmt SEMICOLON stmts

stmt: STRING      {printf("Your entered a string - %s", $1);}
	| NUM       {printf("The number you entered is - %d", $1);}
	| OTHER;

%%

int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}

int main()
{
    yyparse();
    return 0;
}