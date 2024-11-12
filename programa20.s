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

.data
// Dimensiones de las matrices (3x3)
N: .word 3          // Filas
M: .word 3          // Columnas

// Matrices
matrix1: .zero 36    // 3x3 matriz (4 bytes por elemento)
matrix2: .zero 36    // 3x3 matriz
result: .zero 36     // Matriz resultado

// Mensajes y formatos
msg_matrix1: .asciz "\nIngrese los elementos de la primera matriz 3x3:\n"
msg_matrix2: .asciz "\nIngrese los elementos de la segunda matriz 3x3:\n"
msg_element: .asciz "Ingrese elemento [%d][%d]: "
msg_result: .asciz "\nMatriz resultado:\n"
fmt_input: .asciz "%d"
fmt_output: .asciz "%4d "
new_line: .asciz "\n"

.text
.global main

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Anunciar entrada de primera matriz
    adrp x0, msg_matrix1
    add x0, x0, :lo12:msg_matrix1
    bl printf

    // Leer primera matriz
    adrp x20, matrix1
    add x20, x20, :lo12:matrix1
    mov x19, #0          // i = 0

loop1_i:
    cmp x19, #3
    beq end_loop1_i
    mov x21, #0          // j = 0

loop1_j:
    cmp x21, #3
    beq end_loop1_j

    // Mostrar prompt
    adrp x0, msg_element
    add x0, x0, :lo12:msg_element
    mov x1, x19
    mov x2, x21
    bl printf

    // Leer elemento
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf

    // Calcular posición y guardar
    mov x22, #12         // 3 * 4 (tamaño de fila)
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    ldr w24, [sp]
    str w24, [x20, x23]  // guardar en matrix1[i][j]
    add sp, sp, #16

    add x21, x21, #1     // j++
    b loop1_j

end_loop1_j:
    add x19, x19, #1     // i++
    b loop1_i

end_loop1_i:
    // Anunciar entrada de segunda matriz
    adrp x0, msg_matrix2
    add x0, x0, :lo12:msg_matrix2
    bl printf

    // Leer segunda matriz
    adrp x20, matrix2
    add x20, x20, :lo12:matrix2
    mov x19, #0          // i = 0

loop2_i:
    cmp x19, #3
    beq end_loop2_i
    mov x21, #0          // j = 0

loop2_j:
    cmp x21, #3
    beq end_loop2_j

    // Mostrar prompt
    adrp x0, msg_element
    add x0, x0, :lo12:msg_element
    mov x1, x19
    mov x2, x21
    bl printf

    // Leer elemento
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf

    // Calcular posición y guardar
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total
    ldr w24, [sp]
    str w24, [x20, x23]  // guardar en matrix2[i][j]
    add sp, sp, #16

    add x21, x21, #1     // j++
    b loop2_j

end_loop2_j:
    add x19, x19, #1     // i++
    b loop2_i

end_loop2_i:
    // Realizar la multiplicación
    mov x19, #0          // i = 0

mult_loop_i:
    cmp x19, #3
    beq end_mult_loop_i
    mov x21, #0          // j = 0

mult_loop_j:
    cmp x21, #3
    beq end_mult_loop_j
    
    // Inicializar el acumulador para el elemento resultado[i][j]
    mov w26, #0          // sum = 0
    mov x22, #0          // k = 0

mult_loop_k:
    cmp x22, #3
    beq end_mult_loop_k

    // Calcular offset para matrix1[i][k]
    mov x23, #12         // 3 * 4
    mul x24, x19, x23    // i * (3 * 4)
    mov x25, #4
    mul x27, x22, x25    // k * 4
    add x24, x24, x27    // offset para matrix1[i][k]

    // Calcular offset para matrix2[k][j]
    mul x25, x22, x23    // k * (3 * 4)
    mov x27, #4
    mul x28, x21, x27    // j * 4
    add x25, x25, x28    // offset para matrix2[k][j]

    // Cargar elementos y multiplicar
    adrp x20, matrix1
    add x20, x20, :lo12:matrix1
    ldr w27, [x20, x24]  // matrix1[i][k]

    adrp x20, matrix2
    add x20, x20, :lo12:matrix2
    ldr w28, [x20, x25]  // matrix2[k][j]

    // Multiplicar y acumular
    mul w27, w27, w28
    add w26, w26, w27    // sum += matrix1[i][k] * matrix2[k][j]

    add x22, x22, #1     // k++
    b mult_loop_k

end_mult_loop_k:
    // Guardar resultado
    mov x23, #12         // 3 * 4
    mul x24, x19, x23    // i * (3 * 4)
    mov x25, #4
    mul x27, x21, x25    // j * 4
    add x24, x24, x27    // offset total

    adrp x20, result
    add x20, x20, :lo12:result
    str w26, [x20, x24]  // guardar sum en result[i][j]

    add x21, x21, #1     // j++
    b mult_loop_j

end_mult_loop_j:
    add x19, x19, #1     // i++
    b mult_loop_i

end_mult_loop_i:
    // Mostrar resultado
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    bl printf

    // Imprimir matriz resultado
    mov x19, #0          // i = 0

print_loop_i:
    cmp x19, #3
    beq end_print_loop_i
    mov x21, #0          // j = 0

print_loop_j:
    cmp x21, #3
    beq end_print_loop_j

    // Calcular offset y cargar elemento
    mov x22, #12         // 3 * 4
    mul x23, x19, x22    // i * (3 * 4)
    mov x24, #4
    mul x25, x21, x24    // j * 4
    add x23, x23, x25    // offset total

    adrp x20, result
    add x20, x20, :lo12:result
    ldr w1, [x20, x23]   // cargar resultado[i][j]

    // Imprimir elemento
    adrp x0, fmt_output
    add x0, x0, :lo12:fmt_output
    bl printf

    add x21, x21, #1     // j++
    b print_loop_j

end_print_loop_j:
    // Nueva línea al final de cada fila
    adrp x0, new_line
    add x0, x0, :lo12:new_line
    bl printf

    add x19, x19, #1     // i++
    b print_loop_i

end_print_loop_i:
    // Epílogo
    ldp x29, x30, [sp], 16
    ret
