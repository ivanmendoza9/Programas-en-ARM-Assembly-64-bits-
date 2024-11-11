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
    .align 3                    // Alineamiento a 8 bytes
    stack_array: .skip 800      // Espacio para 100 elementos de 8 bytes
    stack_count: .word 0        // Contador de elementos
    .equ MAX_SIZE, 100         // Constante para tamaño máximo

.text
.align 2
.global init_pila
.global push
.global pop
.global is_empty

// Función para inicializar la pila
init_pila:
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp
    
    adrp    x0, stack_count        // Cargar dirección de stack_count
    add     x0, x0, :lo12:stack_count
    str     wzr, [x0]              // Inicializar contador a 0
    
    ldp     x29, x30, [sp], 16
    ret

// Función para apilar (push)
push:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay espacio
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]               // Cargar contador actual
    cmp     w2, MAX_SIZE
    b.ge    push_overflow
    
    // Calcular dirección donde guardar
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    str     x0, [x3, x4]           // Guardar valor
    
    // Incrementar contador
    add     w2, w2, #1
    str     w2, [x1]
    
    mov     x0, #0                 // Retorno exitoso
    ldp     x29, x30, [sp], 16
    ret

push_overflow:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para desapilar (pop)
pop:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    // Verificar si hay elementos
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w2, [x1]
    cbz     w2, pop_empty
    
    // Calcular dirección del elemento a extraer
    sub     w2, w2, #1             // Decrementar contador
    str     w2, [x1]               // Guardar nuevo contador
    
    adrp    x3, stack_array
    add     x3, x3, :lo12:stack_array
    lsl     x4, x2, #3             // Multiplicar índice por 8
    ldr     x0, [x3, x4]           // Cargar valor
    
    ldp     x29, x30, [sp], 16
    ret

pop_empty:
    mov     x0, #-1                // Código de error
    ldp     x29, x30, [sp], 16
    ret

// Función para verificar si está vacía
is_empty:
    adrp    x1, stack_count
    add     x1, x1, :lo12:stack_count
    ldr     w0, [x1]
    cmp     w0, #0
    cset    w0, eq                 // Establecer 1 si está vacía, 0 si no
    ret
