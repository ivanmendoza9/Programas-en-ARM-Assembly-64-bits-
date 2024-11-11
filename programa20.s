/*=======================================================
 * Programa:     multiplicar_matrices.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa la multiplicación de dos matrices A y B,
 *               almacenando el resultado en la matriz C. 
 *               Se asume que A es de tamaño rowsA x colsA y B es de tamaño colsA x colsB.
 * Compilación:  as -o multiplicar_matrices.o multiplicar_matrices.s
 *               gcc -o multiplicar_matrices multiplicar_matrices.o
 * Ejecución:    ./multiplicar_matrices
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * void multiplicar_matrices(int* A, int* B, int* C, int rowsA, int colsA, int colsB) {
 *     for (int i = 0; i < rowsA; i++) {
 *         for (int j = 0; j < colsB; j++) {
 *             C[i * colsB + j] = 0;
 *             for (int k = 0; k < colsA; k++) {
 *                 C[i * colsB + j] += A[i * colsA + k] * B[k * colsB + j];
 *             }
 *         }
 *     }
 * }
 * ---------------------------------------------------------
 =========================================================*/

.section .text
.global multiplicar_matrices

multiplicar_matrices:
    // Se espera que A, B, C sean punteros a enteros y rowsA, colsA, colsB sean los tamaños
    // A: x0, B: x1, C: x2, rowsA: x3, colsA: x4, colsB: x5

    // Inicializar índice de fila i = 0
    mov x6, #0  // i = 0
outer_loop:
    cmp x6, x3  // Comparar i con rowsA
    bge end_outer_loop // Si i >= rowsA, salir del bucle

    // Inicializar índice de columna j = 0
    mov x7, #0  // j = 0
inner_loop:
    cmp x7, x5  // Comparar j con colsB
    bge end_inner_loop // Si j >= colsB, salir del bucle

    // Inicializar C[i][j] = 0
    mov w9, #0
    str w9, [x2, x6, lsl #2] // C[i][j] = 0

    // Bucle k para la multiplicación
    mov x8, #0  // Reiniciar k
k_loop:
    cmp x8, x4  // Comparar k con colsA
    bge end_k_loop // Si k >= colsA, salir del bucle

    // C[i][j] += A[i][k] * B[k][j]
    // Calcular los índices
    mul x10, x6, x4 // x10 = i * colsA
    add x10, x10, x8 // x10 = i * colsA + k
    ldr w11, [x0, x10, lsl #2] // w11 = A[i][k]

    mul x12, x8, x5 // x12 = k * colsB
    add x12, x12, x7 // x12 = k * colsB + j
    ldr w13, [x1, x12, lsl #2] // w13 = B[k][j]

    mul w14, w11, w13 // w14 = A[i][k] * B[k][j]

    // Sumar el resultado a C[i][j]
    ldr w15, [x2, x6, lsl #2] // w15 = C[i][j]
    add w15, w15, w14 // w15 += A[i][k] * B[k][j]
    str w15, [x2, x6, lsl #2] // Guardar el resultado en C[i][j]

    add x8, x8, #1 // k++
    b k_loop // Repetir el bucle k

end_k_loop:
    add x7, x7, #1 // j++
    b inner_loop // Repetir el bucle interno

end_inner_loop:
    add x6, x6, #1 // i++
    b outer_loop // Repetir el bucle externo

end_outer_loop:
    ret
