/*=======================================================
 * Programa:     merge_sort.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa el algoritmo de ordenamiento por mezcla (merge sort)
 *               en ensamblador ARM64 para ordenar un arreglo de enteros
 *               en orden ascendente. Se utiliza recursión y mezcla de arreglos.
 * Compilación:  as -o merge_sort.o merge_sort.s
 *               gcc -o merge_sort merge_sort.o
 * Ejecución:    ./merge_sort
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ------------------------------------------------------------
 * #include <stdio.h>
 * 
 * void merge(int arr[], int mid, int size) {
 *     int temp[size];
 *     int i = 0, j = mid, k = 0;
 * 
 *     while (i < mid && j < size) {
 *         if (arr[i] <= arr[j]) {
 *             temp[k++] = arr[i++];
 *         } else {
 *             temp[k++] = arr[j++];
 *         }
 *     }
 * 
 *     while (i < mid) {
 *         temp[k++] = arr[i++];
 *     }
 * 
 *     while (j < size) {
 *         temp[k++] = arr[j++];
 *     }
 * 
 *     for (i = 0; i < size; i++) {
 *         arr[i] = temp[i];
 *     }
 * }
 * 
 * void merge_sort(int arr[], int size) {
 *     if (size < 2) {
 *         return;
 *     }
 * 
 *     int mid = size / 2;
 * 
 *     merge_sort(arr, mid);               // Llamada recursiva para la primera mitad
 *     merge_sort(arr + mid, size - mid);  // Llamada recursiva para la segunda mitad
 * 
 *     merge(arr, mid, size);              // Mezclar las dos mitades
 * }
 * ------------------------------------------------------------
 =========================================================*/

.section .data
.section .text
.global merge_sort
.global merge

// merge_sort(int* arr, int n)
// x0: puntero al array
// x1: tamaño del array
merge_sort:
    stp x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    stp x19, x20, [sp, #-16]!    // Guardar registros que preservaremos
    stp x21, x22, [sp, #-16]!

    mov x19, x0                  // Guardar puntero al array
    mov x20, x1                  // Guardar tamaño

    cmp x20, #2                  // Caso base: si tamaño < 2, ya está ordenado
    b.lt .Lend_merge_sort

    lsr x21, x20, #1             // mid = size / 2

    mov x0, x19                  // Primera mitad del array
    mov x1, x21                  // tamaño = mid
    bl merge_sort                // Llamada recursiva

    add x0, x19, x21, lsl #2     // Segunda mitad del array
    sub x1, x20, x21             // tamaño = size - mid
    bl merge_sort                // Llamada recursiva

    mov x0, x19                  // Array original
    mov x1, x21                  // mid
    mov x2, x20                  // size
    bl merge                    // Llamada a la función merge

.Lend_merge_sort:
    ldp x21, x22, [sp], #16      // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// merge(int* arr, int mid, int size)
// x0: puntero al array
// x1: mid
// x2: tamaño total
merge:
    stp x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    stp x19, x20, [sp, #-16]!    // Guardar registros que usaremos
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x26, [sp, #-16]!
    
    mov x29, sp                  // Establecer frame pointer
    mov x19, x0                  // Array original
    mov x20, x1                  // mid
    mov x21, x2                  // Tamaño total

    mov x3, x21                  // Reservar espacio para el array temporal
    lsl x3, x3, #2               // Multiplicar por 4 (tamaño de int)
    sub sp, sp, x3               // Reservar espacio en el stack
    mov x25, sp                  // Guardar puntero al array temporal

    mov x22, #0                  // i = 0 (índice para primera mitad)
    mov x23, x20                 // j = mid (índice para segunda mitad)
    mov x24, #0                  // k = 0 (índice para array temporal)

.Lmerge_loop:
    cmp x22, x20                 // i >= mid?
    b.ge .Lcopy_right_half
    cmp x23, x21                 // j >= size?
    b.ge .Lcopy_left_half

    ldr w3, [x19, x22, lsl #2]   // arr[i]
    ldr w4, [x19, x23, lsl #2]   // arr[j]
    cmp w3, w4
    b.gt .Lcopy_from_right

.Lcopy_from_left:
    str w3, [x25, x24, lsl #2]   // temp[k] = arr[i]
    add x22, x22, #1             // i++
    add x24, x24, #1             // k++
    b .Lmerge_loop

.Lcopy_from_right:
    str w4, [x25, x24, lsl #2]   // temp[k] = arr[j]
    add x23, x23, #1             // j++
    add x24, x24, #1             // k++
    b .Lmerge_loop

.Lcopy_left_half:
    cmp x22, x20                 // Quedan elementos en la izquierda?
    b.ge .Lcopy_back
    ldr w3, [x19, x22, lsl #2]   // arr[i]
    str w3, [x25, x24, lsl #2]   // temp[k] = arr[i]
    add x22, x22, #1             // i++
    add x24, x24, #1             // k++
    b .Lcopy_left_half

.Lcopy_right_half:
    cmp x23, x21                 // Quedan elementos en la derecha?
    b.ge .Lcopy_back
    ldr w4, [x19, x23, lsl #2]   // arr[j]
    str w4, [x25, x24, lsl #2]   // temp[k] = arr[j]
    add x23, x23, #1             // j++
    add x24, x24, #1             // k++
    b .Lcopy_right_half

.Lcopy_back:
    mov x22, #0                  // i = 0
.Lcopy_back_loop:
    cmp x22, x21                 // i >= size?
    b.ge .Lmerge_end
    ldr w3, [x25, x22, lsl #2]   // temp[i]
    str w3, [x19, x22, lsl #2]   // arr[i] = temp[i]
    add x22, x22, #1             // i++
    b .Lcopy_back_loop

.Lmerge_end:
    mov sp, x29                  // Restaurar stack pointer
    ldp x25, x26, [sp], #16
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
