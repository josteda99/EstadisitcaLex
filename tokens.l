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
false       {return FALSE;}
true        {return TRUE;}
return      {return RETURN;}
fun         {return FUN;}
"<"         {return LT;} 
"<="        {return LE;} 
"=="        {return EQ;} 
"!="        {return NE;} 
">"         {return GT;} 
">="        {return GE;}
"("         {return LG;}
")"         {return RG;}
"["         {return LR;}
"]"         {return RR;}
"&"         {return AB;}
"|"         {return OB;}
"+"         {return ADD;}
"-"         {return SUB;}
"*"         {return MUL;}
"/"         {return DIV;}
"**"        {return POT;}
"{"         {return LF;}
"}"         {return RF;}
";"         {return SEMICOLON;}
","         {return COMMAN;}
"="         {return ASIG;}
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
.           {yyerror("Unknow Character.\n");}
<<EOF>>     {static int once = 0; return (once = !once) ? END : 0;}
%%