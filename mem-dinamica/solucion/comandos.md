# GDB
.gdbinit
```bash
set disassembly-flavor intel
set history save on
set debuginfod enabled off
set auto-load safe-path /
```
Comandos:
```bash
b alternate_sum_4
b strLen
```
# COMPILACIÓN
nasm -f elf64 -g -F DWARF ejercicios.asm -o ejercicios.o
gcc -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter -no-pie   -c -o lib.o lib.c
gcc -Wall -Wextra -pedantic -O0 -g -lm -Wno-unused-variable -Wno-unused-parameter main.c lib.o ejercicios.o -o main


# VALGRIND
valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main

