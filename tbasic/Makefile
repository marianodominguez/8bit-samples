.PHONY: clean

UNAME_S := $(shell uname -s)
ATARI=atari800
ATR=franny
ATR_CMD=$(ATR) -A bin/disk.atr -i bin/AUTORUN.BAS -o AUTORUN.BAS
ifeq ($(UNAME_S),Darwin)
ATARI=/Applications/Atari800MacX/Atari800MacX.app/Contents/MacOS/Atari800MacX
ATR=atr
ATR_CMD=$(ATR) "bin/disk.atr" put -l bin/AUTORUN.BAS AUTORUN.BAS
endif

ATR_R := $(shell which $(ATR))
PARSER := $(shell which basicParser)

ifeq ($(ATR_R),)
$(error "$(ATR) program not found, install it before running" )
endif

ifeq ($(PARSER),)
$(error "basicParser program not found " )
endif

clean:
	rm -rf bin/*.*
% :: %.TBA
	cp ../atr_images/TBXL.atr bin/disk.atr
	basicParser -b -f -k -o bin/AUTORUN.BAS $<
	$(ATR_CMD)

% :: %.tba
	cp ../atr_images/TBXL.atr bin/disk.atr
	basicParser -b -f -k -o bin/AUTORUN.BAS $<
	$(ATR_CMD)
run:
	$(ATARI) bin/disk.atr