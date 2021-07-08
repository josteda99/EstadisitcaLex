void yyerror(char *s);

int yylex();
int yyparse();

struct symbol 
{
	double *headArr;		// Esto es para el caso en que el simbolo sea arreglo
	double value;
	
	char *name;
	int type;			// Indica si es Integer o Double

	int length;			// Longitud del arreglo
	int initialIndex;
};

#define NHASH 9997
struct symbol symbolTable[NHASH];

struct symbol *lookUp(char *s);		// Revisa si la 

struct symbolList
{
	struct symbol *symbol;
	struct symbolList *next;
};

struct numList
{
	double num;
	struct numList *next;
};

struct ast					// ast (Abstract Syntax Tree)
{
	int nodeType;			// Para identificar que tipo de sentencia se Tiene

	struct ast *left;
	struct ast *right;
};

struct numValue
{
	int nodeType;
	double num;
};

struct printStruct
{
	int nodeType;
	struct ast *left;
};

struct declaration
{
	int nodeType;
	struct symbol *symbol;
	struct ast * left;
};

struct refStruct
{
	int nodeType;
	struct symbol *symbol;
};

struct numValue *newNumber(double number);

struct ast *newPrint(struct ast *stmt);
struct ast *newAst(int type, struct ast *left, struct ast *right);
struct ast *numList(struct numValue *num, struct numList *next);
struct ast *newDeclaration(struct symbol *symbol, struct ast *left);
struct ast *newReference(struct symbol *symbol);

double evalStmt(struct ast *tree);
void freeAst(struct ast *tree);