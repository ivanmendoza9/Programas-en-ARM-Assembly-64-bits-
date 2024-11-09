/*=======================================================
 * Programa:     ordenamiento_burbuja.s
 * Autor:        IVAN MENDOZA
 * Fecha:        09 de noviembre de 2024
 * Descripción:  Implementa el algoritmo de ordenamiento burbuja en ensamblador ARM64 
 *               para ordenar un arreglo de enteros en orden ascendente. 
 *               El arreglo es modificado en su lugar.
 * Compilación:  as -o ordenamiento_burbuja.o ordenamiento_burbuja.s
 *               gcc -o ordenamiento_burbuja ordenamiento_burbuja.o
 * Ejecución:    ./ordenamiento_burbuja
 * Versión:      1.0
 * Link ASCIINEMA: 
 * Link DEBUG: 
 * Código equivalente en c:
 * -----------------------------------------------------
 * #include <stdio.h>
 * void ordenamiento_burbuja(int arr[], int n) {
 *     for (int i = 0; i < n - 1; i++) {
 *         for (int j = 0; j < n - i - 1; j++) {
 *             if (arr[j] > arr[j + 1]) {
 *                 int temp = arr[j];
 *                 arr[j] = arr[j + 1];
 *                 arr[j + 1] = temp;
 *             }
 *         }
 *     }
 * }
 * int main() {
 *     int arr[] = {5, 2, 9, 1, 5, 6};
 *     int n = sizeof(arr) / sizeof(arr[0]);
 *     ordenamiento_burbuja(arr, n);
 *     for (int i = 0; i < n; i++) {
 *         printf("%d ", arr[i]);
 *     }
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

.section .data
.section .text
.global ordenamiento_burbuja

// Función de ordenamiento burbuja en ARM64 Assembly
// Parámetros de entrada: x0 (puntero al arreglo), x1 (número de elementos)
// Retorno: el arreglo ordenado en orden ascendente (se modifica en su lugar)

ordenamiento_burbuja:
    mov x2, x1              // Guardar el tamaño del arreglo en x2 para el bucle externo

bucle_externo:
    sub x2, x2, 1           // Disminuir el tamaño del bucle externo en cada iteración
    mov x3, 0               // Reiniciar índice para el bucle interno

bucle_interno:
    cmp x3, x2              // Comparar el índice con el límite
    bge fin_bucle_interno   // Si alcanzamos el límite, salir del bucle interno

    ldr w4, [x0, x3, lsl #2]       // Cargar el elemento actual en w4
    add x6, x3, 1                  // Calcular el índice del siguiente elemento
    ldr w5, [x0, x6, lsl #2]       // Cargar el siguiente elemento en w5
    cmp w4, w5                     // Comparar el elemento actual con el siguiente

    ble siguiente                  // Si el actual <= siguiente, pasar al siguiente par

    // Intercambiar elementos
    str w5, [x0, x3, lsl #2]       // Guardar el siguiente en la posición actual
    str w4, [x0, x6, lsl #2]       // Guardar el actual en la posición siguiente

siguiente:
    add x3, x3, 1                  // Incrementar el índice para el bucle interno
    b bucle_interno                // Volver al inicio del bucle interno

fin_bucle_interno:
    cmp x2, 1                      // Comprobar si el tamaño del bucle externo es 1
    bgt bucle_externo              // Si es mayor que 1, continuar con el bucle externo
    ret                            // Terminar la función
