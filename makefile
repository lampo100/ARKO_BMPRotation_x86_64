CC = g++
BIT = 64
NFLAGS = -g -f elf$(BIT)
CFLAGS = -g -Wall -m$(BIT) -std=c++11
LIBS = -lsfml-graphics -lsfml-window -lsfml-system

all: clean build

build: main.o rotateUD.o rotateL.o rotateR.o
	$(CC) $(CFLAGS) rotateUD.o rotateL.o rotateR.o main.o -o rotate $(LIBS)

rotateUD.o: rotateUD.asm
	nasm $(NFLAGS) rotateUD.asm -o rotateUD.o

rotateL.o: rotateL.asm
	nasm $(NFLAGS) rotateL.asm -o rotateL.o

rotateR.o: rotateR.asm
	nasm $(NFLAGS) rotateR.asm -o rotateR.o

main.o: main.cpp
	$(CC) $(CFLAGS) -c main.cpp

clean:
	rm -f *.o
