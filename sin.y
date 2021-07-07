%{
#include <math.h>
#include <stdio.h>
#include "structs.h"
%}

%token IF ELSE ID NUMBER FOR WHILE PRINT RETURN FUN LOGIC
%token POW END

%type <symbol> ID
%type <d> NUMBER expr
%type <typeC> LOGIC

%union{
    double d;               // Para el control de numeros
    struct symbol *symbol;  // En caso de que la lectura halla sido de un simbolo

    char typeC;             // Para saber si es Integer (i), Double (d), True (t), False (f)
    int loCmp               // Para categorizar los operadores comparativos CMP 
};

%nonassoc <loCmp> CMP       
/* El mapeado de CMP es
    <       loCmp : 1
    <=      loCmp : 2
    ==      loCmp : 3
    !=      loCmp : 4
    >       loCmp : 5
    >=      loCmp : 6
*/

%right '='
%left '+' '-'
%left '*' '/'
%right UMINUS
%right POW

%start prog
%%

prog: stmts;

stmts: /* empty */
     | stat END stmts
     | END stmts
     | function END stmts;

expr: expr '+' expr               {$$ = $1 + $3;}
    | expr '-' expr               {$$ = $1 - $3;}
    | expr '*' expr               {$$ = $1 * $3;}
    | expr '/' expr               {$$ = $1 / $3;}
    | expr POW expr               {$$ = pow($1, $3);}
    | '(' expr ')'                {$$ = $2;}
    | '-' expr  %prec UMINUS      {$$ = - $2;} 
    | NUMBER                      {$$ = $1;};

expr_id: expr_id '+' expr_id
       | expr_id '-' expr_id
       | expr_id '*' expr_id
       | expr_id '*' expr_id
       | expr_id POW expr_id
       | '(' expr_id ')'
       | '-' expr_id  %prec UMINUS
       | ID
       | NUMBER;

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
      | /* empty */;

for_stat: FOR '(' ID '=' expr ';' condition ';' cont ')' '{' END bloque '}';

while_stat: WHILE '(' condition ')' '{' END bloque '}';

print_stat: PRINT '(' ID ')'
          | PRINT '(' expr ')'                  {printf("%f\n", $3);};

condition: simple_condition '&' '&' condition
         | simple_condition '|' '|' condition
         | simple_condition
         | LOGIC;

simple_condition: ID
                | ID CMP LOGIC
                | ID CMP NUMBER
                | ID CMP ID;

cont: '+' '+' ID
    | '-' '-' ID
    | ID '+' '+'
    | ID '-' '-';

sec_num: NUMBER ',' sec_num
       | NUMBER;

array: '[' sec_num ']'
     | '[' ']';

sec_array: array ',' sec_array;

matrix: '[' sec_array ']';

declare: ID '[' NUMBER ']' '[' NUMBER ']' '=' matrix
       | ID '[' NUMBER ']' '=' array
       | ID '=' expr;

asig: ID '[' NUMBER ']' '[' NUMBER ']' '=' expr
    | ID '[' NUMBER ']' '[' NUMBER ']' '=' matrix
    | ID '[' NUMBER ']' '=' expr
    | ID '=' ID
    | ID '=' expr_id;

id_sec: ID ',' id_sec
      | ID
      | /* empty */;

function: FUN ID '(' id_sec ')' '{' END bloque RETURN expr_id '}'
        | FUN ID '(' id_sec ')' '{' END bloque RETURN expr '}'
        | FUN ID '(' id_sec ')' '{' END bloque '}'
        | FUN ID '(' id_sec ')' '{' END bloque '}';

call_function: ID '(' id_sec ')'
             | ID '(' sec_num ')';

if_stat: IF '(' condition ')' '{' END bloque '}' ELSE '{' END bloque '}'
       | IF '(' condition ')' '{' END bloque '}';
%%