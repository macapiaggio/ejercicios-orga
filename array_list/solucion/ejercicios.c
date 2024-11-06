#include "ejercicios.h"
#include "list.h"

// ARRAY
void  arraySwap_c(array_t* a, uint8_t i, uint8_t j){
    void *aux_i = arrayGet(a, i);
    void *aux_j = arrayGet(a, j);

    a->data[i] = aux_j;
    a->data[j] = aux_i;
}


// LIST
funcClone_t* getCloneFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcClone_t*)&intClone; break;
        case TypeString:   return (funcClone_t*)&strClone; break;
        default: break;
    }
    return 0;
}

void listAddFirst_c(list_t* l, void* data){
    // Creo nodo y completo su información
    listElem_t* n = malloc(sizeof(listElem_t));
    funcClone_t* funcion_clonar = getCloneFunction(l->type);
    n->data = funcion_clonar(data);
    n->next = l->first;

    // Actualizo "metadata" de la lista
    l->size++;
    l->first = n;
}

void  listAddLast_c(list_t* l, void* data){
    // Creo nodo y completo su información
    listElem_t* n = malloc(sizeof(listElem_t));
    funcClone_t* funcion_clonar = getCloneFunction(l->type);
    n->data = funcion_clonar(data);
    n->next = NULL; //va a ser el último, así que no tiene next

    // Actualizo "metadata" de la lista
    l->size++;
    if (l->first == NULL)
        // Si no había nodos, basta con agregarlo como primero
        l->first = n;
    else {
        // Si había elementos en la lista, recorro la lista hasta
        // llegar a dodne tengo que agregar el nuevo nodo (al final).
        listElem_t* current = l->first;
        while (current->next != NULL)
            current = current->next;
        // Agrego nodo nuevo al final de la lista
        // (osea, como next del último nodo)
        current->next = n;
    }
}

/* listElem_t** whereToAdd = &(l->first);
    while(*whereToAdd != 0)
        whereToAdd = &((*whereToAdd)->next);

    listElem_t* n = malloc(sizeof(listElem_t));
    funcClone_t* funcion_clonar = getCloneFunction(l->type);
    n->data = funcion_clonar(data);
    n->next = NULL; //va a ser el último, así que no tiene next

    *whereToAdd = n;
    l->size++; */