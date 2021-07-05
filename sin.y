%{
#include <math.h>
#include <stdio.h>
extern int yylex(void);
int yyerror(char *s);
%}
%token IF ELSE ID DOUBLE
%token FOR WHILE COM  BCOM 
%token LT LE  EQ  NE  GT  GE 
%token PRINT LG RG LR RR AB 
%token OB ADD SUB MUL DIV POT 
%token FALSE TRUE LF RF ASIG 
%token RETURN ARITOP FUN
%token RELOP GROUP ARRAY BINOP 
%token FUNCTION SEMICOLON COMMAN END
%type <name> ID
%type <real> DOUBLE
%type <real> expr

%union{
    char *name;
    int integer;
    double real;
}

%left ADD SUB
%left MUL DIV
%right POT
%right UMINUS

%start prog

%%

prog: stmts;

stmts: /* empty */
     | stat stmts;

expr: expr ADD expr               {$$ = $1 + $3;}
    | expr SUB expr               {$$ = $1 - $3;}
    | expr MUL expr               {$$ = $1 * $3;}
    | expr DIV expr               {$$ = $1 / $3;}
    | expr POT expr               {$$ = pow($1, $3);}
    | LG expr RG                  {$$ = $2;}
    | SUB expr  %prec UMINUS      {$$ = - $2;}
    | DOUBLE;

stat: if_stat                     
    | for_stat                    
    | while_stat                  
    | print_stat
    | condition
    | declare
    | asig
    | cont                        
    | array                       
    | matrix                      
    | call_function               
    | expr;

for_stat: FOR LG asig SEMICOLON condition SEMICOLON cont RG LF stat RF;

while_stat: WHILE LG condition RG LF stat RF;

print_stat: PRINT LG ID RG
          | PRINT LG expr RG              {printf("%f\n", $3);};

condition: bool_cond AB AB condition
         | bool_cond OB OB condition
         | num_cond AB AB condition
         | num_cond OB OB condition
         | num_cond
         | bool_cond;

bool_cond: ID 
         | ID neq_eq TRUE
         | ID neq_eq FALSE;

neq_eq: EQ 
      | NE;

num_cond: ID oper DOUBLE;

oper: neq_eq                      
    | LT                       
    | LE
    | GE
    | GT;                       

cont: ADD ADD ID
    | SUB SUB ID
    | ID ADD ADD
    | ID SUB SUB;

sec_num: DOUBLE COMMAN sec_num;

array: LR sec_num RR
     | LR RR;

sec_array: array COMMAN sec_array;

matrix: LR sec_array RR;

declare: ID LR DOUBLE RR LR DOUBLE RR ASIG matrix 
       | ID LR DOUBLE RR ASIG array
       | ID ASIG expr;

asig: ID LR DOUBLE RR LR DOUBLE RR ASIG expr
    | ID LR DOUBLE RR ASIG expr;

id_sec: ID COMMAN id_sec 
      | /* empty */;

function: FUN ID LG id_sec RG LF stat RETURN ID RF
        | FUN ID LG id_sec RG LF stat RETURN DOUBLE RF
        | FUN ID LG id_sec RG LF stat RF;

call_function: ID LG id_sec RG ;   

if_stat: IF LG condition RG LF stat RF ELSE LF stat RF
       | IF LG condition RG LF stat RF;

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