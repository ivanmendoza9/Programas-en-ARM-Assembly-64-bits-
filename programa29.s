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

    .data
msg_ingreso:    .string "Ingrese un número: "
msg_resultado:  .string "Número de bits activados: %d\n"
msg_binario:    .string "Representación binaria: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

numero:         .word 0

    .text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Solicitar número
    adr     x0, msg_ingreso
    bl      printf

    // Leer número
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Cargar número
    adr     x0, numero
    ldr     w1, [x0]
    mov     w19, w1          // Guardar copia para mostrar binario

    // Contador de bits
    mov     w2, #0          // Inicializar contador

contar_loop:
    cbz     w1, fin_conteo  // Si el número es 0, terminar
    and     w3, w1, #1      // Obtener bit menos significativo
    add     w2, w2, w3      // Sumar al contador si es 1
    lsr     w1, w1, #1      // Desplazar a la derecha
    b       contar_loop

fin_conteo:
    // Mostrar resultado
    mov     w1, w2
    adr     x0, msg_resultado
    bl      printf

    // Mostrar representación binaria
    adr     x0, msg_binario
    bl      printf

    mov     w20, #32
mostrar_bits:
    sub     w20, w20, #1
    lsr     w21, w19, w20
    and     w1, w21, #1
    adr     x0, msg_bit
    bl      printf

    cmp     w20, #0
    b.ne    mostrar_bits

    adr     x0, msg_newline
    bl      printf

    // Retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
