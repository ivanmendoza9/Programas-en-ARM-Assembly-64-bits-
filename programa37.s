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

// #include <stdio.h>                 // Incluir librería estándar para I/O

// #define STACK_SIZE 50              // Definir el tamaño máximo de la pila

// long stack[STACK_SIZE];            // Declarar la pila como un arreglo de longs
// int stack_top = 0;                 // Inicializar el índice de la cima de la pila en 0

// const char* err_full = "Error: Pila llena\n";  // Mensaje de error para pila llena
// const char* err_empty = "Error: Pila vacia\n"; // Mensaje de error para pila vacía

// // Función para convertir un número a string
// void int_to_string(int num, char* buffer) {
//     int i = 19;                             // Comenzar desde el final del buffer
//     buffer[i] = '\0';                       // Añadir terminador nulo al final
//     do {
//         buffer[--i] = (num % 10) + '0';     // Obtener el dígito menos significativo
//         num /= 10;                          // Reducir el número
//     } while (num > 0);                      // Repetir hasta que el número sea 0
// }

// // Función para imprimir una cadena
// void print_string(const char* str) {
//     while (*str) {                          // Mientras no se llegue al final de la cadena
//         putchar(*str++);                    // Imprimir cada carácter
//     }
// }

// // Función para realizar push en la pila
// void push(long value) {
//     if (stack_top >= STACK_SIZE) {          // Comprobar si la pila está llena
//         print_string(err_full);             // Imprimir mensaje de error si está llena
//         return;                             // Salir de la función
//     }
//     char buffer[20];                        // Buffer para convertir número a string
//     print_string("Insertando valor en la pila: "); // Imprimir mensaje de inserción
//     int_to_string(value, buffer);           // Convertir valor a string
//     print_string(buffer);                   // Imprimir el valor convertido
//     putchar('\n');                          // Imprimir nueva línea
//     stack[stack_top++] = value;             // Insertar valor en la pila y actualizar la cima
// }

// // Función para realizar pop en la pila
// long pop() {
//     if (stack_top == 0) {                   // Comprobar si la pila está vacía
//         print_string(err_empty);            // Imprimir mensaje de error si está vacía
//         return -1;                          // Retornar un valor de error
//     }
//     long value = stack[--stack_top];        // Extraer valor de la cima de la pila
//     char buffer[20];                        // Buffer para convertir número a string
//     print_string("Extrayendo valor de la pila: "); // Imprimir mensaje de extracción
//     int_to_string(value, buffer);           // Convertir valor a string
//     print_string(buffer);                   // Imprimir el valor convertido
//     putchar('\n');                          // Imprimir nueva línea
//     return value;                           // Retornar el valor extraído
// }

// // Función principal
// int main() {
//     push(42);                               // Insertar el valor 42 en la pila
//     push(73);                               // Insertar el valor 73 en la pila
//     push(100);                              // Insertar el valor 100 en la pila
//     pop();                                  // Extraer el valor de la pila
//     pop();                                  // Extraer el valor de la pila
//     pop();                                  // Extraer el valor de la pila
//     pop();                                  // Intentar extraer de una pila vacía
//     return 0;                               // Terminar la función principal
// }

.data
    stack:      .skip 400        // Espacio para 50 elementos de 8 bytes
    stack_top:  .quad 0          // Índice del tope de la pila
    max_size:   .quad 50         // Tamaño máximo de la pila
    err_full:   .string "Error: Pila llena\n"
    err_empty:  .string "Error: Pila vacia\n"
    msg_push:   .string "Insertando valor en la pila: "
    msg_pop:    .string "Extrayendo valor de la pila: "
    newline:    .string "\n"
    buffer:     .skip 20         // Buffer para convertir números a string

.text
.global main

// Función para convertir un número a string
// X0 contiene el número a convertir
// X1 contiene la dirección del buffer
// Retorna en X0 la dirección del primer dígito
int_to_string:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    add x1, x1, #19            // Comenzar desde el final del buffer
    mov x2, #0                 // Terminador nulo
    strb w2, [x1]
    mov x2, #10               // Divisor
    
1:  sub x1, x1, #1            // Mover el puntero hacia atrás
    udiv x3, x0, x2           // Dividir por 10
    msub x4, x3, x2, x0       // Obtener el residuo
    add x4, x4, #'0'          // Convertir a ASCII
    strb w4, [x1]             // Almacenar el dígito
    mov x0, x3                // Preparar para la siguiente iteración
    cbnz x0, 1b              // Si el cociente no es 0, continuar
    
    mov x0, x1                // Retornar la dirección del primer dígito
    ldp x29, x30, [sp], #16
    ret

// Función para imprimir una cadena
print_string:
    stp x29, x30, [sp, #-16]!   // Preservar registros
    mov x0, #1                   // fd = 1 (stdout)
    mov x8, #64                 // syscall write
    svc #0
    ldp x29, x30, [sp], #16    // Restaurar registros
    ret

// Función push (corregida)
push:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Preservar x0
    str x0, [sp, #-16]!
    
    // Imprimir mensaje push
    adr x1, msg_push
    mov x2, #0
1:  ldrb w3, [x1, x2]        // Leer cada byte de msg_push
    cbz w3, 2f               // Termina al encontrar el terminador nulo
    add x2, x2, #1           // Incrementa el contador de longitud
    b 1b
2:  bl print_string           // Imprimir la cadena completa con la longitud calculada en x2
    
    // Convertir e imprimir número
    ldr x0, [sp]
    adr x1, buffer
    bl int_to_string
    mov x1, x0
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string
    
    // Nueva línea
    adr x1, newline
    mov x2, #1
    bl print_string
    
    // Recuperar x0 y hacer push
    ldr x0, [sp], #16
    
    adr x1, stack_top
    ldr x2, [x1]
    adr x3, max_size
    ldr x3, [x3]
    cmp x2, x3
    b.ge stack_full
    
    adr x3, stack
    str x0, [x3, x2, lsl #3]
    add x2, x2, #1
    str x2, [x1]
    
    ldp x29, x30, [sp], #16
    ret

// Función pop (corregida)
pop:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    adr x1, stack_top
    ldr x2, [x1]
    cmp x2, #0
    b.eq stack_empty
    
    sub x2, x2, #1
    str x2, [x1]
    adr x3, stack
    ldr x0, [x3, x2, lsl #3]
    
    // Preservar x0
    str x0, [sp, #-16]!
    
    // Imprimir mensaje pop
    adr x1, msg_pop
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string           // Imprimir el mensaje de pop con longitud calculada
    
    // Convertir e imprimir número
    ldr x0, [sp]
    adr x1, buffer
    bl int_to_string
    mov x1, x0
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string
    
    // Nueva línea
    adr x1, newline
    mov x2, #1
    bl print_string
    
    // Recuperar valor
    ldr x0, [sp], #16
    
    ldp x29, x30, [sp], #16
    ret

stack_full:
    adr x1, err_full
    mov x2, #17
    bl print_string
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret

stack_empty:
    adr x1, err_empty
    mov x2, #18
    bl print_string
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Pruebas
    mov x0, #42
    bl push
    
    mov x0, #73
    bl push
    
    mov x0, #100
    bl push
    
    bl pop
    bl pop
    bl pop
    bl pop    // Intentar pop en pila vacía
    
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
