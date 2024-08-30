#.PHONY all: main.o main.out clean

#main.o: $(wildcard *.asm)
#	nasm $? -f elf64 -o $@

#main.out: $(wildcard *.o)
#	gcc -o $@ main.o

#.PHONY clean: $(wildcard *.o, *.out)
#	rm -f *.o
#just in case ^

.PHONY all: client.o client  asmgui.o asmgui clean

asmgui.o:asmgui.s
	nasm $? -f elf64 -g -o $@
asmgui:asmgui.o
	ld -m elf_x86_64 asmgui.o -o $@

.PHONY clean:
	rm -f *.o
