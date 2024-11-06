#ifndef EJERCICIOS_H
#define EJERCICIOS_H
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdarg.h>

typedef enum e_type {
	TypeNone = 0,
	TypeInt = 1,
	TypeString = 2,
	TypeCard = 3
} type_t;

// LISTAS
typedef struct s_list {
    type_t   type;              //4 bytes 		offset:0 
	uint8_t  size;				//1 bytes 		offset:4 
	struct s_listElem* first;	//8 bytes		offset:8 
} list_t; //size: 16 bytes

typedef struct s_listElem {
	void* data;				    //8 bytes 		offset:0
	struct s_listElem* next;	//8 bytes	    offset:8
} listElem_t; //size: 16 bytes

// Agrega un nuevo nodo al principio de la lista, que almacene data.
// DEBE hacer una copia del dato.
void  listAddFirst_asm(list_t* l, void* data);
void  listAddFirst_c(list_t* l, void* data);

// Agrega un nuevo nodo al final de la lista, que almacene data.
// DEBE hacer una copia del dato.
void  listAddLast_asm(list_t* l, void* data);
void  listAddLast_c(list_t* l, void* data);

// ARRAY
typedef struct s_array {
	type_t  type;				//?? bytes 		offset: ??
	uint8_t size;				//?? bytes 		offset: ??
	uint8_t capacity;			//?? bytes 		offset: ??
	void** data;				//?? bytes 		offset: ??
} array_t; // size: ?? bytes

// Invierte el contenido del i-ésimo elemento con el j-ésimo elemento.
// Si alguno de los dos índices se encuentra fuera de rango, no realiza ninguna acción.
void  arraySwap_asm(array_t* a, uint8_t i, uint8_t j);
void  arraySwap_c(array_t* a, uint8_t i, uint8_t j);

#endif
