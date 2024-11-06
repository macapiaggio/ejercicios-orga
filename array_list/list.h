#ifndef _LIB_HH_
#define _LIB_HH_

#include "ejercicios.h"

typedef int32_t (funcCmp_t)(void*, void*);
typedef void* (funcClone_t)(void*);
typedef void (funcDelete_t)(void*);
typedef void (funcPrint_t)(void*, FILE* pFile);
typedef void* (funcGet_t)(void*, uint8_t);
typedef void (funcSwap_t)(void*, uint8_t, uint8_t);
typedef void* (funcRemove_t)(void*, uint8_t);
typedef void (funcAddLast_t)(void*, void*);
typedef uint8_t (funcSize_t)(void*);

/** Int **/

int32_t intCmp(int32_t* a, int32_t* b);
int32_t* intClone(int32_t* a);
void intDelete(int32_t* a);
void intPrint(int32_t* a, FILE* pFile);

/* String */

int32_t strCmp(char* a, char* b);
char* strClone(char* a);
void strDelete(char* a);
void strPrint(char* a, FILE* pFile);
uint32_t strLen(char* a);

/** Array **/
array_t* arrayNew(type_t t, uint8_t capacity);
uint8_t  arrayGetSize(array_t* a);
void  arrayAddLast(array_t* a, void* data);
void* arrayGet(array_t* a, uint8_t i);
void* arrayRemove(array_t* a, uint8_t i);
void  arrayDelete(array_t* a);
void  arrayPrint(array_t* a, FILE* pFile);

/* List */

list_t* listNew(type_t t);
uint8_t  listGetSize(list_t* l);
void  listDelete(list_t* l);
#endif
