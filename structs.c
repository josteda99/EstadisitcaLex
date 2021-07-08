#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "structs.h"

static int hashSymbol(char *symbol)			// Funcion de Hash lose lose 
{
	unsigned int hashValue = 0;
	unsigned ch;
	while(ch = *symbol++)
	{
		// ^ este es un XOR logico
		hashValue = hashValue * 9 ^ hashValue;
		return hashValue;
	}
}

struct symbol *lookUp(char *character) 
{
	struct symbol *s =  &symbolTable[hashSymbol(character) % NHASH];
	int capSymbol = NHASH; // Capcidad maxima de la Tabla de simbolos
	while(--capSymbol >= 0)
	{
		if(s->name && !strcmp(s->name, character))		// Revisa si el simbolo ya existe
			return s;
		if(!s->name)									// Crea el simolo
		{
			s->name = strdup(character);
			s->value = 0;
			return s;
		}
		if(++s >= symbolTable + NHASH)					// Manejo de colisiones
		{
			s = symbolTable;
		}
	}
	yyerror("Table symbol Overflow ocurred");
	abort();
}

struct numValue *newNumber(double number)
{
	struct numValue *n = malloc(sizeof(struct numValue));
	if(!n)
	{
		yyerror("Out of memory");
		exit(1);
	}
	n->num = number;
	n->nodeType = 'N';
	return n;
}

struct ast *newAst(int type, struct ast *left, struct ast *right)
{
	struct ast *tree = malloc(sizeof(struct ast));
	if (!tree)
	{
		yyerror("Out of memory");
		exit(1);
	}
	tree->nodeType = type;
	tree->left = left;
	tree->right = right;
	return tree;
}

struct ast *newPrint(struct ast *left)
{
	struct printStruct *p = malloc(sizeof(struct printStruct));
	if(!p) 
	{
		yyerror("Out of memory");
		exit(1);
	}
	p->nodeType = 'P';
	p->left = left;
	return (struct ast *)p;
}

struct ast *newDeclaration(struct symbol *symbol, struct ast *left)
{
	struct declaration *d = malloc(sizeof(struct declaration));
	if(!d)
	{
		yyerror("Out of memory");
		exit(1);
	}
	d->nodeType='d';
	d->symbol=symbol;
	d->left=left;
	return (struct ast *)d;
}

struct ast *newReference(struct symbol *symbol)
{
	struct refStruct *r = malloc(sizeof(struct refStruct));
	if (!r) 
	{
		yyerror("Out of memory");
		exit(1);
	}
	r->nodeType = 'R';
	r->symbol = symbol;
	return (struct ast *)r;
}

static double printStmt(struct printStruct *p);
static double declrStmt(struct declaration *d);

double evalStmt(struct ast *tree)
{
	double result;
	// printf("nodeType-> %d\n", tree->nodeType);
	switch (tree->nodeType)
	{
		case 'N':	// Number
			result = ((struct numValue *)tree)->num;
			break;
		case 'R': // Referencia a una variable
			result = (((struct refStruct*)tree)->symbol)->value;
			break;
		case '+': // Operacion aritmetica hasta el case 'M'
			result = evalStmt(tree->left) + evalStmt(tree->right);
			break;
		case '-':
			result = evalStmt(tree->left) - evalStmt(tree->right);
			break;
		case '*':
			result = evalStmt(tree->left) * evalStmt(tree->right);
			break;
		case '/':
			result = evalStmt(tree->left) * evalStmt(tree->right);
			break;
		case '_':
			result = pow(evalStmt(tree->left),evalStmt(tree->right));
			break;
		case 'M':	
			result = -evalStmt(tree->left);
			break;
		case 'P':	// Print
			result = printStmt((struct printStruct *)tree);
			break;
		case 'd':	// Declaracion de variables
			result = declrStmt((struct declaration *)tree);
			break;
		default:
			printf("Internal Error :(\n");
			break;
	}
	return result;
}

void freeAst(struct ast *tree)
{
	free(tree);
}

static double printStmt(struct printStruct *p)
{
	double result = evalStmt(p->left);
	if((p->left)->nodeType == 'R')
		printf("%s -> ",((struct refStruct *)(p->left))->symbol->name);
	else
		printf("Number -> ");
	printf("%.2f\n", result);
	return result;
}

static double declrStmt(struct declaration *d)
{
	(d->symbol)->value = evalStmt(d->left);
	(d->symbol)->initialIndex = 0;
	(d->symbol)->headArr = NULL;
	// yyerror("Unknown primitive type\n");
} 

void yyerror(char *s)
{
		fprintf(stderr, "Error: %s\n", 	s);
}

int main(int argc, char *argv[ ] ) {
    extern FILE *yyin;
    if (argc == 2){
		FILE *file = fopen(argv[1], "r");
		if (!file)
		{
			fprintf(stderr, "could not open %s\n",argv[1]);
		}
		yyin = file;
	}
	return yyparse();
}