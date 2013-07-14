PC=fpc
PFLAGS=-Ci -Co -Cr -gl

all: pcom pint pcom.pc

pcom: pcom.pas
	@echo
	@echo 'Compiling pcom.pas'
	@echo '------------------'
	$(PC) $(PFLAGS) pcom.pas
	rm -f pcom.o

pint: pint.pas
	@echo
	@echo 'Compiling pint.pas'
	@echo '------------------'
	$(PC) $(PFLAGS) pint.pas
	rm -f pint.o

pcom.pc: pcom pint pcom.pas
	@echo
	@echo 'Compiling pcom.pas with itself'
	@echo '------------------------------'
	./ppp.pl pcom.pas | ./pcom
	mv prr pcom.pc

test: pint pcom.pas pcom.pc
	@echo
	@echo 'Compiling pcom with the interpreted version of itself'
	@echo '-----------------------------------------------------'
	cp pcom.pc prd
	./ppp.pl pcom.pas | ./pint

	@echo
	@echo 'Comparing the output with pcom.pc'
	@echo '---------------------------------'
	diff -w pcom.pc prr
	rm prd prr

clean:
	rm -rf pcom pint pcom.pc prr prd
