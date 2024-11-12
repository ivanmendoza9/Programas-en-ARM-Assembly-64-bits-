/*=======================================================
 * Programa:     longitud_cadena.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Calcula la longitud de una cadena de caracteres
 *               en ensamblador ARM64. Se espera que la cadena
 *               esté terminada en un byte nulo (ASCII 0).
 * Compilación:  as -o longitud_cadena.o longitud_cadena.s
 *               gcc -o longitud_cadena longitud_cadena.o
 * Ejecución:    ./longitud_cadena
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int longitud_cadena(const char* cadena) {
 *     int longitud = 0;
 * 
 *     while (cadena[longitud] != '\0') {
 *         longitud++;
 *     }
 * 
 *     return longitud;
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_ingreso:    .string "Ingrese una cadena: "
msg_resultado:  .string "La longitud de la cadena es: %d\n"
buffer:         .skip 100        // Buffer para almacenar la cadena
formato_str:    .string "%[^\n]" // Leer hasta encontrar newline

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

    // Leer cadena
    adr     x0, formato_str
    adr     x1, buffer
    bl      scanf

    // Calcular longitud
    adr     x0, buffer
    mov     x1, #0              // Contador de caracteres

contar_loop:
    ldrb    w2, [x0, x1]       // Cargar carácter
    cbz     w2, fin_conteo      // Si es 0, fin de cadena
    add     x1, x1, #1         // Incrementar contador
    b       contar_loop

fin_conteo:
    // Mostrar resultado
    adr     x0, msg_resultado
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
