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

.data
array:      .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0    // Espacio para 10 números
arr_len:    .word 10                               // Longitud máxima del arreglo
msg_input:  .asciz "Ingrese 10 números enteros:\n"
msg_num:    .asciz "Número %d: "
scan_fmt:   .asciz "%d"
msg_before: .asciz "Arreglo antes de ordenar:\n"
msg_after:  .asciz "Arreglo después de ordenar:\n"
msg_elem:   .asciz "%d "
msg_nl:     .asciz "\n"

.text
.global main
main:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Imprimir mensaje de entrada
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Inicializar para lectura de números
    mov w22, #0                  // Contador para entrada
input_loop:
    // Verificar si hemos leído 10 números
    cmp w22, #10
    bge input_done

    // Imprimir prompt para número actual
    adrp x0, msg_num
    add x0, x0, :lo12:msg_num
    add w1, w22, #1
    bl printf

    // Preparar para scanf
    adrp x0, scan_fmt
    add x0, x0, :lo12:scan_fmt
    adrp x1, array
    add x1, x1, :lo12:array
    lsl w2, w22, #2              // Multiplicar índice por 4
    add x1, x1, w2, UXTW        // Añadir offset al array
    bl scanf

    add w22, w22, #1            // Incrementar contador
    b input_loop

input_done:
    // Imprimir mensaje inicial
    adrp x0, msg_before
    add x0, x0, :lo12:msg_before
    bl printf

    // Imprimir arreglo original
    bl print_array

    // Preparar para ordenamiento burbuja
    adrp x0, arr_len
    add x0, x0, :lo12:arr_len
    ldr w0, [x0]                // w0 = longitud del arreglo
    mov w1, w0                  // w1 = contador externo

outer_loop:
    cmp w1, #1                  // Comparar contador con 1
    ble done_sort               // Si <= 1, terminamos
    
    mov w2, #0                  // w2 = índice para bucle interno
    sub w3, w1, #1             // w3 = límite del bucle interno

inner_loop:
    cmp w2, w3                  // Comparar índice con límite
    bge end_inner              // Si >= límite, terminar bucle interno

    // Cargar elementos a comparar
    adrp x4, array
    add x4, x4, :lo12:array
    lsl w5, w2, #2             // w5 = índice * 4
    add x5, x4, w5, UXTW       // x5 = dirección del elemento actual
    ldr w6, [x5]               // w6 = elemento actual
    ldr w7, [x5, #4]           // w7 = siguiente elemento

    // Comparar y intercambiar si es necesario
    cmp w6, w7                  // Comparar elementos
    ble no_swap                // Si están en orden, no intercambiar
    
    // Intercambiar elementos
    str w7, [x5]               // Guardar elemento menor primero
    str w6, [x5, #4]           // Guardar elemento mayor después

no_swap:
    add w2, w2, #1             // Incrementar índice interno
    b inner_loop               // Continuar bucle interno

end_inner:
    sub w1, w1, #1             // Decrementar contador externo
    b outer_loop               // Continuar bucle externo

done_sort:
    // Imprimir mensaje final
    adrp x0, msg_after
    add x0, x0, :lo12:msg_after
    bl printf

    // Imprimir arreglo ordenado
    bl print_array

    // Restaurar y retornar
    ldp x29, x30, [sp], 16
    ret

// Subrutina para imprimir el arreglo
print_array:
    stp x29, x30, [sp, -16]!    // Guardar registros
    
    adrp x19, array             // Cargar dirección del arreglo
    add x19, x19, :lo12:array
    
    adrp x20, arr_len
    add x20, x20, :lo12:arr_len
    ldr w20, [x20]              // Cargar longitud
    
    mov w21, #0                 // Inicializar contador

print_loop:
    cmp w21, w20                // Comparar contador con longitud
    bge print_end               // Si terminamos, salir
    
    // Imprimir elemento actual
    adrp x0, msg_elem
    add x0, x0, :lo12:msg_elem
    ldr w1, [x19, w21, UXTW #2] // Cargar elemento actual
    bl printf
    
    add w21, w21, #1            // Incrementar contador
    b print_loop

print_end:
    // Imprimir nueva línea
    adrp x0, msg_nl
    add x0, x0, :lo12:msg_nl
    bl printf
    
    ldp x29, x30, [sp], 16      // Restaurar registros
    ret
