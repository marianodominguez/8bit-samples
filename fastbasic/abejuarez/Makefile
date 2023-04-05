target: all

FBPATH=/opt/fastbasic/
SRC=.

all: compile img atr

compile:
	cd $(FBPATH)
	$(FBPATH)/fb $(SRC)/abejuarez.bas
	cd $(SRC)

img:
	rm -f ABEJUARE.BMP
	./util/imgconv.py abejuarez_full.bmp ABEJUARE.BMP

atr:
	cp mydos42.atr abejuarez.atr
#	franny  -A -i xbootdos.obx -o DOS.SYS abejuarez.atr
	franny  -A -i abejuarez.xex -o AUTORUN.SYS abejuarez.atr
	franny  -A -i ABEJUARE.BMP -o ABEJUARE.BMP abejuarez.atr