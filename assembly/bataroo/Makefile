.PHONY: clean

ASSEMBLER = mads


TARGET = bin/bataroo

SOURCE = bataroo.asm

all: $(TARGET)

$(TARGET): $(SOURCE)
	mkdir -p bin
	$(ASSEMBLER) $(SOURCE) -o:$(TARGET) -l:bin/bataroo.lst  -p -t:bin/bataroo.lab -vu

clean:
	rm -f bin/*
	rm -rf tmp/*
	mkdir -p bin

run: $(TARGET)
	atari800 $(TARGET)

dist: $(TARGET)
	mkdir -p tmp
	rm -rf tmp/*
	cp bin/bataroo tmp/AUTO
	../dino/assets/dir2atr -S -B ../dino/assets/xbootdos.obx bin/bataroo.atr tmp
