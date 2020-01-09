CC = g++
CFLAGS = -Wall -c -g
EXEC_NAME = essai.out
INCLUDES =
LIBS =
INSTALL_DIR = bin
OBJ_FILES = bin/Document.o bin/Livre.o bin/Article.o bin/main.o bin/Biblio.o


all : $(EXEC_NAME)

$(INSTALL_DIR)/%.o : %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

$(EXEC_NAME) : $(OBJ_FILES)
	$(CC) -o $(EXEC_NAME) $(OBJ_FILES)

exec : 
		@./$(EXEC_NAME)

valgrind :
		valgrind ./$(EXEC_NAME)

clean:
		rm -rf bin/*.o
		rm $(EXEC_NAME)