%{
#include <stdio.h>
#include "structs.h"
%}

%token IF ELSE ID NUMBER FOR WHILE PRINT RETURN FUN LOGIC
%token POW END

%type <typeC> LOGIC
%type <symbol> ID
%type <d> NUMBER
%type <tree> expr stat declare

%union{
    char typeC;                 // Para saber si es Integer (d), Double (f), True (T), False (F)
    int loCmp;                  // Para categorizar los operadores comparativos CMP 

    struct numValue *d;
    struct ast *tree;           // (Abstract Syntax Tree) ast
    struct symbol *symbol;      // En caso de que la lectura halla sido de un simbolo
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

prog: stmts END         {printf("Compiled Done ;)\n");};

stmts: /* empty */
     | stat stmts
     | function stmts;

expr: expr '+' expr                 {$$ = newAst('+', $1, $3);}
    | expr '-' expr                 {$$ = newAst('-', $1, $3);}
    | expr '*' expr                 {$$ = newAst('*', $1, $3);}
    | expr '/' expr                 {$$ = newAst('/', $1, $3);}
    | expr POW expr                 {$$ = newAst('_', $1, $3);}
    | '(' expr ')'                  {$$ = $2;}
    | '-' expr  %prec UMINUS        {$$ = newAst('M', $2, NULL);} 
    | PRINT '(' expr ')'            {$$ = newPrint($3);}
    | NUMBER                        {$$ = (struct ast *)$1;}
    | ID '[' expr ']' '[' expr ']'  {}
    | ID '[' expr ']'               {}
    | ID                            {$$ = newReference($1);};

stat: if_stat            {}
    | for_stat           {}
    | while_stat         {}
    | condition          {}
    | declare            {evalStmt($1);}
    | cont               {}
    | call_function      {}
    | expr               {evalStmt($1);};

bloque: stat bloque
      | /* empty */;

for_stat: FOR '(' ID '=' expr ';' condition ';' cont ')' '{' bloque '}';

while_stat: WHILE '(' condition ')' '{' bloque '}';

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
       | NUMBER
       | /* empty*/;

array: '{' sec_num '}';

sec_array: array ',' sec_array
         | array;

matrix: '{' sec_array '}';

declare: ID '[' expr ']' '[' expr ']' '=' matrix    {}
       | ID '[' expr ']' '[' expr ']' '=' expr      {}
       | ID '[' expr ']' '=' array                  {}
       | ID '[' expr ']' '=' expr                   {}
       | ID '=' expr                                {$$ = newDeclaration($1, $3);};

id_sec: ID ',' id_sec
      | ID
      | /* empty */;

function: FUN ID '(' id_sec ')' '{' bloque RETURN expr '}'
        | FUN ID '(' id_sec ')' '{' bloque '}';

call_function: ID '(' id_sec ')'
             | ID '(' sec_num ')';

if_stat: IF '(' condition ')' '{' bloque '}' ELSE '{' bloque '}'
       | IF '(' condition ')' '{' bloque '}';
%%