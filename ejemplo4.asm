;Programa que recibe el nombre de usuario y lo muestra en pantalla
sys_exit equ 1   	;Finaliza el programa
sys_read equ 3   	;Lee y almacena de un archivo
sys_write equ 4		;Escribe 
sys_nanosleep equ 162 	;Pausa
stdin equ 0      	;Entrada estándar
stdout equ 1     	;Salida estándar


section .data
	msg: db "Cual es su nombre?",10				;mensaje a imprimir
	len: equ $-msg								;largo de mensaje
	msg2: db "Hola "
	len2 equ $-msg2
	tiempo: dd 2,0								;Segundos
	
section .bss
	lp_buffer resb 30						;30 cantidad de letras del nombre mas largo
	buf_len equ $-lp_buffer
	
section .text
	global _start
_start:
	nop

despliega_mensaje1:
	mov ecx, msg
	mov edx, len
	call Displaytext
	
lee_nombre:
	mov ecx, lp_buffer						;Donde queda el arreglo de bytes
	mov edx, buf_len						;Len
	mov ebx, 0								;La entrada 0 es el teclado
	mov eax, sys_read								;read
	int 80h
	push eax								;Read pone en EAX la cantidad de butes leídos al terminar

despliega_mensaje2:
	mov ecx, msg2
	mov edx, len2
	call print
	
wait_sec:									;Pausa antes de desplegar mensaje final
	mov ebx, tiempo							;Cantidad de segundos
	xor ecx,ecx 							;lo pone en 0
	mov eax, sys_nanosleep
	int 80h
	
muestra_nombre:
	mov ecx, lp_buffer						;Puntero
	pop edx									;Se había guardado el largo del nombre
	call print
Fin:
	mov eax,sys_exit
	xor ebx,ebx
	int 80h
;-------------------------------------------------------------------------------------------------------------------------
;--------------------------------------SUBRUTINAS-------------------------------------------------------------------------
read:	;Entrada: ECX: Puntero adonde quiero guardar el mensaje / EDX: Largo de memoria reservada
	mov eax, sys_read
	mov ebx, 0								;La entrada 0 es el teclado
	int 80h
	ret

print:	;Entrada: ECX: puntero a lo que se imprime / EDX: Largo
	mov eax,sys_write
	mov ebx,stdout
	int 80h	
	ret

pausa:	;Entrada puntero a la estructura en EVX
	xor ecx,ecx 			;lo pone en 0
	mov eax, sys_nanosleep
	int 80h
	ret
