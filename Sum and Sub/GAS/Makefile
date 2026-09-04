SRC = sum_and_sub.s
OBJ = sum_and_sub.o
BIN = sum_and_sub

all: $(BIN)

$(OBJ): $(SRC)
	as -o $(OBJ) $(SRC)

$(BIN): $(OBJ)
	ld -o $(BIN) $(OBJ)

clean:
	rm -f $(OBJ) $(BIN)

.PHONY: all clean
