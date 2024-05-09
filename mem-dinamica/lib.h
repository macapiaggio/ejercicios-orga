#ifndef EJERCICIOS_H
#define EJERCICIOS_H
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>

typedef struct s_list {
	uint8_t  size;				//?? bytes 		offset: ??
	struct s_listElem* first;	//?? bytes		offest: ??
} list_t; //size: ?? bytes

typedef struct s_listElem {
	uint32_t data;				//?? bytes 		offset:??
	struct s_listElem* next;	//?? bytes		offset:??
} listElem_t; //size: ?? bytes

list_t* listNew();
uint8_t  listGetSize(list_t* l);
void  listAddFirst_asm(list_t* l, uint32_t data);
void  listAddFirst_c(list_t* l, uint32_t data);
void  listDelete(list_t* l);
#endif
