section .bss
	resultado resb 16

section .data
	msg: db "El numero es:"
	len equ $-msg
	msg2: db ".", 0xA
	len2: equ $-msg2
	numero: dd 0xCAFE

section .text
	global _start
_start:
	mov ecx, msg			;ecx puntero
	mov edx, len
	call Displaytext
	jmp divisiones_sucesivas

Displaytext:
	mov eax,4
	mov ebx,1
	int 80h					;se revisa lo que hay en eax
	ret

divisiones_sucesivas:
	xor edx, edx			;Reinicia el edx en 0
	mov eax, dword[numero]	;solo que el número indica puntero
	mov ecx,10				;Base en la que vemos el numero
	mov ebx, resultado +15	
	
.division:					;ciclo acaba cuando eax=0
	xor edx, edx			;pone edx en 0
	div ecx					;divide [eax] / [ecx] (numero/10)
	or dl, 30h				
	mov [ebx], byte dl		
	dec ebx					;decrementar
	test eax, eax			;Revisa estado de banderas
	jnz .division
	nop
	
imprime_numero:
	mov edx, resultado +15 	;edx : largo
	sub edx,ebx				; substrae ebx-edx
	mov ecx, ebx			
	inc ecx					;puntero a "El mensaje"
	call Displaytext

imprime_punto:
	mov ecx, msg2
	mov edx, len2
	call Displaytext
Fin:
	mov eax,1
	xor edx,edx
	int 80h
