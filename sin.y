%{
%include <stdio.h>
int yylex();
int yyerror(char *s);

%}
%token IF 
%token ELSE 
%token ID 
%token NUMBER 
%token FOR 
%token WHILE 
%token COM 
%token BCOM 
%token LT 
%token LE 
%token EQ 
%token NE 
%token GT 
%token GE 
%token PRINT 
%token LG 
%token RG 
%token LR 
%token RR 
%token AB 
%token OB 
%token ADD 
%token SUB 
%token MUL 
%token DIV 
%token POT 
%token FALSE 
%token TRUE 
%token LF 
%token RF 
%token ASIG 
%token RETURN 
%token RELOP 
%token GROUP 
%token ARRAY 
%token BINOP 
%token ARITOP 
%token FUNCTION 
%token SEMICOLON 
%token COMMAN 
%token FUN 
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