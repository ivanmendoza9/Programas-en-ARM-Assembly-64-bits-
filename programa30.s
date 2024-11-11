/*=========================================================
 * Programa:     calcular_mcd.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa el algoritmo de Euclides para
 *               calcular el máximo común divisor (MCD)
 *               de dos números en ensamblador ARM64.
 * Compilación:  as -o calcular_mcd.o calcular_mcd.s
 *               gcc -o calcular_mcd calcular_mcd.o
 * Ejecución:    ./calcular_mcd
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para calcular el MCD utilizando el algoritmo de Euclides
 * int calcular_mcd(int a, int b) {
 *     while (b != 0) {
 *         int temp = b;
 *         b = a % b;
 *         a = temp;
 *     }
 *     return a;
 * }
 * 
 * int main() {
 *     int a = 56, b = 98;  // Ejemplo de números
 *     printf("El MCD de %d y %d es: %d\n", a, b, calcular_mcd(a, b));
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global calcular_mcd

calcular_mcd:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    
    // x0: primer número
    // x1: segundo número
    
    // Verificar que x1 no sea 0
    cmp x1, #0
    beq .fin
    
.loop:
    // Algoritmo de Euclides
    udiv x2, x0, x1     // x2 = x0 / x1
    msub x2, x2, x1, x0 // x2 = x0 - (x2 * x1) [remainder]
    mov x0, x1          // x0 = x1
    mov x1, x2          // x1 = remainder
    
    cmp x1, #0          // Comparar si el remainder es 0
    bne .loop           // Si no es 0, continuar el loop
    
.fin:
    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
