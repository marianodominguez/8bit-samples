.PHONY:default
default: build ;

FILE=CHILE.TBA

clean:
	rm -rf bin/*.*
build:clean
	cp ../atr_images/TBXL.atr bin/disk.atr
	basicParser -b -f -k -o bin/AUTORUN.BAS $(FILE)
	franny -A bin/disk.atr -i bin/AUTORUN.BAS -o AUTORUN.BAS

 % :: %.TBA
	cp ../atr_images/TBXL.atr bin/disk.atr
	basicParser -b -f -k -o bin/AUTORUN.BAS $<
	franny -A bin/disk.atr -i bin/AUTORUN.BAS -o AUTORUN.BAS

 % :: %.tba
	cp ../atr_images/TBXL.atr bin/disk.atr
	basicParser -b -f -k -o bin/AUTORUN.BAS $<
	franny -A bin/disk.atr -i bin/AUTORUN.BAS -o AUTORUN.BAS
run:
	atari800 bin/disk.atr