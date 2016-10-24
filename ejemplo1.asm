sys_exit equ 1   ;~ Finaliza el programa
;sys_read equ 3   ;~ Lee y almacena de un archivo
sys_write equ 4  ;~ Escribe un archivo
;sys_open equ 5   ;~ Abre un archivo
;sys_close equ 6  ;~ Cierra un archivo
;sys_create equ 8 ;~ Crea un archivo
;stdin equ 0      ;~ Entrada estándar
stdout equ 1     ;~ Salida estándar

section .data
     msg: db "Hola Mundo del NASM y de Github!", 10 ; el diez significa cambio de linea en la hilera del registro
     len: equ $-msg 					; resta para obtener cantidad de bytes (largo del msg)

section .text
     global _start
_start:
     mov eax,sys_write		;eax contiene el servicio, 4 es write
     mov ebx,stdout			;donde voy a escribir
     mov ecx, msg			;puntero	
     mov edx, len			;edx tiene el largo del mensajea imprimir
     int 0x80
;Fin:
     mov eax, sys_exit
     xor ebx,ebx			;Pone en 0 para indicar que no hay error
     int 0x80
;-----------------------------------------------------------------------------------------
