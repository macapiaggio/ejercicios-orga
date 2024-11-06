;######### COMANDO GDB: set disassembly-flavor intel
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global arraySwap_asm
global listAddFirst_asm
global listAddLast_asm
extern malloc
extern getCloneFunction
extern arrayGet

LIST_OFF_TYPE EQU 0
LIST_OFF_SIZE EQU 4
LIST_OFF_FIRST EQU 8
LIST_OFF_DATA EQU 0
LIST_OFF_NEXT EQU 8
LIST_NODE_SIZE EQU 16

;########### DEFINICION DE FUNCIONES
; void listAddFirst(list_t* l, void* data)
; l [??]
; data [??]
; Agrega un nuevo nodo al principio de la lista, que almacene data.
; DEBE hacer una copia del dato.
listAddFirst_asm:
    ;COMPLETAR
	ret

; void listAddLast(list_t* l, void* data)
; l [rdi]
; data [rsi]
; Agrega un nuevo nodo al final de la lista, que almacene data.
; DEBE hacer una copia del dato.
listAddLast_asm:
    ;COMPLETAR
    push rbp
    mov rbp, rsp
    push r12
    push rbx
    push r13
    sub rsp, 8

    ; PEDIMOS NODO NUEVO Y LO COMPLETAMOS
    .crearNodo:
    mov r12, rdi ; lista l
    mov rbx, rsi ; data

    mov rdi, LIST_NODE_SIZE
    call malloc
    ;rax = nodo nuevo
    mov QWORD [rax + LIST_OFF_NEXT], 0
    
    mov r13, rax ;r13 = nodo nuevo
    mov rdi, [r12 + LIST_OFF_TYPE]
    call getCloneFunction
    ; rax = fun_clone
    mov rdi, rbx
    call rax
    ; rax = nuestra copia de data
    mov [r13 + LIST_OFF_DATA], rax

    .agregarALista:
    cmp byte [r12 + LIST_OFF_SIZE], 0
    jne .listaNoVacia

    .listaVacia:
        mov [r12 + LIST_OFF_FIRST], r13
        jmp .fin

    .listaNoVacia:
        mov r11, [r12 + LIST_OFF_FIRST] ;registro volatil porque no hago mas calls
        .while:
            ;cuerpo de mi ciclo
            cmp qword [r11 + LIST_OFF_NEXT], 0
            je .finWhile
            mov r11, [r11 + LIST_OFF_NEXT] ; aux = aux->next;
            jmp .while
        
        .finWhile:
            mov [r11 + LIST_OFF_NEXT], r13

    .fin:
    mov al, [r12 + LIST_OFF_SIZE]
    inc al
    mov [r12 + LIST_OFF_SIZE], al
    add rsp, 8
    pop r13
    pop rbx
    pop r12
    pop rbp
	ret

; void arraySwap(array_t* a, uint8_t i, uint8_t j)
; Invierte el contenido del i-esimo elemento con el j-esimo elemento. Si alguno de los dos indices se
; encuentra fuera de rango, no realiza ninguna accion.
arraySwap_asm:
    ;COMPLETAR
    ret            
