target: all

FBPATH=/Users/mariano/fastbasic/build/compiler
SRC=$(PWD)

all: compile img atr

compile:
	cd $(FBPATH)
	$(FBPATH)/fb $(SRC)/abejuarez.bas
	cd $(SRC)

img:
	rm -f ABEJUARE.BMP
	./util/imgconv.py abejuarez_4_cr.bmp ABEJUARE.BMP

atr: 
	mkatr abejuarez.atr -b abejuarez.xex ABEJUARE.BMP