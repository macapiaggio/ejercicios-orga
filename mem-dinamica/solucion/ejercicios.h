#ifndef LIB_H
#define LIB_H
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <stdint.h>

typedef struct s_list {
	uint8_t  size;				//1 byte 		offset: 0
	struct s_listElem* first;	//8 bytes		offest: 8
} list_t; //size: 16 bytes

typedef struct s_listElem {
	uint32_t data;				//4 bytes 		offset:0
	struct s_listElem* next;	//8 bytes		offset:8
} listElem_t; //size: 16 bytes

list_t* listNew();
uint8_t  listGetSize(list_t* l);
void  listAddFirst_asm(list_t* l, uint32_t data);
void  listAddFirst_c(list_t* l, uint32_t data);
void  listDelete(list_t* l);
#endif
