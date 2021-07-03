%{
    #include <math.h>
    #include <string.h>
    int yylval = -1;
    int pointerNum = 0;
    int pointerID = 0;
    int tableNum[50];
    char *tableID[50];
%}

/* regular definitions */
delim       [ \t\n]
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
"<"         {yylval.number = LT; return RELOP;} 
"<="        {yylval.number = LE; return RELOP;} 
"=="        {yylval.number = EQ; return RELOP;} 
"!="        {yylval.number = NE; return RELOP;} 
">"         {yylval.number = GT; return RELOP;} 
">="        {yylval.number = GE; return RELOP;}
"("         {yylval.number = LG; return GROUP;}
")"         {yylval.number = RG; return GROUP;}
"["         {yylval.number = LR; return ARRAY;}
"]"         {yylval.number = RR; return ARRAY;}
"&"         {yylval.number = AB; return BINOP;}
"|"         {yylval.number = OB; return BINOP;}
"+"         {yylval.number = ADD; return ARITOP;}
"-"         {yylval.number = SUB; return ARITOP;}
"*"         {yylval.number = MUL; return ARITOP;}
"/"         {yylval.number = DIV; return ARITOP;}
"**"        {yylval.number = POT; return ARITOP;}
"{"         {yylval.number = LF; return FUNCTION;}
"}"         {yylval.number = RF; return FUNCTION;}
";"         {return SEMICOLON;}
","         {return COMMAN;}
"="         {return ASIG;}
{com}       {return COM;}
{number}    {tableNum[pointerNum] = atoi(yytext); yylval.number = pointerNum++; return NUMBER;}
{id}        { return ID;}
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
%%
int yywrap() {}

void insertID() 
{ 
    int i = 0;
    for(i = 0; i < pointerID; i++)
    {
        if(strcmp(tableID[i], yytext) == 0)
        {
            break;
        }
    }
    if (i == pointerID) 
    {
        tableID[pointerID] = yytext;
        yylval.number = pointerID++;
    } else {
        yylval.number = i;
    }
}