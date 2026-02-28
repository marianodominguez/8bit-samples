.PHONY: clean

XASM = xasm

TARGET = bin/dino

SOURCE = dino.asm

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(XASM) $(SOURCE) /o:$(TARGET) 

clean:
	rm -f $(TARGET)
run:
	atari800 $(TARGET)