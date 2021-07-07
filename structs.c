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

struct symbol *iSymbol(char *character) 
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

struct numValue *newNumber(double number, char typeC)
{
	struct numValue *n = malloc(sizeof(struct numValue));
	if(!n)
	{
		yyerror("Out of memory");
		exit(1);
	}
	n->num = number;
	n->nodeType = 'N';
	n->numType = typeC;
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

struct ast *callPrint(struct ast *left)
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

static double printStmt(struct printStruct *p);

double evalStmt(struct ast *tree)
{
	double result;
	switch (tree->nodeType)
	{
		case 'N':
			result = ((struct numValue *)tree)->num;
			break;
		case '+':
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
		case 'P':
			result = printStmt((struct printStruct *)tree);
			break;
		default:
			printf("Internal Error :(\n");
			break;
	}
	return result;
}

static double printStmt(struct printStruct *p)
{
	double result = evalStmt(p->left);
	printf("%f\n", result);
	return result;
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