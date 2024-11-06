global strClone
global strPrint
global strCmp
global strLen
global strDelete

global arrayNew
global arrayDelete
global arrayPrint
global arrayGetSize
global arrayAddLast
global arrayGet
global arrayRemove

%define SIZE_ARRAY 16
%define OFFSET_ARRAY_TYPE 0
%define OFFSET_ARRAY_SIZE 4
%define OFFSET_ARRAY_CAPACITY 5
%define OFFSET_ARRAY_DATA 8

%define TYPE_NONE 0
%define TYPE_INT 1
%define TYPE_STRING 2


section .data
null_str: db 'NULL',0          ; define el string NULL en memoria
corchete_abierto: db '[',0     ; define el string "[" en memoria
corchete_cerrado: db ']',0     ; define el string "]" en memoria
coma: db ',',0                 ; define el string "," en memoria
llave_abierta: db '{',0        ; define el string "{" en memoria
llave_cerrada: db '}',0        ; define el string "}" en memoria
guion: db '-',0                ; define el string "-" en memoria


section .text


extern malloc
extern free
extern fprintf
extern printf

extern getCompareFunction
extern getCloneFunction
extern getDeleteFunction
extern getPrintFunction

extern intCmp
extern intDelete
extern intPrint
extern intClone

extern listNew
extern listGetSize
extern listAddFirst
extern listAddLast
extern listDelete



; ** String **

; char* strClone(char* a)
; Genera una copia del string pasado por parametro. El puntero pasado siempre es valido aunque
; podria corresponderse a la string vacia.
strClone:
        push rbp
        mov rbp, rsp
        push r12
        sub rsp, 8
        
        call strLen
        mov r12, rdi
        inc rax
        mov rdi, rax
        call malloc

        mov rdi, rax
        mov rsi, r12
        call strCpy                                ; strCpy(char* clon, char* a)
        mov rax, rdi

        add rsp, 8
        pop r12
        pop rbp
        ret

; void strCpy(char* a, char* b)
; a destino - b origen
strCpy:
        push rbp
        mov rbp, rsp

        xor rcx, rcx
        .loop:
                mov dl, [rsi + rcx]
                mov [rdi + rcx], dl

                cmp dl, 0
                jz .fin

                inc rcx
                jmp .loop

        .fin:     
                pop rbp
                ret

; void strPrint(char* a, FILE* pFile)
; Escribe el string en el stream indicado a traves de pFile. Si el string es vacio debe escribir “NULL”.
strPrint:
        push rbp
        mov rbp, rsp

        call strLen
        cmp al, 0
        jz .str_vacio

        ; Ordena los argumenos al llamar fprintf
        .imprimir:
                mov rax, rsi
                mov rsi, rdi
                mov rdi, rax
                mov al, 0
                call fprintf                       ; fprintf(pFile, a);
                jmp .fin

        ; Si el string es vacio debe escribir “NULL”
        .str_vacio:
                mov rdi, null_str
                jmp .imprimir

        .fin:
                pop rbp
                ret

; int32_t strCmp(char* a, char* b)
; Compara dos strings en orden lexicografico. Debe retornar:
; 0 si son iguales
; 1 si a < b
; −1 si b < a
strCmp:
        push rbp
        mov rbp, rsp

        xor rcx, rcx                               ; contador
        jmp .loop

        .comp:                                     ; comparacion entre char a y char b
                inc rcx

                cmp al, dl
                jl .es_menor
                jg .es_mayor

        .loop:                                     ; loop hasta que alguno de los dos caracteres sea 0
                mov al, [rdi + rcx]                ; caracter a
                mov dl, [rsi + rcx]                ; caracter b

                cmp al, 0
                jnz .comp
                cmp dl, 0
                jnz .comp

                mov eax, 0                         ; a == b
                jmp .fin

        .es_mayor:                                  ; a > b
                mov eax, -1
                jmp .fin
        
        .es_menor:                                  ; a < b
                mov eax, 1
                jmp .fin

        .fin:
                pop rbp
                ret

; void strDelete(char* a)
; Borra el string pasado por parametro. Esta funcion es equivalente a la funcion free.
strDelete:
        push rbp
        mov rbp, rsp

        call free                                  ; free(a);

        pop rbp
        ret

; uint32_t strLen(char* a)
; Retorna la cantidad de caracteres distintos de cero del string pasado por parametro.
strLen:
        push rbp
        mov rbp, rsp

        xor rcx, rcx                               ; contador
        .loop:                                     ; strLen.loop
                mov al, [rdi + rcx]
                cmp al, 0
                jz .fin
                inc ecx
                jmp .loop

        .fin:                                      ; strLen.fin
                mov eax, ecx

        pop rbp
        ret



; ** Array **

; uint8_t arrayGetSize(array_t* a)
; Obtiene la cantidad de elementos ocupados del arreglo.
arrayGetSize:
        push rbp
        mov rbp, rsp

        mov al, [rdi + OFFSET_ARRAY_SIZE]          ; return a->size;

        pop rbp
        ret

; void arrayAddLast(array_t* a, void* data)
; Agrega un elemento al final del arreglo. Si el arreglo no tiene capacidad suficiente, entonces no hace
; nada. Esta funcion debe hacer una copia del dato.
arrayAddLast:
        push rbp
        mov rbp, rsp
        push r12
        push r13

        mov dl, [rdi + OFFSET_ARRAY_SIZE]
        mov cl, [rdi + OFFSET_ARRAY_CAPACITY]
        cmp dl, cl
        jz .fin                                    ; limite de capacidad

        mov r12, rdi
        mov r13, rsi
        mov edi, [r12 + OFFSET_ARRAY_TYPE]
        call getCloneFunction                      ; funcion clonar()

        mov rdi, r13
        call rax                                   ; clonar(data);

        xor rcx, rcx
        mov cl, [r12 + OFFSET_ARRAY_SIZE]
        mov rdx, [r12 + OFFSET_ARRAY_DATA]
        shl rcx, 3
        mov [rdx + rcx], rax                       ; a->data[a->size] = clon;

        xor rcx, rcx
        mov cl, [r12 + OFFSET_ARRAY_SIZE]
        inc cl
        mov [r12 + OFFSET_ARRAY_SIZE], cl          ; a->size++;

        .fin:
                pop r13
                pop r12
                pop rbp
                ret

; void* arrayGet(array_t* a, uint8_t i)
; Obtiene el i-esimo elemento del arreglo, si i se encuentra fuera de rango, retorna 0.
arrayGet:
        push rbp
        mov rbp, rsp

        mov dl, [rdi + OFFSET_ARRAY_SIZE]
        cmp sil, dl
        jl .obtener_dato
        mov rax, 0                                  ; i fuera de rango
        jmp .fin

        .obtener_dato:
                mov rdx, [rdi + OFFSET_ARRAY_DATA]
                shl rsi, 3
                mov rax, [rdx + rsi]               ; i valido -> devuelve el dato

        .fin:
                pop rbp
                ret

; array_t* arrayNew(type_t t, uint8_t capacity)
; Crea un array nuevo con elementos de tipo t y capacidad indicada por capacity.
arrayNew:
        push rbp
        mov rbp, rsp
        push r12
        push r13

        mov r12, rdi
        movzx r13, sil
        mov rdi, SIZE_ARRAY                        ; se reserva memoria para la estructura
        call malloc

        mov [rax + OFFSET_ARRAY_TYPE], r12         ; se transcribe el type
        xor rcx, rcx
        mov [rax + OFFSET_ARRAY_SIZE], cl          ; se inicializa el size en 0
        mov [rax + OFFSET_ARRAY_CAPACITY], r13     ; se transcribe la capacidad
        mov r12, rax
        
        shl r13, 3
        mov rdi, r13
        call malloc
        mov [r12 + OFFSET_ARRAY_DATA], rax         ; se inicializa el vector dinamico de capacidad limitada

        mov rax, r12

        pop r13
        pop r12
        pop rbp
        ret

; void* arrayRemove(array_t* a, uint8_t i)
; Quita el i-esimo elemento del arreglo, si i se encuentra fuera de rango, retorna 0. El arreglo es
; reacomodado de forma que ese elemento indicado sea quitado y retornado.
arrayRemove:
        push rbp
        mov rbp, rsp
        push r12
        push r13
        push r14
        sub rsp, 8

        mov r12, rdi                               ; puntero al array
        mov r13, rsi                               ; indice
        xor r14, r14                               ; contador

        mov dl, [rdi + OFFSET_ARRAY_SIZE]
        cmp sil, dl
        jl .loop
        mov rax, 0                                 ; i fuera de rango
        jmp .fin

        ; En caso de que la posicion sea valida, se realizan los swaps necesarios para llevar el elemento
        ; en la posicion dada al final del array, para luego disminuir el tamanio del array y asi restringir
        ; el acceso a ese elemento, que en caso de insertar un nuevo elemento lo va a sobreescribir.
        .loop:
                mov cl, [r12 + OFFSET_ARRAY_SIZE]
                dec cl
                cmp cl, r14b
                jz .remove

                mov rdi, r12
                mov r8, r13
                add r8, r14
                mov rsi, r8
                mov r9, r13
                add r9, r14
                inc r9
                mov rdx, r9
                call arraySwap                     ; arraySwap(a, i + contador, i + 1 + contador);

                inc r14                            ; contador++;
                jmp .loop

        .remove:
                mov rcx, [r12 + OFFSET_ARRAY_DATA]
                shl r14, 3
                mov rax, [rcx + r14]               ; return a->data[a->size - 1];

                mov cl, [r12 + OFFSET_ARRAY_SIZE]
                dec cl
                mov [r12 + OFFSET_ARRAY_SIZE], cl  ; a->size--;

        .fin:
                add rsp, 8
                pop r14
                pop r13
                pop r12
                pop rbp
                ret

; void arraySwap(array_t* a, uint8_t i, uint8_t j)
; Invierte el contenido del i-esimo elemento con el j-esimo elemento. Si alguno de los dos indices se
; encuentra fuera de rango, no realiza ninguna accion.
arraySwap:
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
        jz .fin

        mov rdi, r12
        mov rsi, r14
        call arrayGet                              ; arrayGet(a, j);
        cmp rax, 0
        jz .fin

        ; En caso de que ambas posiciones sean validas, intercambia los elementos de posicion.
        .swap:      
                mov rcx, [r12 + OFFSET_ARRAY_DATA]
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

; void arrayDelete(array_t* a)
; Borra el arreglo, para esto borra todos los datos que el arreglo contenga, junto con las estructuras
; propias del tipo arreglo.
arrayDelete:
        push rbp
        mov rbp, rsp
        push r12
        push r13
        push r14
        sub rsp, 8

        mov r12, rdi
        mov edi, [r12 + OFFSET_ARRAY_TYPE]
        call getDeleteFunction
        mov r13, rax                           ; funcion delete()

        xor r14, r14                           ; contador
        .loop:
                mov dl, [r12 + OFFSET_ARRAY_SIZE]
                cmp dl, r14b
                jz .fin

                mov rdx, [r12 + OFFSET_ARRAY_DATA]
                mov r8, r14
                shl r8, 3
                mov rdi, [rdx + r8]
                call r13                       ; libera el elemento guardado
                inc r14b
                jmp .loop

        .fin:
                mov rdi, [r12 + OFFSET_ARRAY_DATA]
                call free                      ; libera el vector dinamico

                mov rdi, r12
                call free                      ; libera el array

        add rsp, 8
        pop r14
        pop r13
        pop r12
        pop rbp
        ret

; void arrayPrint(array_t* a, FILE* pFile)
; Escribe en el stream indicado por pFile el arreglo almacenada en a. Para cada dato llama a la funcion
; de impresion del dato correspondiente. El formato del arreglo sera: [x0,...,xn−1], suponiendo
; que xi es el resultado de escribir el i-esimo elemento.
arrayPrint:
        push rbp
        mov rbp, rsp
        push r12
        push r13
        push r14
        push r15

        mov r12, rdi                                ; puntero al array
        mov r13, rsi                                ; stream (archivo)
        mov edi, [r12 + OFFSET_ARRAY_TYPE]
        call getPrintFunction
        mov r14, rax                                ; funcion print()

        mov rdi, r13
        mov rsi, corchete_abierto
        mov al, 0
        call fprintf                                ; imprime "["

        xor r15, r15                                ; contador
        .loop:
                mov dl, [r12 + OFFSET_ARRAY_SIZE]
                cmp dl, r15b
                jz .fin

                mov rdx, [r12 + OFFSET_ARRAY_DATA]
                mov r8, r15
                shl r8, 3
                mov rdi, [rdx + r8]
                mov rsi, r13
                mov al, 0
                call r14                            ; imprime el dato

                mov dl, [r12 + OFFSET_ARRAY_SIZE]
                dec dl
                cmp dl, r15b
                jnz .imprimir_coma

                inc r15b
                jmp .loop

        .imprimir_coma:
                mov rdi, r13
                mov rsi, coma
                mov al, 0
                call fprintf                       ; imprime ","

                inc r15b
                jmp .loop

        .fin:
                mov rdi, r13
                mov rsi, corchete_cerrado
                mov al, 0
                call fprintf                       ; imprime "]"

        pop r15
        pop r14
        pop r13
        pop r12
        pop rbp
        ret