CC=c99
CFLAGS=-Wall -Wextra  -z noexecstack -pedantic -Wno-unused-variable -Wno-unused-parameter -Wfloat-conversion -O0 -ggdb -no-pie -lm
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF 

all: main

main: main.c list_c.o list_asm.o ejercicios_c.o ejercicios_asm.o
	$(CC) $(CFLAGS) $^ -o $@

list_c.o: list.c
	$(CC) $(CFLAGS) -c $< -o $@

list_asm.o: list.asm
	$(NASM) $(NASMFLAGS) $< -o $@

ejercicios_c.o: ejercicios.c
	$(CC) $(CFLAGS) -c $< -o $@

ejercicios_asm.o: ejercicios.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main
