.PHONY: clean

ASSEMBLER = mads


TARGET = bin/dino

SOURCE = dino.asm

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(ASSEMBLER) $(SOURCE) -o:$(TARGET) 

clean:
	rm -f $(TARGET)
run:
	atari800 $(TARGET)