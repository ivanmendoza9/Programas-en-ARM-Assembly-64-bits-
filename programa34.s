/*=========================================================
 * Programa:     invertir.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Invierte los elementos de un arreglo de enteros
 *               de 64 bits. El puntero al arreglo se pasa en x0
 *               y el tamaño del arreglo se pasa en x1. El
 *               resultado se almacena en el mismo arreglo.
 * Compilación:  as -o invertir.o invertir.s
 *               gcc -o invertir invertir.o
 * Ejecución:    ./invertir
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para invertir los elementos de un arreglo
 * void invertir_arreglo(long *arr, int tam) {
 *     long temp;
 *     for (int i = 0; i < tam / 2; i++) {
 *         temp = arr[i];
 *         arr[i] = arr[tam - i - 1];
 *         arr[tam - i - 1] = temp;
 *     }
 * }
 * 
 * int main() {
 *     long arreglo[] = {10, 20, 30, 40, 50};  // Ejemplo de arreglo
 *     int tam = 5;                            // Tamaño del arreglo
 *     invertir_arreglo(arreglo, tam);
 *     for (int i = 0; i < tam; i++) {
 *         printf("%ld ", arreglo[i]);
 *     }
 *     printf("\n");
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.section .text
.global invertir_arreglo
.global _start

// Función principal (main)
_start:
    // Arreglo de ejemplo
    adr x0, arreglo       // Dirección del arreglo
    mov x1, 5             // Tamaño del arreglo (5 elementos)

    // Llamada a invertir_arreglo
    bl invertir_arreglo

    // Aquí el arreglo está invertido
    // Para fines de prueba, podemos dejar el arreglo en x0
    // y terminar el programa

    // Salir del programa
    mov x8, #93           // syscall número 93 (exit)
    mov x0, #0            // código de salida 0
    svc #0                // Hacer la llamada al sistema para salir

// Arreglo de ejemplo
arreglo:
    .quad 10, 20, 30, 40, 50

// Función que invierte un arreglo
// Entrada: x0 = puntero al arreglo, x1 = tamaño del arreglo
invertir_arreglo:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Calcular los límites iniciales
    mov x2, x0           // x2 = puntero al inicio del arreglo
    add x3, x0, x1, lsl #3  // x3 = puntero al final del arreglo (x1 * 8 bytes para enteros de 64 bits)
    sub x3, x3, 8        // Ajustar x3 para que apunte al último elemento

invertir_loop:
    // Comparar los punteros para ver si se cruzaron
    cmp x2, x3
    b.ge invertir_done   // Si se cruzaron, terminar

    // Intercambiar los elementos apuntados por x2 y x3
    ldr x4, [x2]         // Cargar el valor en x2 en x4
    ldr x5, [x3]         // Cargar el valor en x3 en x5
    str x5, [x2]         // Almacenar x5 en la posición de x2
    str x4, [x3]         // Almacenar x4 en la posición de x3

    // Mover los punteros hacia el centro
    add x2, x2, 8        // Avanzar x2 al siguiente elemento
    sub x3, x3, 8        // Retroceder x3 al elemento anterior
    b invertir_loop      // Repetir el bucle

invertir_done:
    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret
