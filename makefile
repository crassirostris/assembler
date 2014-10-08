SOURCE=1.asm
OUTPUT=program

all: clean program

clean:
	rm -f $(OUTPUT) $(OUTPUT).o

program:
	nasm -f elf64 -o $(OUTPUT).o $(SOURCE)
	ld $(OUTPUT).o -o $(OUTPUT)