%{
#include <math.h>
#include <stdio.h>
#include "structs.h"
%}

%token If ELSE ID NUMBER FOR WHILE PRINT FALSE TRUE RETURN FUN 

%token LT LE  EQ  NE  GT  GE 
%token LG RG LR RR AB 
%token OB ADD SUB MUL DIV POT 
%token LF RF ASIG
%token SEMICOLON COMMAN END

%type <symbol> ID
%type <d> NUMBER expr

%union{
    char *name;
    int integer;
    double d;
    struct symbol *         // En caso de que la lectura halla sido de un simbolo

    char type;              // Para saber si es Integer (i), Double (d), True (t), False (f)
    bit 
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
     | END stmts
     | function END stmts ;

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
    | ID ASIG expr_id                       {};

id_sec: ID COMMAN id_sec 
      | ID
      | /* empty */          ;

function: FUN ID LG id_sec RG LF END bloque RETURN expr_id RF
        | FUN ID LG id_sec RG LF END bloque RETURN expr RF
        | FUN ID LG id_sec RG LF END bloque RF
        | FUN ID LG id_sec RG LF END bloque RF;

call_function: ID LG id_sec RG 
             | ID LG sec_num RG;   

if_stat: IF LG condition RG LF END bloque RF ELSE LF END bloque RF
       | IF LG condition RG LF END bloque RF;

%%