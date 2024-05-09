#include "lib.h"

int main (void){
    // Cambiar para elegir que implementación testear:
    int USE_C_IMPL = 0; 
    printf("=== Probando implementación de %s ===\n", USE_C_IMPL ? "C" : "ASM");
    void (*listAdd)(list_t *, uint32_t) = USE_C_IMPL ? listAddFirst_c : listAddFirst_asm;

    // Me armo un test para verificar el funcionamiento de la función
	list_t* l = listNew(); //Creamos la lista (devuelve una lista pedida con MALLOC)
    printf("Size before: %d\n",l->size);
    listAdd(l, 42);
    listAdd(l, 43);
    listAdd(l, 44);
    printf("Size after: %d\n",l->size);

    // Para debuggear, imprimo "el encabezado" de la lista y sus nodos
    printf("\nlist_t [\n");
    printf("    size: %d\n", l->size);
    printf("    first: %p\n", (void*)l->first);
    printf("]\n");
    
    printf("NODES: \n    idx: [ptr] data, next\n"); //Imprimo cada uno de los nodos. Entre corchetes la dirección en memoria del nodo.
    listElem_t* current = l->first;
    int count = 0;
    while(current != 0){
        printf("    %d: [%p] %d, %p\n", count, (void*)current, current->data, (void*)current->next);
        current = current->next;
        count++;
    }

    // Prueben comentar la siguiente linea
    listDelete(l); //Debemos usar free para liberar toda la memoria que fue pedida con malloc
    // compilar, y correr el siguiente comando para ver como valgrind reporta la pérdida de memoria
    //valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main
	return 0;    
}


