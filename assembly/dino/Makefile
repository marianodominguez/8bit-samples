.PHONY: clean

ASSEMBLER = mads


TARGET = bin/dino

SOURCE = dino.asm

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(ASSEMBLER) $(SOURCE) -o:$(TARGET) -l:bin/dino.lst  -p -t:bin/dino.lab -vu

clean:
	rm -f bin/*
run:
	atari800 $(TARGET)

demo:
	$(ASSEMBLER) music/Part15.asm -o:bin/demo
	atari800 bin/demo