/*=========================================================
 * Programa:     desplazar_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa operaciones de desplazamiento a la izquierda
 *               y a la derecha de un número en ensamblador ARM64.
 * Compilación:  as -o desplazar_bits.o desplazar_bits.s
 *               gcc -o desplazar_bits desplazar_bits.o
 * Ejecución:    ./desplazar_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * void desplazar_izquierda(long int num, int desplazamiento) {
 *     num <<= desplazamiento;  // Desplazamiento a la izquierda
 *     printf("Desplazamiento a la izquierda: %ld\n", num);
 * }
 * 
 * void desplazar_derecha(long int num, int desplazamiento) {
 *     num >>= desplazamiento;  // Desplazamiento a la derecha
 *     printf("Desplazamiento a la derecha: %ld\n", num);
 * }
 * 
 * int main() {
 *     long int numero = 16;  // Ejemplo de número
 *     int desplazamiento = 2;  // Ejemplo de desplazamiento
 *     
 *     desplazar_izquierda(numero, desplazamiento);  // Llamada a desplazamiento a la izquierda
 *     desplazar_derecha(numero, desplazamiento);    // Llamada a desplazamiento a la derecha
 *     
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de datos */
.section .data
    mensaje_left: .asciz "Desplazamiento a la izquierda: %ld\n"
    mensaje_right: .asciz "Desplazamiento a la derecha: %ld\n"

/* Sección de código */
.section .text
.global desplazar_izquierda
.global desplazar_derecha

desplazar_izquierda:
    // Entrada: x0 = número, x1 = desplazamiento
    // Salida: x0 = resultado
    lsl x0, x0, x1   // Desplazamiento a la izquierda
    ret

desplazar_derecha:
    // Entrada: x0 = número, x1 = desplazamiento
    // Salida: x0 = resultado
    lsr x0, x0, x1   // Desplazamiento a la derecha
    ret
