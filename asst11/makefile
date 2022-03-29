# CS 218 Assignment #11
# Simple make file for asst #11

OBJS	= addlines.o a11procs.o
ASM		= yasm -g dwarf2 -f elf64
CC		= g++ -g -std=c++11 

all: addlines

addlines.o: addlines.cpp
	$(CC) -c addlines.cpp

a11procs.o: a11procs.asm 
	$(ASM) a11procs.asm -l a11procs.lst

addlines: $(OBJS)
	$(CC) -no-pie -o addlines $(OBJS)

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)
	rm  a11procs.lst