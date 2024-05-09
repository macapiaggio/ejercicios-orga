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
; Además, en clase agregamos llamados a printf en cada ciclo para practicar llamar funciones de C desde ASM y uso de registros no volátiles.
; registros: a[RDI]
strLen:
    ;SIEMPRE está desalineada la pila al comienzo de la función (x convención de llamada, antes de hacer CALL strLen la pila estaba alineada, y CALL hizo PUSH RIP lo cual la desalinea)
    push rbp      ;pila queda alineada a 16 bytes
    mov rbp, rsp 
    push r12      ;desalineada
    push r13      ;alineada (importante porque vamos a hacer CALL)
    mov r12, rdi  ;r12 = char* a
    xor r13, r13  ;r13 = contador que indica el caracter actual/cuantos caracteres leímos

    .loop:
        mov rdi, r12 ; Cargamos parámetro de printf
        call printf wrt ..plt ;wrt ..plt es "magia" por si aparece error relacionado a -fPIE. Ver video de clase para explicación
        ; Revisamos si terminamos de recorrer la lista
        cmp byte [r12 + r13], 0        
            ; Alternativa: si tenemos un registro vacío, podemos hacer xor o cmp contra registro vacío
            ; xor rdx, rdx
            ; xor [rdi + r13], rdx ;En principio trabajar con registros es mas barato que trabajar con una constante en memoria (como es 0)
        ; Nos fijamos si terminamos de recorrer la string
        je .fin ;equivalente a jz .fin, tienen el mismo opcode
        ; Si aún no encontramos el 0 al final de la string seguimos recorriendo
        inc r13 ;equivalente a add r13, 1
        jmp .loop

    .fin:
    ; Guardo el resultado
    mov eax, r13d ;valor de retorno es de 32 bits
    ; Restauro los valores originales a los registros no volátiles + vacío la pila
    pop r13
    pop r12
    pop rbp
	ret ;RIP de la función llamadora debe estar en el tope de la pila
