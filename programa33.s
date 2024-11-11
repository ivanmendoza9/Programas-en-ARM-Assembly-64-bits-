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

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para sumar los elementos de un arreglo
 * long suma_arreglo(long *arr, int tam) {
 *     long suma = 0;
 *     for (int i = 0; i < tam; i++) {
 *         suma += arr[i];
 *     }
 *     return suma;
 * }
 * 
 * int main() {
 *     long arreglo[] = {10, 20, 30, 40, 50};  // Ejemplo de arreglo
 *     int tam = 5;                            // Tamaño del arreglo
 *     long resultado = suma_arreglo(arreglo, tam);
 *     printf("La suma del arreglo es: %ld\n", resultado);
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global suma_arreglo

// Función que calcula la suma de un arreglo
// Entrada: x0 = puntero al arreglo, x1 = tamaño del arreglo
// Salida: x0 = suma de los elementos
suma_arreglo:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Inicializar la suma en x2 a 0
    mov x2, 0

suma_loop:
    // Comprobar si el tamaño (x1) es 0
    cmp x1, 0
    beq suma_done

    // Cargar el valor actual del arreglo en x3
    ldr x3, [x0], 8      // Cargar valor de x0 y avanzar el puntero en 8 bytes (para enteros de 64 bits)
    add x2, x2, x3       // Sumar el valor en x2

    // Decrementar el tamaño del arreglo
    sub x1, x1, 1
    b suma_loop          // Repetir el bucle

suma_done:
    // Mover el resultado a x0
    mov x0, x2

    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret
