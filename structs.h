void yyerror(char *s);

int yylex();
int yyparse();


struct symbol 
{
	double headArr;		// Esto es para el caso en que el simbolo sea arreglo
	double value;
	
	char *name;
	char type;

	int length;			// Longitud del arreglo
	int initialIndex;
};

#define NHASH 9997
struct symbol symbolTable[NHASH];

struct symbol *iSymbol(char *s);