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

ARRAY_OFF_TYPE EQU 0
ARRAY_OFF_SIZE EQU 4
ARRAY_OFF_CAPACITY EQU 5
ARRAY_OFF_DATA EQU 8

LIST_OFF_TYPE EQU 0
LIST_OFF_SIZE EQU 4
LIST_OFF_FIRST EQU 8
LIST_OFF_DATA EQU 0
LIST_OFF_NEXT EQU 8
LIST_NODE_SIZE EQU 16

;########### DEFINICION DE FUNCIONES

; void arraySwap(array_t* a, uint8_t i, uint8_t j)
; Invierte el contenido del i-esimo elemento con el j-esimo elemento. Si alguno de los dos indices se
; encuentra fuera de rango, no realiza ninguna accion.
arraySwap_asm:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi                               ; puntero al array
    mov r13, rsi                               ; indice I
    mov r14, rdx                               ; indice J

    mov rdi, r12
    mov rsi, r13
    call arrayGet                              ; arrayGet(a, i);
    mov r15, rax
    cmp r15, 0
    jz .fin             ; asegurarse que el indice i era valido 

    mov rdi, r12
    mov rsi, r14
    call arrayGet                              ; arrayGet(a, j);
    cmp rax, 0
    jz .fin             ; asegurarse que el indice j era valido 

    ; En caso de que ambas posiciones sean validas, intercambia los elementos de posicion.
    .swap:      
            mov rcx, [r12 + ARRAY_OFF_DATA]
            shl r13, 3
            shl r14, 3

            mov [rcx + r13], rax
            mov [rcx + r14], r15

    .fin:
            pop r15
            pop r14
            pop r13
            pop r12
            pop rbp
            ret
            

; void listAddFirst(list_t* l, void* data)
;rdi <- l
;rsi <- data
listAddFirst_asm:
    push rbp
    mov rbp, rsp  ; pila alineada
    push r12      ; desalineada
    push r13      ; alineada
    push r14      ; desalineada
    sub rsp, 8    ; alineada

    mov r12, rdi ;r12: list_t* l (puntero a lista a la que agregamos=
    mov r13, rsi ;r13: void* data (dato a agregar)

    ;listElem_t* n = malloc(sizeof(listElem_t));
    mov rdi, LIST_NODE_SIZE
    call malloc wrt ..plt
    mov r14, rax ;r14: listElem_t* n

    ;funcClone_t* funcion_clonar = getCloneFunction(l->type);
    mov rdi, [r12 + LIST_OFF_TYPE]
    call getCloneFunction
    ;rax = funcion_clonar
    ;n->data = funcion_clonar(data);
    mov rdi, r13
    call rax
    mov [r14 + LIST_OFF_DATA], rax
    ;n->next = l->first;
    mov rdx, [r12 + LIST_OFF_FIRST]
    mov [r14 + LIST_OFF_NEXT], rdx

    ;l->size ++;
    inc byte [r12 + LIST_OFF_SIZE]
    ;l->first = n;
    mov [r12 + LIST_OFF_FIRST], r14

    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
	ret

listAddLast_asm:
    push rbp
    mov rbp, rsp  ; pila alineada
    push r12      ; desalineada
    push r13      ; alineada
    push r14      ; desalineada
    sub rsp, 8    ; alineada

    mov r12, rdi ;r12: list_t* l (puntero a lista a la que agregamos=
    mov r13, rsi ;r13: void* data (dato a agregar)

    ;listElem_t* n = malloc(sizeof(listElem_t));
    mov rdi, LIST_NODE_SIZE
    call malloc wrt ..plt
    mov r14, rax ;r14: listElem_t* n

    ;funcClone_t* funcion_clonar = getCloneFunction(l->type);
    mov rdi, [r12 + LIST_OFF_TYPE]
    call getCloneFunction
    ;rax = funcion_clonar
    ;n->data = funcion_clonar(data);
    mov rdi, r13
    call rax
    mov [r14 + LIST_OFF_DATA], rax
    ;n->next = NULL;
    mov qword [r14 + LIST_OFF_NEXT], 0

    ;l->size ++;
    inc byte [r12 + LIST_OFF_SIZE]
    ;if (l->first == NULL)
    cmp qword [r12 + LIST_OFF_FIRST], 0
    jne .listaNoVacia
    .listaVacia:
        ;l->first = n;
        mov [r12 + LIST_OFF_FIRST], r14

    .listaNoVacia:
        ;listElem_t* current = l->first;
        mov rdx, [r12 + LIST_OFF_FIRST]
        ;while (current->next != NULL)
        .irAlFinal:
            cmp qword [rdx + LIST_OFF_NEXT], 0
            je .agregarNodo
            mov rdx, [rdx + LIST_OFF_NEXT]
        ;    current = current->next;
        .agregarNodo:
        ;current->next = n;
        mov [rdx + LIST_OFF_NEXT], r14

    add rsp, 8
    pop r14
    pop r13
    pop r12
    pop rbp
	ret