/*=========================================================
 * Programa:     poten.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Calcula la potencia x^n utilizando un bucle
 *               iterativo. El número base x se pasa en x0 y 
 *               el exponente n se pasa en x1. El resultado 
 *               se devuelve en x0.
 * Compilación:  as -o poten.o poten.s
 *               gcc -o poten poten.o
 * Ejecución:    ./poten
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para calcular x^n
 * int potencia(int x, int n) {
 *     int resultado = 1;
 *     while (n > 0) {
 *         resultado *= x;
 *         n--;
 *     }
 *     return resultado;
 * }
 * 
 * int main() {
 *     int x = 2, n = 5;  // Ejemplo de base y exponente
 *     printf("La potencia de %d elevado a %d es: %d\n", x, n, potencia(x, n));
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global potencia

// Calcula la potencia x^n (x en x0, n en x1, resultado en x0)
potencia:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Verificar si el exponente (n) es 0
    cmp x1, 0
    b.eq potencia_base_cero // Si n es 0, devolver 1

    // Inicializar el resultado en x2 con x (base)
    mov x2, x0

potencia_loop:
    // Decrementar el exponente (n)
    sub x1, x1, 1
    cmp x1, 0
    b.eq potencia_done      // Si n llega a 0, salir del bucle

    // Multiplicar el resultado actual por x (base)
    mul x2, x2, x0
    b potencia_loop         // Repetir el bucle

potencia_base_cero:
    mov x2, 1               // Si n es 0, x^0 = 1

potencia_done:
    // Mover el resultado a x0
    mov x0, x2

    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret
