# CS 218 Assignment #12
# Simple make file for asst #12

OBJS	= happyNums.o a12procs.o
ASM		= yasm -g dwarf2 -f elf64
CC		= gcc -g -std=c++11
LD		= gcc -g -pthread

all: happyNums

happyNums.o: happyNums.cpp
	$(CC) -c happyNums.cpp

a12procs.o: a12procs.asm
	$(ASM) a12procs.asm -l a12procs.lst

happyNums: happyNums.o a12procs.o
	$(LD) -no-pie -o happyNums $(OBJS) -lstdc++

# -----
# clean by removing object file.

clean:
	@rm	-f $(OBJS)
	@rm	-f a12procs.lst
