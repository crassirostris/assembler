PROJECT_PATH=$(shell pwd)
PROGRAM_NAME=$(shell basename $(PROJECT_PATH))
OUTPUT_DIR=bin/
OUTPUT_FILE=bin/$(PROGRAM_NAME)

NASM=nasm
NASMFLAGS=-f elf64

all: clean $(OUTPUT_FILE)

clean:
	rm -f $(OUTPUT_FILE) $(OUTPUT_FILE).o

$(OUTPUT_FILE): $(OUTPUT_FILE).o
	if [[ ! -d bin ]]; then mkdir bin; fi
	ld $(OUTPUT_FILE).o -o $(OUTPUT_FILE)

$(OUTPUT_DIR)%.o: %.asm
	$(NASM) $(NASMFLAGS) -o $@ $<