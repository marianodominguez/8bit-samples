target: all

SRC=.

all: clean compile img atr run

clean:
	rm -f ./bin/*

compile:
	cd $(FBPATH)
	basicParser -b -f -k  $(SRC)/abejuarez.tba -o bin/AUTORUN.BAS
	cd $(SRC)

img:
	./util/imgconv.py abejuarez_full.bmp ./bin/ABEJUARE.BMP

atr:
	cp ../../atr_images/TBXL.atr ./bin/abejuarez.atr
	franny  -A -i bin/AUTORUN.BAS -o AUTORUN.BAS bin/abejuarez.atr
	franny  -A -i bin/ABEJUARE.BMP -o ABEJUARE.BMP bin/abejuarez.atr
run: clean compile img atr
	atari800 ./bin/abejuarez.atr