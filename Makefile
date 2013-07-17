PC=fpc
PFLAGS=-Ci -Co -Cr -gl
TEMPFILENAME := $(shell mktemp -u)

all: pcom pint pcom.pc ppp.pc test

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

ppp.pc: ppp.pas pcom
	@echo
	@echo 'Compiling ppp.pas'
	@echo '------------------'
	./pcom < ppp.pas
	mv prr ppp.pc

pcom.pc: pcom pint ppp.pc pcom.pas
	@echo
	@echo 'Compiling pcom.pas with itself'
	@echo '------------------------------'
	cp ppp.pc prd
	./pint < pcom.pas | ./pcom
	mv prr pcom.pc

test: pint pcom.pas pcom.pc ppp.pc
	@echo
	@echo 'Compiling pcom with the interpreted version of itself'
	@echo '-----------------------------------------------------'
	cp ppp.pc prd
	./pint < pcom.pas > $(TEMPFILENAME)
	cp pcom.pc prd
	./pint < $(TEMPFILENAME)
	@echo
	@echo 'Comparing the output with pcom.pc'
	@echo '---------------------------------'
	diff -w pcom.pc prr
	rm prd prr $(TEMPFILENAME)

clean:
	rm -rf pcom pint pcom.pc ppp.pc prr prd
