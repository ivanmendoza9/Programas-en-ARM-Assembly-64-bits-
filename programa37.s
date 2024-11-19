/*=========================================================
 * Programa:     pila.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de una pila simple usando
 *               memoria estática, con funciones para 
 *               inicializarla, apilar, desapilar y verificar
 *               si está vacía.
 * Compilación:  as -o pila.o pila.s
 *               gcc -o pila pila.o
 * Ejecución:    ./pila
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #define MAX_SIZE 100
 * int stack_array[MAX_SIZE];
 * int stack_count = 0;
 * 
 * void init_pila() {
 *     stack_count = 0;
 * }
 * 
 * int push(int value) {
 *     if (stack_count >= MAX_SIZE) return -1;
 *     stack_array[stack_count++] = value;
 *     return 0;
 * }
 * 
 * int pop() {
 *     if (stack_count == 0) return -1;
 *     return stack_array[--stack_count];
 * }
 * 
 * int is_empty() {
 *     return stack_count == 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    msg_menu: 
        .string "\nOperaciones de Pila\n"
        .string "1. Push (Insertar)\n"
        .string "2. Pop (Eliminar)\n"
        .string "3. Peek (Ver tope)\n"
        .string "4. Mostrar pila\n"
        .string "5. Salir\n"
        .string "Seleccione una opción: "
    
    msg_push: .string "Ingrese valor a insertar: "
    msg_pop: .string "Elemento eliminado: %d\n"
    msg_peek: .string "Elemento en el tope: %d\n"
    msg_empty: .string "La pila está vacía\n"
    msg_full: .string "La pila está llena\n"
    msg_stack: .string "Contenido de la pila: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Pila y variables
    stack: .skip 40       // Espacio para 10 elementos (4 bytes c/u)
    stack_size: .word 10  // Tamaño máximo de la pila
    top: .word -1         // Índice del tope de la pila
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
    b.eq push
    
    cmp w0, #2
    b.eq pop
    
    cmp w0, #3
    b.eq peek_elemento
    
    cmp w0, #4
    b.eq mostrar_pila
    
    b menu_loop

push:
    // Verificar si la pila está llena
    adr x20, top
    ldr w21, [x20]
    adr x22, stack_size
    ldr w22, [x22]
    sub w22, w22, #1
    
    cmp w21, w22
    b.ge pila_llena
    
    // Leer valor a insertar
    adr x0, msg_push
    bl printf
    adr x0, formato_int
    adr x1, valor
    bl scanf
    
    // Incrementar top y guardar valor
    adr x20, top
    ldr w21, [x20]
    add w21, w21, #1
    str w21, [x20]
    
    adr x20, stack
    adr x22, valor
    ldr w22, [x22]
    str w22, [x20, w21, SXTW #2]
    
    b menu_loop

pop:
    // Verificar si la pila está vacía
    adr x20, top
    ldr w21, [x20]
    cmp w21, #-1
    b.eq pila_vacia
    
    // Obtener elemento del tope
    adr x20, stack
    ldr w22, [x20, w21, SXTW #2]
    
    // Mostrar elemento eliminado
    adr x0, msg_pop
    mov w1, w22
    bl printf
    
    // Decrementar top
    adr x20, top
    ldr w21, [x20]
    sub w21, w21, #1
    str w21, [x20]
    
    b menu_loop

peek_elemento:
    // Verificar si la pila está vacía
    adr x20, top
    ldr w21, [x20]
    cmp w21, #-1
    b.eq pila_vacia
    
    // Mostrar elemento del tope
    adr x20, stack
    ldr w22, [x20, w21, SXTW #2]
    adr x0, msg_peek
    mov w1, w22
    bl printf
    
    b menu_loop

mostrar_pila:
    // Verificar si la pila está vacía
    adr x20, top
    ldr w21, [x20]
    cmp w21, #-1
    b.eq pila_vacia
    
    // Mostrar mensaje
    adr x0, msg_stack
    bl printf
    
    // Mostrar elementos desde el tope hasta la base
    mov w22, w21          // w22 será nuestro contador
    adr x20, stack
mostrar_loop:
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    sub w22, w22, #1
    cmp w22, #-1
    b.ge mostrar_loop
    
    adr x0, msg_newline
    bl printf
    b menu_loop

pila_vacia:
    adr x0, msg_empty
    bl printf
    b menu_loop

pila_llena:
    adr x0, msg_full
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
