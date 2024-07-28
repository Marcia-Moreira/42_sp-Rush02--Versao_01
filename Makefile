# VARIÁVEIS:

# Compilador
CC = gcc

# Nome do executável (no Terminal: make)
NAME = rush-02

# Flags de compilação
CFLAGS = -Wall -Wextra -Werror

# Arquivos objeto
OBJ = main.o ft_dictionary.o ft_number_conversion.o ft_utils.o ft_verify.o
DEBUG_OBJ = debug.o logger.o

# REGRAS:

# Regra padrão: compilar tudo
all: $(NAME)

# Regra para gerar o executável
$(NAME): $(OBJ)
	$(CC) $(CFLAGS) -o $(NAME) $(OBJ)

# Regras para criar arquivos objeto
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Limpar arquivos objeto
clean:
	rm -f $(OBJ) $(DEBUG_OBJ)
	rm -f debug
	rm -f rush-02

# Limpar arquivos objeto e executável
fclean: clean
	rm -f $(NAME) debug debug_log.txt

# Recompilar do zero
re: fclean all

# Verificar conformidade com Norminette
norm:
	norminette $(shell find . -name "*.c" -o -name "*.h")

# Regra para rodar o Valgrind (no Terminal: make memory )
memory: $(NAME)
	valgrind --leak-check=full ./$(NAME)

# Regras para testes (no Terminal: make test)
test: all
	@echo "Running Tests..."

	@echo "Argumento do Teste 1: ./rush-02 numbers.dict 42"
	@echo "Resultado Esperado: PASSED - O número '42' deve ser convertido corretamente utilizando o dicionário 'numbers.dict'."
	@./rush-02 numbers.dict 42 && echo " => Test 1\n" || echo " => Test 1\n"

	@echo "Argumento do Teste 2: ./rush-02 42"
	@echo "Resultado Esperado: PASSED - O número '42' deve ser convertido corretamente utilizando o dicionário padrão."
	@./rush-02 42 && echo " => Test 2\n" || echo " => Test 2\n"

	@echo "Argumento do Teste 3: ./rush-02 42 3"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois dois números foram passados como argumentos."
	@./rush-02 42 3 && echo " => Test 3\n" || echo " => Test 3\n"

	@echo "Argumento do Teste 4: ./rush-02 1"
	@echo "Resultado Esperado: PASSED - O número '1' deve ser convertido corretamente."
	@./rush-02 1 && echo " => Test 4\n" || echo " => Test 4\n"

	@echo "Argumento do Teste 5: ./rush-02 -2"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois o número é negativo."
	@./rush-02 -2 && echo " => Test 5\n" || echo " => Test 5\n"

	@echo "Argumento do Teste 6: ./rush-02 1 2 3"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois três números foram passados como argumentos."
	@./rush-02 1 2 3 && echo " => Test 6\n" || echo " => Test 6\n"

	@echo "Argumento do Teste 7: grep \"20\" numbers.dict | cat -e"
	@echo "Resultado Esperado: PASSED - A linha contendo o número '20' deve ser exibida."
	@grep "20" numbers.dict | cat -e && echo " => Test 7\n" || echo " => Test 7\n"

	@echo "Argumento do Teste 8: ./rush-02 100000"
	@echo "Resultado Esperado: PASSED - O número '100000' deve ser convertido corretamente."
	@./rush-02 100000 && echo " => Test 8\n" || echo " => Test 8\n"

	@echo "Argumento do Teste 9: ./rush-02 10.4"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois o número contém um ponto decimal."
	@./rush-02 10.4 && echo " => Test 9\n" || echo " => Test 9\n"

	@echo "Argumento do Teste 10: ./rush-02 0"
	@echo "Resultado Esperado: PASSED - O número '0' deve ser convertido corretamente."
	@./rush-02 0 && echo " => Test 10\n" || echo " => Test 10\n"

	@echo "Argumento do Teste 11: ./rush-02 42"
	@echo "Resultado Esperado: PASSED - O número '42' deve ser convertido corretamente utilizando o dicionário padrão."
	@./rush-02 42 && echo " => Test 11\n" || echo " => Test 11\n"

	@echo "Argumento do Teste 12: ./rush-02 42 12"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois dois números foram passados como argumentos."
	@./rush-02 42 12 && echo " => Test 12\n" || echo " => Test 12\n"

	@echo "Argumento do Teste 13: ./rush-02 42 12 21"
	@echo "Resultado Esperado: FAILED - O programa deve retornar um erro pois três números foram passados como argumentos."
	@./rush-02 42 12 21 && echo " => Test 13\n" || echo " => Test 13\n"

	@echo "Argumento do Teste 14: ./rush-02 9"
	@echo "Resultado Esperado: PASSED - O número '9' deve ser convertido corretamente."
	@./rush-02 9 && echo " => Test 14\n" || echo " => Test 14\n"

# Debug (no Terminal: make debug / Visualizar Log: cat debug_log.txt)
debug: CFLAGS += -DDEBUG

# Regras para compilar e rodar depuração
debug: $(DEBUG_OBJ) $(OBJ)
	$(CC) $(CFLAGS) -o debug $(DEBUG_OBJ) $(OBJ)

debug.o: debug.c
	$(CC) $(CFLAGS) -c debug.c -o debug.o

logger.o: logger.c
	$(CC) $(CFLAGS) -c logger.c -o logger.o

# Regras para executar o programa em modo de depuração e gerar o log
# (no Terminal: make run-debug)
run-debug: debug
	./debug numbers.dict 42 1> debug_log.txt 2>&1

# COMANDOS:
# Norminette => make norm
# Compilar Projeto rush-02 => make
# Executar testes => make test
# Limpar arquivos objeto => make clean
# Limpar tudo => make fclean
# Recompilar do zero => make re
# Compilar e executar modo de depuração => make debug
