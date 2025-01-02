.PHONY: clean

UNAME_S := $(shell uname -s)
ATARI=atari800
ATR=franny
ATR_CMD=$(ATR) -A bin/disk.atr -i
ifeq ($(UNAME_S),Darwin)
ATARI=/Applications/Atari800MacX/Atari800MacX.app/Contents/MacOS/Atari800MacX
ATR=atr
ATR_CMD=$(ATR) "bin/disk.atr" put -l 
endif

ATR_R := $(shell which $(ATR))

ifeq ($(ATR_R),)
$(error "$(ATR) program not found, install it before running" )
endif


clean:
	rm -rf bin/*.*
% :: %.act
	cp ../atr_images/action.atr bin/disk.atr
	$(ATR_CMD) $< -o AUTO.ACT

% :: %.ACT
	cp ../atr_images/action.atr bin/disk.atr
	$(ATR_CMD) $< -o AUTO.ACT
run:
	$(ATARI) -cart ../atr_images/action.rom bin/disk.atr