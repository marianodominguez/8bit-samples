.PHONY: clean

UNAME_S := $(shell uname -s)
ATARI=atari800 -no-autosave-config
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
	cp ../atr_images/DOS2_5.atr bin/disk.atr
	tr '\12\11' '\233\177' < $< > bin/AUTO.ACT
	$(ATR_CMD) bin/AUTO.ACT -o AUTO.ACT

% :: %.ACT
	cp ../atr_images/DOS2_5.atr bin/disk.atr
	tr '\12\11' '\233\177' < $< > bin/AUTO.ACT
	$(ATR_CMD) bin/AUTO.ACT -o AUTO.ACT
run:
	$(ATARI) -cart ../atr_images/action.rom bin/disk.atr &
	sleep 2
	./run_action.sh
	
