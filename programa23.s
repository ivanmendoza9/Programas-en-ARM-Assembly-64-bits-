/*=======================================================
 * Programa:     entero_a_ascii.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Convierte un número entero en su representación
 *               en una cadena ASCII, permitiendo especificar la base
 *               (por ejemplo, binario, octal, decimal, hexadecimal).
 * Compilación:  as -o entero_a_ascii.o entero_a_ascii.s
 *               gcc -o entero_a_ascii entero_a_ascii.o
 * Ejecución:    ./entero_a_ascii
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * #include <string.h>
 * 
 * void entero_a_ascii(int num, char* buffer, int base) {
 *     int i = 0, temp;
 *     int is_negative = 0;
 * 
 *     if (num == 0) {
 *         buffer[i++] = '0';
 *         buffer[i] = '\0';
 *         return;
 *     }
 * 
 *     if (num < 0 && base == 10) {
 *         is_negative = 1;
 *         num = -num;
 *     }
 * 
 *     while (num != 0) {
 *         temp = num % base;
 *         buffer[i++] = (temp > 9) ? (temp - 10) + 'A' : temp + '0';
 *         num = num / base;
 *     }
 * 
 *     if (is_negative)
 *         buffer[i++] = '-';
 * 
 *     buffer[i] = '\0';
 * 
 *     // Invertir el buffer
 *     int start = 0;
 *     int end = i - 1;
 *     while (start < end) {
 *         char tmp = buffer[start];
 *         buffer[start] = buffer[end];
 *         buffer[end] = tmp;
 *         start++;
 *         end--;
 *     }
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_ingreso:    .string "Ingrese un número (0-9): "
msg_resultado:  .string "El valor entero es: %d\n"
formato_char:   .string " %c"    // Espacio antes de %c para ignorar whitespace
buffer:         .skip 2          // Buffer para almacenar el carácter

    .text
    .global main
    .align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Mostrar mensaje de ingreso
    adr     x0, msg_ingreso
    bl      printf

    // Leer carácter
    adr     x0, formato_char
    adr     x1, buffer
    bl      scanf

    // Convertir ASCII a entero
    adr     x0, buffer
    ldrb    w0, [x0]            // Cargar el carácter
    sub     w0, w0, #48         // Restar 48 (ASCII '0') para obtener el valor

    // Mostrar resultado
    mov     w1, w0              // Mover resultado a w1 para printf
    adr     x0, msg_resultado
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret

