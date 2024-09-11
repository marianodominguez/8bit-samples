.PHONY: clean

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Darwin)
$(error OSX not supported)
endif

clean:
	rm -rf bin/*.*
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