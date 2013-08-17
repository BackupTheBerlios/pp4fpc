ppparser: y.tab.c y.tab.h lex.yy.c
	$(CC) $(CFLAGS) y.tab.c lex.yy.c -o ppparser

y.tab.c y.tab.h: pascalp.y
	$(YACC) -d pascalp.y

lex.yy.c: pascalp.l
	$(LEX) pascalp.l

clean:
	rm -f y.tab.c y.tab.h lex.yy.c ppparser
