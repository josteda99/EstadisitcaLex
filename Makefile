default:
	clear
	flex -l tokens.l
	bison -dv sin.y 
	gcc -o ./c.out sin.tab.c lex.yy.c -lfl -lm