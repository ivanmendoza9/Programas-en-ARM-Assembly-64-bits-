/*=======================================================
 * Programa:     suma_matrices.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa la suma de dos matrices A y B,
 *               almacenando el resultado en la matriz C. 
 *               Se asume que A, B y C son matrices de 
 *               enteros de tamaño rows x cols.
 * Compilación:  as -o suma_matrices.o suma_matrices.s
 *               gcc -o suma_matrices suma_matrices.o
 * Ejecución:    ./suma_matrices
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * void suma_matrices(int* A, int* B, int* C, int rows, int cols) {
 *     for (int i = 0; i < rows; i++) {
 *         for (int j = 0; j < cols; j++) {
 *             int index = i * cols + j;
 *             C[index] = A[index] + B[index];
 *         }
 *     }
 * }
 * ---------------------------------------------------------
 =========================================================*/

.section .text
.global suma_matrices

suma_matrices:
    // Se espera que A, B, C sean punteros a enteros y rows y cols sean los tamaños de la matriz
    // A: x0, B: x1, C: x2, rows: x3, cols: x4

    // Inicializar índice de fila i = 0
    mov x5, #0         // i = 0
outer_loop:
    cmp x5, x3         // Comparar i con rows
    bge end_outer_loop // Si i >= rows, salir del bucle

    // Inicializar índice de columna j = 0
    mov x6, #0         // j = 0
inner_loop:
    cmp x6, x4         // Comparar j con cols
    bge end_inner_loop // Si j >= cols, salir del bucle

    // Calcular el índice en la matriz: índice = i * cols + j
    mul x7, x5, x4     // x7 = i * cols
    add x7, x7, x6     // x7 = i * cols + j

    // C[i][j] = A[i][j] + B[i][j]
    ldr w8, [x0, x7, lsl #2] // Cargar A[i][j]
    ldr w9, [x1, x7, lsl #2] // Cargar B[i][j]
    add w10, w8, w9    // w10 = A[i][j] + B[i][j]
    str w10, [x2, x7, lsl #2] // Guardar el resultado en C[i][j]

    add x6, x6, #1     // j++
    b inner_loop        // Repetir el bucle interno

end_inner_loop:
    add x5, x5, #1     // i++
    b outer_loop        // Repetir el bucle externo

end_outer_loop:
    ret
