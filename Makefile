# The @ symbol removes the out put of the compilation prosess and makes
# the output alot cleaner
all:
	nasm -f elf64 -o client.o src/main.asm
	ld client.o -o client

debug:
	nasm -g -f elf64 -o client.o src/main.asm
	ld client.o -o client

socketaddr:
	gcc helper/socketaddr.c -o helper/socketaddr
	./helper/socketaddr

.PHONY: all debug helper
