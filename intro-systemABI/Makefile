CC=cc
CFLAGS= -std=c11 -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter 
NASM=nasm
NASMFLAGS=-f elf64 -g -F DWARF

all: main

OBJS := ejercicios.o

main: main.c $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

tester.o: tester.c checkpoints.h test-utils.h
	$(CC) $(CFLAGS) -c $< -o $@

ejercicios.o: ejercicios.asm
	$(NASM) $(NASMFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f main

