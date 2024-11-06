#include "ejercicios.h"
#include "list.h"

// USE_C_IMPL dicta que implementación testear
void test_arraySwap(int USE_C_IMPL){
    printf("=== Probando implementación de %s ===\n", USE_C_IMPL ? "C" : "ASM");
    void (*arraySwap)(array_t *, uint8_t, uint8_t) = USE_C_IMPL ? arraySwap_c : arraySwap_asm;

    int capacity = 8;
    array_t* a = arrayNew(TypeInt, capacity);
    printf("Size before: %d\n",a->size);
    int data = 0;
    for (int i = 0; i < capacity; i++)
    {
        arrayAddLast(a, &data);
        data++; //Como arrayAddLast clona el elemento, puedo modificar el original y el de la lista no debería modificarse
    }
    printf("Size after: %d\n",a->size);

    // Para debuggear, imprimo "el encabezado" de la lista y sus nodos
    printf("\narray_t [\n");
    printf("    type: %d\n", a->type);
    printf("    size: %d\n", a->size);
    printf("    capacity: %d\n", a->capacity);
    printf("    data: %p\n", (void*)a->data);
    printf("]\n\n");

    printf("CONTENIDO DEL ARRAY: \n");
    arrayPrint(a, stdout);
    printf("\n");

    // SWAP
    arraySwap(a, 1, 6);

    printf("CONTENIDO DEL ARRAY LUEGO DE SWAP: \n");
    arrayPrint(a, stdout);
    printf("\n");

    // Prueben comentar la siguiente linea
    arrayDelete(a); //Debemos usar free para liberar toda la memoria que fue pedida con malloc
    // compilar, y correr el siguiente comando para ver como valgrind reporta la pérdida de memoria
    //valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main
}

// USE_C_IMPL dicta que implementación testear
void test_listAddFirst(int USE_C_IMPL){
    printf("=== Probando implementación de %s ===\n", USE_C_IMPL ? "C" : "ASM");
    void (*listAdd)(list_t *, void*) = USE_C_IMPL ? listAddFirst_c : listAddFirst_asm;

    // Me armo un test para verificar el funcionamiento de la función
    list_t* l = listNew(TypeInt); //Creamos la lista (devuelve una lista pedida con MALLOC)
    int data = 3;
    printf("Size before: %d\n",l->size);
    listAdd(l, &data);
    data--;
    listAdd(l, &data);
    data--;
    listAdd(l, &data);
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
        printf("    %d: [%p] %d, %p\n", count, (void*)current, *(int*)current->data, (void*)current->next);
        current = current->next;
        count++;
    }

    // Prueben comentar la siguiente linea
    listDelete(l); //Debemos usar free para liberar toda la memoria que fue pedida con malloc
    // compilar, y correr el siguiente comando para ver como valgrind reporta la pérdida de memoria
    //valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main
}

// USE_C_IMPL dicta que implementación testear
void test_listAddLast(int USE_C_IMPL){
    printf("=== Probando implementación de %s ===\n", USE_C_IMPL ? "C" : "ASM");
    void (*listAdd)(list_t *, void*) = USE_C_IMPL ? listAddLast_c : listAddLast_asm;

    // Me armo un test para verificar el funcionamiento de la función
    list_t* l = listNew(TypeInt); //Creamos la lista (devuelve una lista pedida con MALLOC)
    int data = 3;
    printf("Size before: %d\n",l->size);
    listAdd(l, &data);
    data--;
    listAdd(l, &data);
    data--;
    listAdd(l, &data);
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
        printf("    %d: [%p] %d, %p\n", count, (void*)current, *(int*)current->data, (void*)current->next);
        current = current->next;
        count++;
    }

    // Prueben comentar la siguiente linea
    listDelete(l); //Debemos usar free para liberar toda la memoria que fue pedida con malloc
    // compilar, y correr el siguiente comando para ver como valgrind reporta la pérdida de memoria
    //valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./main
}

int main (void){
    //1 = C implementation, 0 = ASM implementation
    int USE_C_IMPL = 0;

    //test_arraySwap(USE_C_IMPL);
    //test_listAddFirst(USE_C_IMPL);
    test_listAddLast(USE_C_IMPL);
    return 0;    
}
