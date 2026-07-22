.PHONY: clean

ASSEMBLER = mads


TARGET = bin/dino

SOURCE = dino.asm

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(ASSEMBLER) $(SOURCE) -o:$(TARGET) -l:bin/dino.lst  -p -t:bin/dino.lab -vu

clean:
	rm -f bin/*
	rm -rf tmp/*

run:
	atari800 $(TARGET)

demo:
	$(ASSEMBLER) music/Part15.asm -o:bin/demo
	atari800 bin/demo

dist: $(TARGET) 
	mkdir -p tmp
	rm -rf tmp/*
	cp bin/dino tmp/AUTO
	assets/dir2atr -S -B assets/xbootdos.obx bin/dino.atr tmp
