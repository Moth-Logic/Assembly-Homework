SRC = sum_and_sub.asm
OBJ = sum_and_sub.o
BIN = sum_and_sub

all: $(BIN)

$(OBJ): $(SRC)
	nasm -f elf64 $(SRC) -o $(OBJ)

$(BIN): $(OBJ)
	ld $(OBJ) -o $(BIN)

clean:
	rm -f $(OBJ) $(BIN)
