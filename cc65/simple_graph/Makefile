.ONESHELL:
.PRECIOUS: src/%.s src/%.map

#Atari or atarixl
SYS ?= atari

NULLDEV = /dev/null
DEL = $(RM)
RMDIR = $(RM) -r
CC65_INC=/usr/share/cc65/include

ifndef PROG
  PROG = cube_opt
endif

ifdef CC65_HOME
  AS = $(CC65_HOME)/bin/ca65
  CC = $(CC65_HOME)/bin/cc65
  CL = $(CC65_HOME)/bin/cl65
  LD = $(CC65_HOME)/bin/ld65
else
  AS := $(if $(wildcard /usr/bin/ca65*),/usr/bin/ca65,ca65)
  CC := $(if $(wildcard /usr/bin/ca65*),/usr/bin/cc65,cc65)
  CL := $(if $(wildcard /usr/bin/ca65*),/usr/bin/cl65,cl65)
  LD := $(if $(wildcard /usr/bin/ca65*),/usr/bin/ld65,ld65)
endif

$(PROG): clean
	$(CC) -t $(SYS) -O --static-locals -I include -o bin/$(PROG).s src/$(PROG).c src/atari_draw.s src/fp_trig.c
	$(CL) -t $(SYS) -C cfg/atari_mem.cfg -O -Wl "-D__RESERVED_MEMORY__=0x2000" --static-locals -I include -o bin/$(PROG) src/$(PROG).c src/atari_draw.s src/fp_trig.c
clean:
	@$(DEL) bin/* 2>$(NULLDEV)
dist: $(PROG)
	mkdir -p tmp
	rm -rf tmp/*
	cp bin/$(PROG) tmp/AUTO
	dir2atr -S -B assets/xbootdos.obx bin/$(PROG).atr tmp