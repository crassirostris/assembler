PROJECT_PATH=$(shell pwd)
PROGRAM_NAME=$(shell basename $(PROJECT_PATH))

NASM=nasm
NASMFLAGS=-f elf64

all: clean $(PROGRAM_NAME)

clean:
	rm -f $(PROGRAM_NAME) $(PROGRAM_NAME).o

$(PROGRAM_NAME): $(PROGRAM_NAME).o
	ld $(PROGRAM_NAME).o -o $(PROGRAM_NAME)

%.o: %.asm
	$(NASM) $(NASMFLAGS) -o $@ $<