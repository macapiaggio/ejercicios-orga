;######### COMANDO GDB: set disassembly-flavor intel
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global alternate_sum_4
global strLen
extern printf

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4)
; Devuelve el resultado de x1 - x2 + x3 - x4
; registros: x1[EDI], x2[ESI], x3[EDX], x4[ECX]
alternate_sum_4:
; armamos stackframe
    push rbp
    mov rbp, rsp

    sub edi, esi
    lea rax, [rdi+rdi*4]
    add edi, edx
    sub edi, ecx
    mov eax, edi

    .fin:
; restauramos valores
    pop rbp
	ret


; uint32_t strLen(char* a)
; Retorna la cantidad de caracteres distintos de cero del string pasado por parámetro. 
; registros: a[??]
strLen:
    ;SIEMPRE está desalineada la pila al comienzo de la función (x convención de llamada)
    push rbp ;pila queda alineada a 16 bytes
    mov rbp, rsp 
    push r12
    push r13
    mov r12, rdi ;guardo char* a

    ; rdi = char* a
    xor r13, r13 ;r13 = contador que indica el caracter actual/cuantos caracteres leimos

    ;xor rdx, rdx
    .loop:
        ; if current_char == 0
        mov rdi, r12
        call printf wrt ..plt
        
        cmp byte [r12 + r13], 0        
        ;xor [rdi + r13], rdx
        je .fin ;mismo opcode que jz
        inc r13
        jmp .loop

    .fin:
    ; rax=8, eax=4, ax=2, al,ah=1
    mov eax, r13d
    
    pop r13
    pop r12
    pop rbp
	ret
