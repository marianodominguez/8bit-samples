target: all

FBPATH=/opt/fastbasic/
SRC=.

all: clean compile img atr

clean:
	mkdir -p bin
	rm -rf bin/*

compile:
	cp $(SRC)/abejuarez.bas bin/
	cd $(FBPATH)
	$(FBPATH)/fb $(SRC)/bin/abejuarez.bas
	cd $(SRC)

img:
	./util/imgconv.py abejuarez_full.bmp bin/ABEJUARE.BMP

atr:
	cp mydos42.atr bin/abejuarez.atr
	franny  -A -i bin/abejuarez.xex -o AUTORUN.SYS bin/abejuarez.atr
	franny  -A -i bin/ABEJUARE.BMP -o ABEJUARE.BMP bin/abejuarez.atr

run: all
	atari800 bin/abejuarez.atr