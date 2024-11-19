/*=========================================================
 * Programa:     arreglo.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Suma los elementos de un arreglo de enteros
 *               de 64 bits. El puntero al arreglo se pasa en x0
 *               y el tamaño del arreglo se pasa en x1. El
 *               resultado se devuelve en x0.
 * Compilación:  as -o arreglo.o arreglo.s
 *               gcc -o arreglo arreglo.o
 * Ejecución:    ./arreglo
 =========================================================*/

// #include <stdio.h> // Biblioteca estándar para funciones de entrada y salida

// int main() { // Función principal

//     // Definición del arreglo y su tamaño
//     int arreglo[] = {10, 20, 30, 40, 50}; // Arreglo de enteros
//     int tamano_arreglo = 5; // Tamaño del arreglo

//     // Inicialización de variables para la suma
//     int suma = 0; // Variable para almacenar la suma total
//     int i = 0; // Contador para recorrer el arreglo

//     // Bucle para recorrer e imprimir cada elemento del arreglo
//     for (i = 0; i < tamano_arreglo; i++) { // Iterar sobre cada elemento
//         printf("Elemento[%d] = %d\n", i, arreglo[i]); // Imprimir el índice y valor del elemento
//         suma += arreglo[i]; // Sumar el valor actual al total
//     }

//     // Imprimir el resultado de la suma total
//     printf("La suma del arreglo es: %d\n", suma); // Mostrar la suma total del arreglo

//     return 0; // Terminar el programa
// }


.section .rodata
format_result: .asciz "La suma del arreglo es: %d\n"
format_array: .asciz "Elemento[%d] = %d\n"

.section .data
array: .word 10, 20, 30, 40, 50    // Arreglo de 5 elementos
array_size: .word 5                 // Tamaño del arreglo

.text
.global main
.type main, %function

main:
    // Prólogo de la función
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp                 // Establecer frame pointer
    
    // Guardar registros callee-saved
    stp     x19, x20, [sp, -16]!   // x19 = suma total, x20 = contador
    
    // Inicializar valores
    mov     x19, #0                 // suma = 0
    mov     x20, #0                 // i = 0
    
    // Cargar dirección del arreglo y su tamaño
    adrp    x21, array             
    add     x21, x21, :lo12:array   // x21 = dirección base del arreglo
    adrp    x22, array_size
    add     x22, x22, :lo12:array_size
    ldr     w22, [x22]             // w22 = tamaño del arreglo

loop:
    // Verificar si hemos terminado
    cmp     x20, x22
    b.ge    print_result
    
    // Cargar elemento actual
    ldr     w23, [x21, x20, lsl #2]  // w23 = array[i]
    
    // Imprimir elemento actual
    adrp    x0, format_array
    add     x0, x0, :lo12:format_array
    mov     x1, x20                // índice
    mov     x2, x23                // valor
    bl      printf
    
    // Sumar al total
    add     x19, x19, x23          // suma += array[i]
    
    // Incrementar contador
    add     x20, x20, #1           // i++
    b       loop

print_result:
    // Imprimir resultado final
    adrp    x0, format_result
    add     x0, x0, :lo12:format_result
    mov     x1, x19                // suma total
    bl      printf
    
    // Restaurar registros
    ldp     x19, x20, [sp], 16
    
    // Epílogo de la función
    mov     w0, #0                 // Valor de retorno
    ldp     x29, x30, [sp], 16
    ret

.size main, .-main
