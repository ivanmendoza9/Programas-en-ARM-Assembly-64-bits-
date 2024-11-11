/*=========================================================
 * Programa:     contar_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Cuenta la cantidad de bits activados (1) en un
 *               número en ensamblador ARM64.
 * Compilación:  as -o contar_bits.o contar_bits.s
 *               gcc -o contar_bits contar_bits.o
 * Ejecución:    ./contar_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para contar los bits activados (1)
 * int contar_bits(unsigned int numero) {
 *     int contador = 0;
 *     while (numero) {
 *         contador += (numero & 1);  // Verifica el bit menos significativo
 *         numero >>= 1;              // Desplaza a la derecha
 *     }
 *     return contador;
 * }
 * 
 * int main() {
 *     unsigned int numero = 29;  // Ejemplo de número
 *     printf("Número de bits activados: %d\n", contar_bits(numero));
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

/* Sección de código */
.section .text
.global contar_bits

contar_bits:
    mov x1, 0          // Contador de bits activados
    mov x2, x0         // Copia el número a x2

.loop:
    and x3, x2, #1     // Verifica el bit menos significativo
    add x1, x1, x3     // Incrementa el contador si el bit es 1
    lsr x2, x2, #1     // Desplaza a la derecha
    cbnz x2, .loop     // Si x2 no es cero, continúa

    mov x0, x1         // El resultado se almacena en x0
    ret
