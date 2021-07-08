%{
    #include <math.h>
    #include <string.h>
    #include "sin.tab.h"
    #include "structs.h"
    #define YYSTYPE double
%}
%option noyywrap
/* regular definitions */
delim       [ \n\t]
ws          {delim}+
letter      [A-Za-z]
digit       [0-9]
id          {letter}({letter}|{digit})*
double      {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
slash       "/"
com         {slash}{slash}(ws|.)*\n
%%

{ws}        {/* no action and no return */} 
if          {return IF;}
else        {return ELSE;}
for         {return FOR;}
while       {return WHILE;}
print       {return PRINT;}
false       {yylval.typeC = 'F'; return LOGIC;}
true        {yylval.typeC = 'T'; return LOGIC;}
return      {return RETURN;}
fun         {return FUN;}
"<"         {yylval.loCmp = 1; return CMP;} 
"<="        {yylval.loCmp = 2; return CMP;} 
"=="        {yylval.loCmp = 3; return CMP;} 
"!="        {yylval.loCmp = 4; return CMP;} 
">"         {yylval.loCmp = 5; return CMP;} 
">="        {yylval.loCmp = 6; return CMP;}
"**"        {return POW;}
"(" | 
")" |
"[" | 
"]" |
"&" | 
"|" |
"+" | 
"-" |
"*" | 
"/" |
"{" | 
"}" |
";" | 
"," |
"="         {return yytext[0];}
{double}    {yylval.d = newNumber(atof(yytext)); return NUMBER;}
{id}        {yylval.symbol =  lookUp(yytext); return ID;}
"/*"        {register int c;
                for ( ; ; ) {
                    while ( (c = input()) != '*' && c != EOF );    /* eat up text of comment */
                    if ( c == '*' ) {
                        while ( (c = input()) == '*');
                        if ( c == '/' )
                            break;    /* found the end */
                    }
                    if ( c == EOF ) {
                        /*error( "EOF in comment" );*/
                        break;
                    }
                }; 
            }
{com}
<<EOF>>     {static int once = 0; return (once = !once) ? END : 0;}
%%