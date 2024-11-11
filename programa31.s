/*=========================================================
 * Programa:     mcm.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Calcula el Mínimo Común Múltiplo (MCM) de
 *               dos números a y b usando el algoritmo de
 *               Euclides para calcular el MCD.
 * Compilación:  as -o mcm.o mcm.s
 *               gcc -o mcm mcm.o
 * Ejecución:    ./mcm
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para calcular el MCD utilizando el algoritmo de Euclides
 * int mcd(int a, int b) {
 *     while (b != 0) {
 *         int temp = b;
 *         b = a % b;
 *         a = temp;
 *     }
 *     return a;
 * }
 * 
 * // Función para calcular el MCM utilizando la relación MCM(a, b) = (a * b) / MCD(a, b)
 * int mcm(int a, int b) {
 *     return (a * b) / mcd(a, b);
 * }
 * 
 * int main() {
 *     int a = 56, b = 98;  // Ejemplo de números
 *     printf("El MCM de %d y %d es: %d\n", a, b, mcm(a, b));
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global mcm
.global mcd

// Calcula el MCM de dos números a y b
mcm:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Guardar valores iniciales en registros para el cálculo
    mov x2, x0          // x2 = a
    mov x3, x1          // x3 = b

    // Calcular el producto a * b y guardarlo en x4
    mul x4, x2, x3      // x4 = a * b

    // Llamar a la función mcd para obtener el MCD
    bl mcd              // Resultado del MCD está en x0 después de la llamada

    // Dividir el producto (a * b) entre el MCD para obtener el MCM
    udiv x0, x4, x0     // MCM almacenado en x0

    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret

// Función para calcular el MCD usando el Algoritmo de Euclides
mcd:
    // x0 = a, x1 = b
    cmp x1, 0
    b.eq mcd_done
mcd_loop:
    mov x2, x1
    udiv x3, x0, x1     // x3 = x0 / x1
    msub x1, x3, x1, x0 // x1 = x0 - (x3 * x1)
    mov x0, x2
    cbnz x1, mcd_loop
mcd_done:
    ret
