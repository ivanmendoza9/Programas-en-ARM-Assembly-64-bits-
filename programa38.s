/*=========================================================
 * Programa:     cola.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de una cola circular simple usando
 *               memoria estática, con funciones para 
 *               inicializarla, encolar, desencolar, y verificar
 *               si está vacía o llena.
 * Compilación:  as -o cola.o cola.s
 *               gcc -o cola cola.o
 * Ejecución:    ./cola
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #define MAX_SIZE 100
 * int queue_array[MAX_SIZE];
 * int front = 0;
 * int rear = 0;
 * int count = 0;
 * 
 * void init_cola() {
 *     front = 0;
 *     rear = 0;
 *     count = 0;
 * }
 * 
 * int enqueue(int value) {
 *     if (count == MAX_SIZE) return -1;
 *     queue_array[rear] = value;
 *     rear = (rear + 1) % MAX_SIZE;
 *     count++;
 *     return 0;
 * }
 * 
 * int dequeue() {
 *     if (count == 0) return -1;
 *     int value = queue_array[front];
 *     front = (front + 1) % MAX_SIZE;
 *     count--;
 *     return value;
 * }
 * 
 * int is_empty() {
 *     return count == 0;
 * }
 * 
 * int is_full() {
 *     return count == MAX_SIZE;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    msg_menu: 
        .string "\nOperaciones de Cola\n"
        .string "1. Enqueue (Insertar)\n"
        .string "2. Dequeue (Eliminar)\n"
        .string "3. Peek (Ver frente)\n"
        .string "4. Mostrar cola\n"
        .string "5. Salir\n"
        .string "Seleccione una opción: "
    
    msg_enq: .string "Ingrese valor a insertar: "
    msg_deq: .string "Elemento eliminado: %d\n"
    msg_peek: .string "Elemento al frente: %d\n"
    msg_empty: .string "La cola está vacía\n"
    msg_full: .string "La cola está llena\n"
    msg_queue: .string "Contenido de la cola: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Cola y variables
    queue: .skip 40       // Espacio para 10 elementos (4 bytes c/u)
    queue_size: .word 10  // Tamaño máximo de la cola
    front: .word -1       // Índice del frente
    rear: .word -1        // Índice del final
    opcion: .word 0
    valor: .word 0

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

menu_loop:
    // Mostrar menú
    adr x0, msg_menu
    bl printf

    // Leer opción
    adr x0, formato_int
    adr x1, opcion
    bl scanf

    // Verificar opción
    adr x0, opcion
    ldr w0, [x0]
    
    cmp w0, #5
    b.eq fin_programa
    
    cmp w0, #1
    b.eq enqueue
    
    cmp w0, #2
    b.eq dequeue
    
    cmp w0, #3
    b.eq peek_elemento
    
    cmp w0, #4
    b.eq mostrar_cola
    
    b menu_loop

enqueue:
    // Verificar si la cola está llena
    adr x20, rear
    ldr w21, [x20]
    adr x22, queue_size
    ldr w22, [x22]
    sub w22, w22, #1
    
    cmp w21, w22
    b.ge cola_llena
    
    // Leer valor a insertar
    adr x0, msg_enq
    bl printf
    adr x0, formato_int
    adr x1, valor
    bl scanf
    
    // Si es el primer elemento
    adr x20, front
    ldr w23, [x20]
    cmp w23, #-1
    b.ne continuar_enq
    mov w23, #0
    str w23, [x20]
    
continuar_enq:
    // Incrementar rear y guardar valor
    adr x20, rear
    ldr w21, [x20]
    add w21, w21, #1
    str w21, [x20]
    
    adr x20, queue
    adr x22, valor
    ldr w22, [x22]
    str w22, [x20, w21, SXTW #2]
    
    b menu_loop

dequeue:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Obtener elemento del frente
    adr x20, queue
    ldr w22, [x20, w21, SXTW #2]
    
    // Mostrar elemento eliminado
    adr x0, msg_deq
    mov w1, w22
    bl printf
    
    // Actualizar índices
    adr x20, front
    adr x23, rear
    ldr w24, [x23]
    
    cmp w21, w24
    b.eq vaciar_cola
    
    add w21, w21, #1
    str w21, [x20]
    b menu_loop

vaciar_cola:
    mov w21, #-1
    adr x20, front
    str w21, [x20]
    adr x20, rear
    str w21, [x20]
    b menu_loop

peek_elemento:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Mostrar elemento del frente
    adr x20, queue
    ldr w22, [x20, w21, SXTW #2]
    adr x0, msg_peek
    mov w1, w22
    bl printf
    
    b menu_loop

mostrar_cola:
    // Verificar si la cola está vacía
    adr x20, front
    ldr w21, [x20]
    cmp w21, #-1
    b.eq cola_vacia
    
    // Mostrar mensaje
    adr x0, msg_queue
    bl printf
    
    // Mostrar elementos
    adr x20, queue
    adr x23, rear
    ldr w23, [x23]

mostrar_loop:
    ldr w1, [x20, w21, SXTW #2]
    adr x0, msg_num
    bl printf
    
    add w21, w21, #1
    cmp w21, w23
    b.le mostrar_loop
    
    adr x0, msg_newline
    bl printf
    b menu_loop

cola_vacia:
    adr x0, msg_empty
    bl printf
    b menu_loop

cola_llena:
    adr x0, msg_full
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
