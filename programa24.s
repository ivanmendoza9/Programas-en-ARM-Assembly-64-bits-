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

.global longitud_cadena

.section .text
longitud_cadena:
    mov x1, 0                      // Inicializar contador a 0

.loop:
    ldrb w2, [x0, x1]             // Cargar el siguiente byte de la cadena
    cmp w2, #0                     // Comparar con 0 (fin de cadena)
    beq .done                      // Si es 0, saltar a la sección done
    add x1, x1, #1                 // Incrementar contador
    b .loop                        // Volver al inicio del bucle

.done:
    mov x0, x1                     // Retornar la longitud en x0
    ret
