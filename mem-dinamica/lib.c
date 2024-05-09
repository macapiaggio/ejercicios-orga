#include "lib.h"

list_t* listNew(){
    list_t* l = malloc(sizeof(list_t));
    l->first = 0;
    l->size = 0;
    return l;
}

uint8_t  listGetSize(list_t* l) {
    return l->size;
}

void listDelete(list_t* l){
    listElem_t* current = l->first;
    while(current!=0) {
        listElem_t* tmp = current;
        current =  current->next;
        free(tmp);
    }
    free(l);
}

void listAddFirst_c(list_t* l, uint32_t data){
    // COMPLETAR
}
