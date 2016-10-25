NAME= ejemplo4

#linker: Linkea con el archivo .o y genera el ejecutable
$(NAME): $(NAME).o
	ld -m elf_i386 -o $(NAME) $(NAME).o

#Ensambla: pasa nemónicos a 1s y 0s 
$(NAME).o: $(NAME).asm
	nasm -f elf -g -F stabs $(NAME).asm -l $(NAME).lst

clean:
	rm $(NAME)
	rm $(NAME).lst
	rm $(NAME).o
