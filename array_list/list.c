#include "list.h"

funcCmp_t* getCompareFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcCmp_t*)&intCmp; break;
        case TypeString:   return (funcCmp_t*)&strCmp; break;
        default: break;
    }
    return 0;
}
funcDelete_t* getDeleteFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcDelete_t*)&intDelete; break;
        case TypeString:   return (funcDelete_t*)&strDelete; break;
        default: break;
    }
    return 0;
}
funcPrint_t* getPrintFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcPrint_t*)&intPrint; break;
        case TypeString:   return (funcPrint_t*)&strPrint; break;
        default: break;
    }
    return 0;
}


/** Int **/

int32_t intCmp(int32_t* a, int32_t* b){
    // Compara los valores de a y b, y retorna: 0 si son iguales, 1 si a < b, −1 si b < a.
    if (*a < *b)
        return 1;
    else if (*a == *b)
        return 0;
    return -1;
}

void intDelete(int32_t* a){
    // Libera la memoria que contiene el dato pasado por parametro.
    free(a);
}

void intPrint(int32_t* a, FILE* pFile){
    // Imprime el valor entero en el stream indicado a traves de pFile.
    fprintf(pFile, "%d", *a);
}

int32_t* intClone(int32_t* a){
    // Solicita 4 bytes de memoria donde copiar el dato almacenado en a.
    int32_t* copia = malloc(sizeof(int32_t));
    *copia = *a;
    return copia;
}


/** Lista **/
list_t* listNew(type_t type){
    list_t* l = malloc(sizeof(list_t));
    l->type = type;
    l->first = 0;
    l->size = 0;
    return l;
}
uint8_t  listGetSize(list_t* l) {
    return l->size;
}

void listDelete(list_t* l){
    listElem_t* current = l->first;
    funcDelete_t* func_delete = getDeleteFunction(l->type);
    while(current!=0) {
        listElem_t* tmp = current;
        current = current->next;
        func_delete(tmp->data);
        free(tmp);
    }
    free(l);
}
