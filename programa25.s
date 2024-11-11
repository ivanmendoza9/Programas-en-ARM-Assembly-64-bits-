/*=======================================================
 * Programa:     contar_vocales_consonantes.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Cuenta las vocales y consonantes en una cadena
 *               de caracteres en ensamblador ARM64.
 *               Se utilizan los contadores para vocales y consonantes.
 * Compilación:  as -o contar_vocales_consonantes.o contar_vocales_consonantes.s
 *               gcc -o contar_vocales_consonantes contar_vocales_consonantes.o
 * Ejecución:    ./contar_vocales_consonantes
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * void contar_vocales_consonantes(const char* cadena, int* vocales, int* consonantes) {
 *     *vocales = 0;
 *     *consonantes = 0;
 * 
 *     for (int i = 0; cadena[i] != '\0'; i++) {
 *         char c = cadena[i];
 *         if (c >= 'A' && c <= 'Z') {
 *             c += 'a' - 'A';  // Convertir a minúscula
 *         }
 *         
 *         if (c >= 'a' && c <= 'z') {
 *             if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
 *                 (*vocales)++;
 *             } else {
 *                 (*consonantes)++;
 *             }
 *         }
 *     }
 * }
 * ---------------------------------------------------------
 =========================================================*/

.global contar_vocales_consonantes

.section .text
contar_vocales_consonantes:
    // x0 = puntero a la cadena
    // x1 = puntero al contador de vocales
    // x2 = puntero al contador de consonantes
    
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!  // x19 = vocales, x20 = consonantes
    
    // Inicializar contadores
    mov x19, #0     // vocales = 0
    mov x20, #0     // consonantes = 0
    mov x4, #0      // índice = 0

loop:
    // Cargar carácter actual
    ldrb w3, [x0, x4]
    
    // Si es fin de cadena, terminar
    cbz w3, done
    
    // Convertir a minúscula si es mayúscula
    sub w5, w3, #'A'
    cmp w5, #25
    bhi not_upper
    add w3, w3, #32
    
not_upper:
    // Verificar si es letra minúscula
    sub w5, w3, #'a'
    cmp w5, #25
    bhi next_char
    
    // Comprobar si es vocal
    mov w6, #'a'
    cmp w3, w6
    beq is_vowel
    mov w6, #'e'
    cmp w3, w6
    beq is_vowel
    mov w6, #'i'
    cmp w3, w6
    beq is_vowel
    mov w6, #'o'
    cmp w3, w6
    beq is_vowel
    mov w6, #'u'
    cmp w3, w6
    beq is_vowel
    
    // Si no es vocal, es consonante
    add x20, x20, #1
    b next_char
    
is_vowel:
    add x19, x19, #1
    
next_char:
    add x4, x4, #1
    b loop
    
done:
    // Guardar resultados en las direcciones proporcionadas
    str x19, [x1]    // guardar vocales
    str x20, [x2]    // guardar consonantes
    
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
