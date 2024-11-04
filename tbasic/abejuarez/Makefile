target: all

SRC=.

all: compile img atr run

compile:
	cd $(FBPATH)
	basicParser -b -f -k  $(SRC)/abejuarez.tba -o AUTORUN.BAS
	cd $(SRC)

img:
	rm -f ABEJUARE.BMP
	./util/imgconv.py abejuarez_full.bmp ABEJUARE.BMP

atr:
	cp ../../atr_images/TBXL.atr abejuarez.atr
	franny  -A -i AUTORUN.BAS -o AUTORUN.BAS abejuarez.atr
	franny  -A -i ABEJUARE.BMP -o ABEJUARE.BMP abejuarez.atr
run: compile img atr
	atari800 abejuarez.atr