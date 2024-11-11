/*=========================================================
 * Programa:     grande.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Encuentra el segundo elemento más grande
 *               en un arreglo de enteros. Los parámetros de
 *               entrada son: x0 = puntero al arreglo, 
 *               x1 = tamaño del arreglo.
 * Compilación:  as -o grande.o grande.s
 *               gcc -o grande grande.o
 * Ejecución:    ./grande
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int segundo_mas_grande(int *arr, int tam) {
 *     int max1 = -1, max2 = -1;
 *     for (int i = 0; i < tam; i++) {
 *         if (arr[i] > max1) {
 *             max2 = max1;
 *             max1 = arr[i];
 *         } else if (arr[i] > max2) {
 *             max2 = arr[i];
 *         }
 *     }
 *     return (max2 == -1) ? -1 : max2;
 * }
 * 
 * int main() {
 *     int arreglo[] = {3, 1, 4, 1, 5, 9, 2, 6};
 *     int tam = 8;
 *     int segundo = segundo_mas_grande(arreglo, tam);
 *     printf("El segundo elemento más grande es: %d\n", segundo);
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.section .text
.global segundo_mas_grande
.global _start

// Función principal (main)
_start:
    // Arreglo de ejemplo
    adr x0, arreglo       // Dirección del arreglo
    mov x1, 8             // Tamaño del arreglo (8 elementos)

    // Llamada a segundo_mas_grande
    bl segundo_mas_grande

    // El resultado está en x0, imprimimos el valor
    mov x8, #64           // syscall número 64 (write)
    mov x1, x0            // Resultado a imprimir
    mov x2, #4            // Longitud del resultado (4 bytes)
    mov x0, #1            // File descriptor (stdout)
    svc #0                // Llamada al sistema

    // Salir del programa
    mov x8, #93           // syscall número 93 (exit)
    mov x0, #0            // código de salida 0
    svc #0                // Llamada al sistema para salir

// Arreglo de ejemplo
arreglo:
    .quad 3, 1, 4, 1, 5, 9, 2, 6

// Función que encuentra el segundo elemento más grande
// Entrada: x0 = puntero al arreglo, x1 = tamaño del arreglo
segundo_mas_grande:
    stp x29, x30, [sp, -16]!  // Guardar registros
    mov x29, sp

    // Inicializar los dos máximos
    mov x2, -1                 // max1 = -1
    mov x3, -1                 // max2 = -1

    // Bucle para recorrer el arreglo
    mov x4, 0                  // índice i = 0

busqueda_loop:
    cmp x4, x1                 // Comparar i con tamaño del arreglo
    bge busqueda_done          // Si i >= tamaño, terminar

    ldr x5, [x0, x4, lsl #3]   // Cargar el elemento en x5 (8 bytes por entero)
    
    // Comparar con max1
    cmp x5, x2
    ble comprobar_max2         // Si x5 <= max1, comprobar max2

    // Actualizar max2 y max1
    mov x3, x2                 // max2 = max1
    mov x2, x5                 // max1 = x5

    b busqueda_continue

comprobar_max2:
    // Comparar con max2
    cmp x5, x3
    ble busqueda_continue      // Si x5 <= max2, continuar

    // Actualizar max2
    mov x3, x5                 // max2 = x5

busqueda_continue:
    add x4, x4, 1              // Incrementar índice
    b busqueda_loop            // Repetir bucle

busqueda_done:
    // Verificar si max2 se actualizó
    cmp x3, x2                 // Si max2 es igual a max1, no hay segundo mayor
    beq no_segundo_mayor
    mov x0, x3                 // Retornar max2
    b fin

no_segundo_mayor:
    mov x0, -1                 // Retornar -1 si no se encontró segundo mayor

fin:
    ldp x29, x30, [sp], 16
    ret
