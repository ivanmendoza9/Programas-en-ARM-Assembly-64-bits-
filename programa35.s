/*=========================================================
 * Programa:     rotacion.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Rota los elementos de un arreglo a la izquierda
 *               o a la derecha. Los parámetros de entrada son:
 *               x0 = puntero al arreglo, x1 = tamaño del arreglo
 *               x2 = número de posiciones a rotar, x3 = dirección
 *               (0 = izquierda, 1 = derecha).
 * Compilación:  as -o rotacion.o rotacion.s
 *               gcc -o rotacion rotacion.o
 * Ejecución:    ./rotacion
 =========================================================*/

// #include <stdio.h>               // Incluir la biblioteca estándar de E/S

// #define ARRAY_SIZE 5             // Definir el tamaño del arreglo
// #define POSITIONS 2              // Número de posiciones para rotar

// // Arreglo original
// long array[ARRAY_SIZE] = {1, 2, 3, 4, 5};  // Inicializar el arreglo

// // Función para mostrar el arreglo
// void mostrar_arreglo(const char* mensaje) {
//     printf("%s", mensaje);         // Imprimir el mensaje de encabezado
//     for (int i = 0; i < ARRAY_SIZE; i++) {  // Recorrer el arreglo
//         printf("%ld ", array[i]);  // Imprimir cada elemento
//     }
//     printf("\n");                  // Imprimir nueva línea al final
// }

// // Función para rotar el arreglo a la izquierda
// void rotar_izquierda() {
//     for (int r = 0; r < POSITIONS; r++) {  // Número de rotaciones
//         long temp = array[0];             // Guardar el primer elemento
//         for (int i = 0; i < ARRAY_SIZE - 1; i++) {  // Mover elementos a la izquierda
//             array[i] = array[i + 1];
//         }
//         array[ARRAY_SIZE - 1] = temp;     // Colocar el primer elemento al final
//     }
// }

// // Función para rotar el arreglo a la derecha
// void rotar_derecha() {
//     for (int r = 0; r < POSITIONS; r++) {  // Número de rotaciones
//         long temp = array[ARRAY_SIZE - 1]; // Guardar el último elemento
//         for (int i = ARRAY_SIZE - 1; i > 0; i--) { // Mover elementos a la derecha
//             array[i] = array[i - 1];
//         }
//         array[0] = temp;                  // Colocar el último elemento al inicio
//     }
// }

// // Función para restaurar el arreglo original
// void restaurar_original() {
//     for (int i = 0; i < ARRAY_SIZE; i++) { // Restaurar valores originales
//         array[i] = i + 1;
//     }
// }

// // Función principal
// int main() {
//     mostrar_arreglo("Arreglo original: ");    // Mostrar el arreglo original
    
//     rotar_izquierda();                        // Rotar a la izquierda
//     mostrar_arreglo("Rotación izquierda: ");  // Mostrar el resultado de la rotación a la izquierda
    
//     restaurar_original();                     // Restaurar el arreglo original
//     rotar_derecha();                          // Rotar a la derecha
//     mostrar_arreglo("Rotación derecha: ");    // Mostrar el resultado de la rotación a la derecha
    
//     return 0;                                 // Finalizar el programa
// }


.global main

.section .data
msg1:    .ascii "Arreglo original: "
len1 = . - msg1
msg2:    .ascii "\nRotacion izquierda: "
len2 = . - msg2
msg3:    .ascii "\nRotacion derecha: "
len3 = . - msg3
array:   .quad 1, 2, 3, 4, 5    // Arreglo original
size:    .quad 5                // Tamaño del arreglo
pos:     .quad 2                // Posiciones a rotar
buffer:  .skip 32               // Buffer para conversión
space:   .ascii " "
newline: .ascii "\n"

.section .text
main:
    stp x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov x29, sp                 // Actualizar frame pointer

    // Mostrar arreglo original
    mov x0, #1
    ldr x1, =msg1
    mov x2, len1
    mov x8, #64
    svc #0

    bl mostrar_arreglo

    // Rotar izquierda
    bl rotar_izquierda
    
    // Mostrar resultado rotación izquierda
    mov x0, #1
    ldr x1, =msg2
    mov x2, len2
    mov x8, #64
    svc #0

    bl mostrar_arreglo

    // Restaurar arreglo original
    bl restaurar_original
    
    // Rotar derecha
    bl rotar_derecha
    
    // Mostrar resultado rotación derecha
    mov x0, #1
    ldr x1, =msg3
    mov x2, len3
    mov x8, #64
    svc #0

    bl mostrar_arreglo

    // Nueva línea final
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    // Restaurar frame pointer y link register
    ldp x29, x30, [sp], 16
    
    // Retornar 0
    mov x0, #0
    ret

rotar_izquierda:
    str x30, [sp, #-16]!        // Guardar enlace retorno
    ldr x9, =pos               // Cargar número de posiciones
    ldr x9, [x9]
    mov x10, #0                // Contador de rotaciones
    ldr x11, =size            // Cargar tamaño del arreglo
    ldr x11, [x11]

loop_izq:
    cmp x10, x9                // Verificar si terminamos rotaciones
    beq fin_rotar_izq
    
    // Guardar primer elemento
    ldr x12, =array
    ldr x13, [x12]             // Guardar primer elemento
    
    // Mover elementos
    mov x14, #0                // Índice actual
mover_izq:
    add x15, x14, #1           // Siguiente posición
    cmp x15, x11               // Comparar con tamaño
    beq guardar_temp_izq
    
    ldr x16, [x12, x15, lsl #3]  // Cargar siguiente
    str x16, [x12, x14, lsl #3]  // Guardar en actual
    
    add x14, x14, #1
    b mover_izq
    
guardar_temp_izq:
    sub x15, x11, #1           // Última posición
    str x13, [x12, x15, lsl #3]  // Guardar primer elemento al final
    
    add x10, x10, #1
    b loop_izq
    
fin_rotar_izq:
    ldr x30, [sp], #16
    ret

rotar_derecha:
    str x30, [sp, #-16]!
    ldr x9, =pos              // Cargar posiciones
    ldr x9, [x9]
    mov x10, #0               // Contador
    ldr x11, =size           // Cargar tamaño
    ldr x11, [x11]

loop_der:
    cmp x10, x9
    beq fin_rotar_der
    
    // Guardar último elemento
    ldr x12, =array
    sub x13, x11, #1          // Índice último elemento
    ldr x14, [x12, x13, lsl #3]  // Guardar último elemento
    
    // Mover elementos
mover_der:
    cmp x13, #0
    beq guardar_temp_der
    
    sub x15, x13, #1
    ldr x16, [x12, x15, lsl #3]
    str x16, [x12, x13, lsl #3]
    
    sub x13, x13, #1
    b mover_der
    
guardar_temp_der:
    str x14, [x12]            // Guardar último al inicio
    
    add x10, x10, #1
    b loop_der
    
fin_rotar_der:
    ldr x30, [sp], #16
    ret

mostrar_arreglo:
    str x30, [sp, #-16]!
    mov x9, #0                // Índice
    ldr x10, =array          // Base del arreglo
    ldr x11, =size          // Tamaño
    ldr x11, [x11]

mostrar_loop:
    cmp x9, x11
    beq fin_mostrar
    
    ldr x12, [x10, x9, lsl #3]
    
    // Convertir número a string
    ldr x13, =buffer
    mov x14, x12
    mov x15, #0              // Contador dígitos

convertir:
    mov x16, #10
    udiv x17, x14, x16
    msub x18, x17, x16, x14
    add x18, x18, #'0'
    strb w18, [x13, x15]
    add x15, x15, #1
    mov x14, x17
    cbnz x14, convertir
    
    // Invertir los dígitos
    mov x16, #0              // Inicio
    sub x17, x15, #1         // Fin
invertir_loop:
    cmp x16, x17
    bge fin_invertir
    ldrb w18, [x13, x16]     // Cargar byte del inicio
    ldrb w19, [x13, x17]     // Cargar byte del final
    strb w19, [x13, x16]     // Guardar byte del final en inicio
    strb w18, [x13, x17]     // Guardar byte del inicio en final
    add x16, x16, #1
    sub x17, x17, #1
    b invertir_loop
fin_invertir:
    
    // Mostrar número
    mov x0, #1
    mov x1, x13
    mov x2, x15
    mov x8, #64
    svc #0
    
    // Mostrar espacio
    mov x0, #1
    ldr x1, =space
    mov x2, #1
    mov x8, #64
    svc #0
    
    add x9, x9, #1
    b mostrar_loop

fin_mostrar:
    ldr x30, [sp], #16
    ret

restaurar_original:
    str x30, [sp, #-16]!
    ldr x9, =array           // Base del arreglo
    mov x10, #1              // Valor inicial
    ldr x11, =size          // Tamaño
    ldr x11, [x11]
    mov x12, #0              // Índice

restaurar_loop:
    cmp x12, x11
    beq fin_restaurar
    str x10, [x9, x12, lsl #3]
    add x10, x10, #1
    add x12, x12, #1
    b restaurar_loop

fin_restaurar:
    ldr x30, [sp], #16
    ret
