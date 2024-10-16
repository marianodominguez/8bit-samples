.PHONY: clean

UNAME_S := $(shell uname -s)
ATARI=atari800
ifeq ($(UNAME_S),Darwin)
ATARI=Atari800MacX
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
	$(ATARI) bin/disk.atr