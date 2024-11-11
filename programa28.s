/*=========================================================
 * Programa:     operacion_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa operaciones de establecer, borrar
 *               y alternar un bit en una posición específica
 *               de un número en ensamblador ARM64.
 * Compilación:  as -o operacion_bits.o operacion_bits.s
 *               gcc -o operacion_bits operacion_bits.o
 * Ejecución:    ./operacion_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Establecer un bit en la posición 'n'
 * void establecer_bit(unsigned int *valor, int n) {
 *     *valor |= (1 << n);
 * }
 * 
 * // Borrar un bit en la posición 'n'
 * void borrar_bit(unsigned int *valor, int n) {
 *     *valor &= ~(1 << n);
 * }
 * 
 * // Alternar un bit en la posición 'n'
 * void alternar_bit(unsigned int *valor, int n) {
 *     *valor ^= (1 << n);
 * }
 * 
 * int main() {
 *     unsigned int numero = 29;  // Ejemplo de número
 *     int posicion = 3;          // Ejemplo de posición de bit
 *     
 *     printf("Valor original: %u\n", numero);
 *     
 *     establecer_bit(&numero, posicion);
 *     printf("Después de establecer el bit: %u\n", numero);
 *     
 *     borrar_bit(&numero, posicion);
 *     printf("Después de borrar el bit: %u\n", numero);
 *     
 *     alternar_bit(&numero, posicion);
 *     printf("Después de alternar el bit: %u\n", numero);
 *     
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global establecer_bit
.global borrar_bit
.global alternar_bit

// Establecer un bit en la posición 'n'
establecer_bit:
    lsl x2, x1, #1       // x2 = 1 << n
    orr x0, x0, x2       // resultado = valor | (1 << n)
    ret

// Borrar un bit en la posición 'n'
borrar_bit:
    lsl x2, x1, #1       // x2 = 1 << n
    neg x2, x2           // x2 = -(1 << n) (obtener complemento)
    and x0, x0, x2       // resultado = valor & ~(1 << n)
    ret

// Alternar un bit en la posición 'n'
alternar_bit:
    lsl x2, x1, #1       // x2 = 1 << n
    eor x0, x0, x2       // resultado = valor ^ (1 << n)
    ret
