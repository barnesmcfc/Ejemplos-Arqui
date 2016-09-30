;Igual que el ejemplo 2 con la diferencia de que se hace la division con registro de 16-bit
;La entrada tambien cambia a 16-bit

stdout equ 1     			;Cada vez que salga stdout pone 1
sys_write equ 4  			;Cada vez que salga sys_write pone 4
sys_exit equ 1

section .bss				;Segmento que se pide a la memoria no inicializada
	resultado resb 7		;Campo para 7 ASCII, reserva 16 bytes. Se reserva eso ya que el numero mas grande seria 65535 y tiene 5 digitos

section .data				;Memoria inicialiada
	msj: db "El numero es: ";Declare Byte (13 bytes)
	len: equ $-msj			;$ se coloca en la siguiente posición 
	msj2: db ".", 0xA		
	len2: equ $-msj2
	numero: dw 0xDAB4		;Máximo 4 dígitos en hexadecimal. Word es espacio en memoria de 16-bits, el numero que quiera

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
	mov ax, word[numero]	;Movemos a ax el dividendo
	mov cx,10				;Divisor (Dividimos entre 10)
	mov ebx, resultado +6	;Donde voy a escribir el residuo (última posición)

;La instruccion DIV funciona DX:AX -> 32-bit.
;El conciente queda en registro ax y el residuo en DX
	
.division:					;ciclo acaba cuando ax=0
	xor dx, dx				;Reinicia el edx porque puede tener basura
	div cx					;divide [ax] / [cx] (numero/10)
	or dl, 30h				;Se hace or porque los primeros 4-bits de dl son siempre 0
	mov [ebx], byte dl		;pone el caracter en resultado
	dec ebx					;decrementar
	test ax,ax				;Resta eax-eax y actualiza las banderas
	jnz .division 			;Salta si la bandera Z está en 1

imprime_numero:
	mov edx, resultado+6	
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
