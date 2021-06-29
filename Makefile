default:
	clear
	flex -l file.l
	bison -dv sinsem.y 
	gcc -o ./a.out .tab.c lex.yy.c -lfl