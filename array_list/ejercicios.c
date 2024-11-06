#include "ejercicios.h"
#include "list.h"

// LIST
funcClone_t* getCloneFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcClone_t*)&intClone; break;
        case TypeString:   return (funcClone_t*)&strClone; break;
        default: break;
    }
    return 0;
}

// Agrega un nuevo nodo al principio de la lista, que almacene data.
// DEBE hacer una copia del dato.
void listAddFirst_c(list_t* l, void* data){
    //COMPLETAR
}

// Agrega un nuevo nodo al final de la lista, que almacene data.
// DEBE hacer una copia del dato.
void  listAddLast_c(list_t* l, void* data){
    //Crear nodo a agregar
    listElem_t* nuevo = malloc(16);
    funcClone_t* fun_clone = getCloneFunction(l->type);
    nuevo->data = fun_clone(data);
    nuevo->next = 0;
    
    if(l->size == 0) {
        l->first = nuevo;
    } else {
        // listElem_t** aux = &(l->first);
        // while (*aux != NULL) {
        //     aux = &((*aux)->next);
        // }
        // *aux = nuevo;
        listElem_t* aux = l->first;
        while (aux->next != NULL)
            aux = aux->next;
        aux->next = nuevo;
    }

    l->size++;
}

// ARRAY
void  arraySwap_c(array_t* a, uint8_t i, uint8_t j){
    //COMPLETAR
}
