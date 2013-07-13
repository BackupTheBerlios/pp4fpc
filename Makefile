PC=fpc
PFLAGS=-Ci -Co -Cr -gl

all: pcom 

pcom: pcom.pas
	$(PC) $(PFLAGS) pcom.pas
	rm -f pcom.o

clean:
	rm -rf pcom
