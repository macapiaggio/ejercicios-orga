;########### SECCION DE DATOS
section .data
;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global alternate_sum_4
global strLen

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]

;########################
; registros: x1[??], x2[??], x3[??], x4[??]
; lo primero que hago es armar el stackframe
alternate_sum_4:
    ;armo el stackframe
    ;preservo registros no volátiles

    ;cuerpo de la función

    ;restauro valores de registros no volátiles
	ret
;#######################

alternate_sum_4:
	;prologo
	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8
	push rbp	; alineado a 16
	mov rbp, rsp
	push rbx	; alineado a 8
	push r12	; alineado a 16
	push r13	; alineado a 8
	push r14	; alineado a 16
	push r15	; alineado a 8
	sub rsp, 8	; compensamos para alinear a 16 (padding)
    
    ;cuerpo de la funcion
	xor rax, rax	; limpiamos rax
	add eax, edi	; realizamos las sumas alternadas
	sub eax, esi
	add eax, edx
	sub eax, ecx
	
	;epilogo
	add rsp, 8	; deshacemos el padding
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	
	pop rbp
	ret


; uint32_t strLen(char* a)
strLen:
        xor ecx,ecx
        
    .loop:
        cmp byte [rdi + rcx], NULL
        jz .end
        inc ecx
        jmp .loop
    .end:
        mov eax, ecx
        ret
