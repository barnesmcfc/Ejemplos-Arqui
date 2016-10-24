;Programa que recibe el nombre de usuario y lo muestra en pantalla

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
	mov eax, 3									;read
	int 80h
	push eax								;Read pone en EAX la cantidad de butes leídos al terminar

despliega_mensaje2:
	mov ecx, msg2
	mov edx, len2
	call Displaytext
	
wait_sec:									;Pausa antes de desplegar mensaje final
	mov ebx, tiempo							;Cantidad de segundos
	xor ecx,ecx 							;lo pone en 0
	mov eax, 162
	int 80h
	
muestra_nombre:
	mov ecx, lp_buffer						;Puntero
	pop edx									;Se había guardado el largo del nombre
	call Displaytext
Fin:
	mov eax,1
	xor ebx,ebx
	int 80h

Displaytext:
	mov eax,4
	mov ebx,1
	int 80h		;se revisa lo que hay en eax
	ret
