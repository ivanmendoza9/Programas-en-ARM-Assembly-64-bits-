/*=======================================================
 * Programa:     ascii_a_entero.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Convierte una cadena de caracteres que representa
 *               un número decimal en su valor entero correspondiente
 *               utilizando ensamblador ARM64.
 * Compilación:  as -o ascii_a_entero.o ascii_a_entero.s
 *               gcc -o ascii_a_entero ascii_a_entero.o
 * Ejecución:    ./ascii_a_entero
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int ascii_a_entero(const char* str) {
 *     int resultado = 0;
 *     int i = 0;
 *     
 *     while (str[i] != '\0') {
 *         int digito = str[i] - '0';  // Convertir ASCII a dígito
 *         resultado = resultado * 10 + digito;  // Acumular el resultado
 *         i++;
 *     }
 *     return resultado;
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_ingreso:    .string "Ingrese un número entero (0-9): "
msg_resultado:  .string "El carácter ASCII es: %c\n"
formato_int:    .string "%d"     // Formato para leer entero
numero:         .word 0          // Variable para almacenar el número

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

    // Leer número entero
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Convertir entero a ASCII
    adr     x0, numero
    ldr     w0, [x0]            // Cargar el número
    add     w1, w0, #48         // Sumar 48 (ASCII '0') para obtener el carácter

    // Mostrar resultado
    adr     x0, msg_resultado
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
