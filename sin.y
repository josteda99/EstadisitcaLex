%{
#include <math.h>
#include <stdio.h>
extern int yylex(void);
int yyerror(char *s);
FILE *yyin;
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
     | stat END stmts
     | END stmts ;

expr: expr ADD expr               {$$ = $1 + $3;}
    | expr SUB expr               {$$ = $1 - $3;}
    | expr MUL expr               {$$ = $1 * $3;}
    | expr DIV expr               {$$ = $1 / $3;}
    | expr POT expr               {$$ = pow($1, $3);}
    | LG expr RG                  {$$ = $2;}
    | SUB expr  %prec UMINUS      {$$ = - $2;} 
    | DOUBLE;

expr_id: expr_id ADD expr_id               
       | expr_id SUB expr_id               
       | expr_id MUL expr_id               
       | expr_id DIV expr_id               
       | expr_id POT expr_id               
       | LG expr_id RG                  
       | SUB expr_id  %prec UMINUS     
       | ID
       | DOUBLE;

stat: if_stat                     
    | for_stat                    
    | while_stat                  
    | print_stat
    | condition
    | declare
    | asig 
    | cont                                              
    | call_function               
    | expr;

bloque: stat END bloque 
      | ;

for_stat: FOR LG asig SEMICOLON condition SEMICOLON cont RG LF END bloque RF;

while_stat: WHILE LG condition RG LF END bloque RF;

print_stat: PRINT LG ID RG
          | PRINT LG expr RG              {printf("%f\n", $3);};

condition: bool_cond AB AB condition
         | bool_cond OB OB condition
         | num_cond AB AB condition
         | num_cond OB OB condition
         | num_cond
         | bool_cond
         | TRUE;

bool_cond: ID 
         | ID neq_eq TRUE
         | ID neq_eq FALSE
         | ID neq_eq ID;

neq_eq: EQ 
      | NE;

num_cond: ID oper DOUBLE
        | ID oper ID;

oper: neq_eq                      
    | LT                       
    | LE
    | GE
    | GT;                       

cont: ADD ADD ID
    | SUB SUB ID
    | ID ADD ADD
    | ID SUB SUB;

sec_num: DOUBLE COMMAN sec_num
       | DOUBLE; 

array: LR sec_num RR
     | LR RR;

sec_array: array COMMAN sec_array;

matrix: LR sec_array RR;

declare: ID LR DOUBLE RR LR DOUBLE RR ASIG matrix 
       | ID LR DOUBLE RR ASIG array
       | ID ASIG expr;

asig: ID LR DOUBLE RR LR DOUBLE RR ASIG expr
    | ID LR DOUBLE RR ASIG expr
    | ID ASIG ID
    | ID ASIG expr_id;

id_sec: ID COMMAN id_sec 
      | ID{printf("holandadsaf");}
      | /* empty */          ;

function: FUN ID LG id_sec RG LF END bloque RETURN expr_id RF
        | FUN ID LG id_sec RG LF END bloque RETURN expr RF
        | FUN ID LG id_sec RG LF END bloque RF;

call_function: ID LG id_sec RG 
             | ID LG sec_num RG;   

if_stat: IF LG condition RG LF END bloque RF ELSE LF END bloque RF
       | IF LG condition RG LF END bloque RF;

%%

int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}

int main(int argc, char *argv[ ] ) {
   FILE *file;
   if (argc == 2){
		file = fopen(argv[1],"r");
		if(!file){
			fprintf(stderr, "could not open %s\n",argv[1]);
			exit(1);
		}
		yyin = file;
	}
    yyparse();
    return 0;
}