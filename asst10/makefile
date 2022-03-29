# CS 218 Assignment #10
# Simple make file for asst #10

OBJS	= circles.o a10procs.o
ASM		= yasm -g dwarf2 -f elf64
CC		= g++ -g -std=c++11 

all: circles

circles.o: circles.cpp
	$(CC) -c circles.cpp

a10procs.o: a10procs.asm 
	$(ASM) a10procs.asm -l a10procs.lst

circles: $(OBJS)
	$(CC) -no-pie -o circles $(OBJS) -lglut -lGLU -lGL -lm

# -----
# clean by removing object files.

clean:
	rm	$(OBJS)
	rm  a10procs.lst