%{
#include <math.h>
#include <stdio.h>
extern int yylex(void);
int yyerror(char *s);
%}
%token IF ELSE ID NUMBER
%token FOR WHILE COM  BCOM 
%token LT LE  EQ  NE  GT  GE 
%token PRINT LG RG LR RR AB 
%token OB ADD SUB MUL DIV POT 
%token FALSE TRUE LF RF ASIG 
%token RETURN ARITOP FUN
%token RELOP GROUP ARRAY BINOP 
%token FUNCTION SEMICOLON COMMAN END
%type <name> ID
%type <num> NUMBER
%type <num> expr

%union{
    char *name;
    int number;
    double num;
}

%left ADD SUB
%left MUL DIV
%right POT
%right UMINUS

%start Input

%%

Input: /* empty */;
Input: Input Line;

Line: END;
Line: expr END                    {printf("Resultado: %f\n", $1);};

expr: expr ADD expr               {$$ = $1 + $3; printf("%f + %f\n", $1, $3);};
expr: expr SUB expr               {$$ = $1 - $3; printf("%f - %f\n", $1, $3);};
expr: expr MUL expr               {$$ = $1 * $3; printf("%f * %f\n", $1, $3);};
expr: expr DIV expr               {$$ = $1 / $3; printf("%f / %f\n", $1, $3);};
expr: expr POT expr               {$$ = pow($1, $3); printf("%f ^ %f\n", $1, $3);};
expr: LG expr RG                  {$$ = $2; };
expr: SUB expr  %prec UMINUS      {$$ = - $2;};
expr: NUMBER;

// stat        : if_stat                     {$$ = $1;}
//             | for_stat                    {$$ = $1;}
//             | while_stat                  {$$ = $1;}
//             | print_stat                  {$$ = $1;}
//             | condition                   {$$ = $1;}
//             | asig                        {$$ = $1;}
//             | NUMBER                      {$$ = $1;}
//             | cont                        {$$ = $1;}
//             | array                       {$$ = $1;}
//             | matrix                      {$$ = $1;}
//             | call_function               {$$ = $1;}
//             | expr                        {$$ = $1;};

// for_stat    : "for" '(' asig ';' condition ';' cont ')' '{' stat '}';

// while_stat  : "while"'(' condition ')' '{'stat'}';

// print_stat  : "print" '(' ID ')';

// condition   : (bool_cond | num_cond) (('&''&' | '|''|') condition)? ;

// bool_cond   : ID 
//             | ID neq_eq (true | false);

// neq_eq      : "==" 
//             | "!=";

// num_cond    : ID oper NUMBER;

// oper        : neq_eq                      
//             | '<'                         
//             | "<="                        
//             | ">="                       
//             | ">" ;                       


// cont        : '+''+'ID                   {$$ = ++ $3}
//             | '-''-'ID                   {$$ = -- $3}
//             | ID'+''+'                   {$$ = $1 ++}
//             | ID'-''-'                   {$$ = $1 --};

// array       : '[' (NUMBER ',')* ']':

// matrix      : '[' (array',')* ']';

// asig        : ID ( '[' NUMBER ']' ( '[' NUMBER ']' )? )? '=' (expr | array | matrix);

// function    : "fun" ID '(' ID* ')' '{' stat (RETURN (ID | NUMBER))? '}'

// call_function : ID '(' ID* ')' ;   

// if_stat     : "if" '(' condition ')' '{' stat'}' ('else' '{'stat'}' )?;          
// {if ($3 == true) {$$ = $6}}; 

%%

int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}

int main() {
    yyparse();
    return 0;
}