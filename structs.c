#include <stdlib.h>
#include <stdio.h>
#include <string.h>
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
	struct symbol *s = $(symbolTable[hashSymbol(character) % NHASH]);
	int capSymbol = NHASH; 								// Capcidad maxima de la Tabla de simbolos
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

void yyerror(char *s)
{
	fprintf(stderr, "Error: %s\n", 	s);
}

int main(int argc, char *argv[ ] ) {
    extern FILE *yyin;
    if (argc == 2){
		if(yyin = fopen(argv[1],"r")){
			fprintf(stderr, "could not open %s\n",argv[1]);
		}
	}
    return yyparse();
}