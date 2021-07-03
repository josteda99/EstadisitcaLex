%{
    #include <math.h>
    #include <string.h>
    #include "sin.tab.h"
    int pointerID = 0;
    char *tableID[50];
    int yywrap();
    void insertID();
%}

/* regular definitions */
delim       [ \t]
ws          {delim}+
letter      [A-Za-z]
digit       [0-9]
id          {letter}({letter}|{digit})*
number      {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
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
{com}       {return COM;}
{number}    {yylval.num = atof(yytext); return NUMBER;}
{id}        {insertID(); return ID;}
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
                }; return BCOM;
            }
"\n"        {return END;};
%%
int yywrap() {}

void insertID() 
{ 
    int i = 0;
    int inTable = 0;
    for(i = 0; i < pointerID; i++)
    {
        if(strcmp(tableID[i], yytext) == 0)
        {
            inTable = 1;
            break;
        }
    }
    if (i == pointerID) 
    {
        tableID[pointerID] = strdup(yytext);
        yylval.name = strdup(yytext);
        yylval.number = pointerID++;
    }else{
        if(inTable == 1) {
            yylval.number = i;
        }
    }
}