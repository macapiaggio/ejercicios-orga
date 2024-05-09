;######### COMANDO GDB: set disassembly-flavor intel
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global listAddFirst_asm
extern malloc

OFF_SIZE EQU 0
OFF_FIRST EQU 8
OFF_DATA EQU 0
OFF_NEXT EQU 8
NODE_SIZE EQU 16

;########### DEFINICION DE FUNCIONES
; void listAddFirst(list_t* l, uint32_t data)
;rdi <- l
;rsi <- data
listAddFirst_asm:
    ; listElem_t* n = malloc(sizeof(listElem_t));
    ; l->size = l->size + 1;
    ; n->data = data;
    ; n->next = l->first;
    ; l->first = n;
    push rbp
    mov rbp, rsp  ; pila alineada
    push r12      ; desalineada
    push r13      ; alineada

    mov r12, rdi  ;puntero a lista a la que agregamos
    mov r13d, esi ;dato a agregar

    ;listElem_t* n = malloc(sizeof(listElem_t));
    mov rdi, NODE_SIZE
    call malloc wrt ..plt

    ;l->size = l->size + 1;
    inc byte [r12 + OFF_SIZE]
    ;n->data = data;
    mov [rax + OFF_DATA], r13d

    ;n->next = l->first;
    mov rdx, [r12 + OFF_FIRST]
    mov [rax + OFF_NEXT], rdx

    ;l->first = n;
    mov [r12 + OFF_FIRST], rax

    pop r13
    pop r12
    pop rbp
	ret