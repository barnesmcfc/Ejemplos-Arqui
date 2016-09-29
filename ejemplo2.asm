stdout equ 1     			;Cada vez que salga stdout pone 1
sys_write equ 4  			;Cada vez que salga sys_write pone 4
sys_exit equ 1

section .bss				;Segmento que se pide a la memoria no inicializada
	resultado resb 16		;Campo para 16 ASCII, reserva 16 bytes. Se reserva una cantidad considerable porque ah[i debe caber el n[umero al imprimirlo

section .data				;Memoria inicialiada
	msj: db "El numero es: ";Declare Byte (13 bytes)
	len: equ $-msj			;$ se coloca en la siguiente posición 
	msj2: db ".", 0xA		
	len2: equ $-msj2
	numero: dd 0b111111		;Máximo 8 dígitos en hexadecimal. Double es espacio en memoria de 32-bits, el numero que quiera

section .text				
	global _start			
_start:
	nop
	
imprime_mensaje:			
	mov ecx, msj			;ecx puntero a lo que se quiere imprimir
	mov edx, len			;Cantidad de caracteres a imprimir
	mov eax, sys_write		;Servicio 4 del SO, escribe en la salida		
	mov ebx, stdout			;Salida estandar
	int 80h					;Invoca el servicio que pide los datos correspondientes a cada registro

divisiones_sucesivas:		
	mov eax, dword[numero]	;Movemos a eax el dividendo
	mov ecx,10				;Divisor (Dividimos entre 10)
	mov ebx, resultado +15	;Donde voy a escribir el residuo (última posición)

;La instruccion DIV funciona EDX:EAX -> 64-bit.
;El conciente queda en registro eax y el residuo en EDX
	
.division:					;ciclo acaba cuando eax=0
	xor edx, edx			;Reinicia el edx porque puede tener basura
	div ecx					;divide [eax] / [ecx] (numero/10)
	or dl, 30h				;Se hace or porque los primeros 4-bits de dl son siempre 0
	mov [ebx], byte dl		;pone el caracter en resltado
	dec ebx					;decrementar
	test eax,eax			;Resta eax-eax y actualiza las banderas
	jnz .division 			;Salta si la bandera Z está en 1

imprime_numero:
	mov edx, resultado+15	
	sub edx, ebx			;Los resto para obtener el largo del mensaje por posiciones
	mov ecx,ebx				;Puntero a lo que voy a imprimir
	inc ecx					;Incrementa puntero
	mov eax, sys_write		;4
	mov ebx,stdout			;1
	int 80h
	
imprimir_punto:
	mov edx, len2			
	mov ecx, msj2
	mov eax,sys_write
	mov ebx, stdout
	int 80h

fin:						;Termina el programa
	mov eax, sys_exit
	xor ebx,ebx				;Pone en 0 para indicar que no hay error
	int 80h
