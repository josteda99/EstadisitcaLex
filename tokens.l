%{
    #include <math.h>
    #include <string.h>
    #include "sin.tab.h"
    #include "structs.h"
    #define YYSTYPE double
%}
%option noyywrap
/* regular definitions */
delim       [ \t]
ws          {delim}+
letter      [A-Za-z]
digit       [0-9]
id          {letter}({letter}|{digit})*
double      {digit}+(\.{digit}+)(E[+-]?{digit}+)?
integer     {digit}+(E[+-]?{digit}+)?
slash       "/"
com         {slash}{slash}(ws|.)*\n
%%

{ws}        {/* no action and no return */} 
if          {return IF;}
else        {return ELSE;}
for         {return FOR;}
while       {return WHILE;}
print       {return PRINT;}
false       {yylval.typeC = 'f'; return LOGIC;}
true        {yylval.typeC = 't'; return LOGIC;}
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
{integer}   {yylval.typeC = 'i'; yylval.d = atof(yytext); return NUMBER;}
{double}    {yylval.typeC = 'd'; yylval.d = atof(yytext); return NUMBER;}
{id}        {yylval.symbol =  iSymbol(yytext); return ID;}
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
"\n"        {return END;};
<<EOF>>     {static int once = 0; return (once = !once) ? END : 0;}
%%