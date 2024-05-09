;######### COMANDO GDB: set disassembly-flavor intel
;########### SECCION DE DATOS
section .data
;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global listAddFirst_asm
extern malloc
extern printf

; OFF_SIZE EQU ?? 
; OFF_FIRST EQU ??
; OFF_DATA EQU ??
; OFF_NEXT EQU ??
; NODE_SIZE EQU ??

;########### DEFINICION DE FUNCIONES
; void listAddFirst(list_t* l, uint32_t data)
; l [??]
; data [??]
listAddFirst_asm:
    ; COMPLETAR
	ret