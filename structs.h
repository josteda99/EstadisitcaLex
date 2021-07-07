void yyerror(char *s);

int yylex();
int yyparse();


struct symbol 
{
	double headArr;		// Esto es para el caso en que el simbolo sea arreglo
	double value;
	
	char *name;
	char type;			// Indica si es Integer o Double

	int length;			// Longitud del arreglo
	int initialIndex;
};

#define NHASH 9997
struct symbol symbolTable[NHASH];

struct symbol *iSymbol(char *s);

struct symbolList
{
	struct symbol *node;
	struct symbolList *next;
};

struct numList
{
	double num;
	struct numList *next;
};

struct ast
{
	int nodeType;			// Para identificar que tipo de sentencia se Tiene

	struct ast *left;
	struct ast *right;
};

struct numValue
{
	int nodeType;
	int numType;
	double num;
};

struct printStruct
{
	int nodeType;
	struct ast *left;
};

struct numValue *newNumber(double number, char type);

struct ast *callPrint(struct ast *stmt);
struct ast *newAst(int type, struct ast *left, struct ast *right);
struct ast *addNum(struct numValue *num);

double evalStmt(struct ast *tree);