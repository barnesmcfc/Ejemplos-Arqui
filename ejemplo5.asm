;Programa que verifica un archivo plano con un PIN de cuatro numeros,
;compara una entrada y dice si es igual al PIN o no

sys_exit equ 1   					;Finaliza el programa
sys_read equ 3   					;Lee y almacena de un archivo
sys_write equ 4						;Escribe 
sys_open equ 5
sys_nanosleep equ 162 				;Pausa
std_in equ 0      					;Entrada estándar (Teclado)
std_out equ 1     					;Salida estándar (Terminal)

section .bss
	buflen equ 10					;Memoria para lo que digite el usuario
	buffer resb buflen
	fileBuflen equ 5				;Memoria para lo que leeremos del archivo
	fileBuffer resb fileBuflen
	
section .data
	msg: db "Digite su PIN (4 números) y presione Enter",10
	len_msg: equ $-msg
	msgError1: db "ERROR: introdujo menos de 4 dígitos",10
	len_msgError1: equ $-msgError1
	msgError2: db "ERROR: introdujo más de 4 dígitos",10
	len_msgError2: equ $-msgError2
	msgError3: db "ERROR: no se puede leer archivo",10
	len_msgError3: equ $-msgError3
	msg_bien: db "PIN CORECTO!",10
	len_bien: equ $-msg_bien
	msg_mal: db "PIN incorrecto!",10
	len_mal: equ $-msg_mal
	nombre_archivo: db "archivo.txt",0	;0 es un valor Null que significa fin del archivo
	
section .text
	global _start
_start:
	nop

Abre_archivo:
	mov eax,sys_open
	mov ebx, nombre_archivo				;Dirección que lleva al archivo, puntero
	mov ecx, 0							;0 = Read only / 1 = Write / 2 = Read & Write
	int 80h								;EAX tiene el descriptor de archivo como salida en Open
	
	test eax,eax						;revisa banderas
	js error_archivo_pin				;salta si SF es 1
	
Lee_archivo:
	mov ebx, eax						;Movemos el descriptor de archivo
	mov ecx,fileBuffer					;Donde vamos a escribir lo leído
	mov edx,fileBuflen					;Largo
	mov eax,sys_read			
	int 80h
										;Indicamos que ingrese PIN
	mov ecx, msg						
	mov edx, len_msg
	call print
										;Leemos del tecleado y lo ponemos en 'buffer'
	mov ecx, buffer
	mov edx, buflen
	mov ebx,std_in
	mov eax,sys_read					
	int 80h
	
	dec eax								;quitamos el último caracter (enter)	
	cmp eax,4							;compara con 4 para revisar largo
	jb error_menos_digitos				;brinque si es menor que 4
	ja error_mas_digitos				;jump above, mayor que 4
	mov ecx, 0							;contador

ciclo:
	mov dl, byte[fileBuffer + ecx]		; comparamos el digito del archivo
	cmp dl, byte[buffer + ecx]			;con el que ingresa el usuario
	jne pin_incorrecto					;Si no son iguales está malo
	
	inc ecx								;memoria + ecx (contador)
	cmp ecx,4							;Si llega a 4 está correcto
	je pin_correcto						;jump equal
	jmp ciclo
										;Mensajes al usuario
pin_correcto:
	mov ecx, msg_bien
	mov edx, len_bien
	call print
	jmp Fin
	
pin_incorrecto:
	mov ecx, msg_mal
	mov edx, len_mal
	call print
	jmp Fin

error_menos_digitos:
	mov ecx, msgError1
	mov edx, len_msgError1
	call print
	jmp Fin
	
error_mas_digitos:
	mov ecx, msgError2
	mov edx, len_msgError2
	call print
	jmp Fin
	
error_archivo_pin:
	mov ecx, msgError3
	mov edx, len_msgError3
	call print
	jmp Fin
	
Fin:
	mov eax,sys_exit
	xor ebx,ebx
	int 80h
	
;--------------------------------------SUBRUTINAS-------------------------------------------------------------------------
print:	;Entrada: ECX: puntero a lo que se imprime / EDX: Largo
	mov eax,sys_write
	mov ebx,std_out
	int 80h	
	ret
