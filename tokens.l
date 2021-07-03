%{
    #include <math.h>
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
"<"         {yylval = LT; return RELOP;} 
"<="        {yylval = LE; return RELOP;} 
"=="        {yylval = EQ; return RELOP;} 
"!="        {yylval = NE; return RELOP;} 
">"         {yylval = GT; return RELOP;} 
">="        {yylval = GE; return RELOP;}
"("         {yylval = LG; return GROUP;}
")"         {yylval = RG; return GROUP;}
"["         {yylval = LR; return ARRAY;}
"]"         {yylval = RR; return ARRAY;}
"&"         {yylval = AB; return BINOP;}
"|"         {yylval = OB; return BINOP;}
"+"         {yylval = ADD; return ARITOP;}
"-"         {yylval = SUB; return ARITOP;}
"*"         {yylval = MUL; return ARITOP;}
"/"         {yylval = DIV; return ARITOP;}
"**"        {yylval = POT; return ARITOP;}
"{"         {yylval = LF; return FUNCTION;}
"}"         {yylval = RF; return FUNCTION;}
";"         {return SEMICOLON;}
","         {return COMMAN;}
"="         {return ASIG;}
{com}       {return COM;}
{number}    {tableNum[pointerNum] = atoi(yytext); yylval = pointerNum++; return NUMBER;}
{id}        {tableID[pointerID] = yytext; yylval = pointerID++; return ID;}
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