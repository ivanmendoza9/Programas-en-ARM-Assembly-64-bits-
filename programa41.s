/*=========================================================
 * Programa:     decimal_to_hex.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número decimal 
 *               a hexadecimal, y obtener caracteres del resultado y su longitud.
 * Compilación:  as -o decimal_to_hex.o decimal_to_hex.s
 *               gcc -o decimal_to_hex decimal_to_hex.o
 * Ejecución:    ./decimal_to_hex
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * char hex_chars[] = "0123456789ABCDEF";
 * char hex_array[32];
 * int result_length = 0;
 * 
 * void decimal_to_hex(int decimal) {
 *     if (decimal == 0) {
 *         hex_array[0] = '0';
 *         result_length = 1;
 *         return;
 *     }
 *     result_length = 0;
 *     while (decimal > 0) {
 *         hex_array[result_length++] = hex_chars[decimal % 16];
 *         decimal /= 16;
 *     }
 *     // Invertir el array para obtener el valor correcto
 *     for (int i = 0; i < result_length / 2; i++) {
 *         char temp = hex_array[i];
 *         hex_array[i] = hex_array[result_length - i - 1];
 *         hex_array[result_length - i - 1] = temp;
 *     }
 * }
 * 
 * char get_hex_char(int index) {
 *     if (index < 0 || index >= result_length) {
 *         return '\0';  // índice inválido
 *     }
 *     return hex_array[index];
 * }
 * 
 * int get_length() {
 *     return result_length;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    .align 3
    hex_array: .skip 32         // Buffer para almacenar resultado hexadecimal
    result_length: .word 0      // Longitud del resultado
    hex_chars: .ascii "0123456789ABCDEF"  // Caracteres hexadecimales

.text
.align 2
.global decimal_to_hex
.global get_hex_char
.global get_length

// Función para convertir decimal a hexadecimal
// Entrada: x0 = número decimal
decimal_to_hex:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]
    stp     x21, x22, [sp, 32]

    mov     x19, x0            // Guardar número original
    
    // Reiniciar contador de longitud
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    str     wzr, [x0]
    
    // Si el número es 0, manejar caso especial
    cbnz    x19, conversion_loop
    
    // Caso especial para 0
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    mov     w1, '0'
    strb    w1, [x0]
    
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    mov     w1, #1
    str     w1, [x0]
    b       end_conversion

conversion_loop:
    // Mientras el número no sea 0
    cbz     x19, reverse_result
    
    // Obtener residuo (número & 0xF)
    and     x20, x19, #0xF
    
    // Obtener carácter hexadecimal correspondiente
    adrp    x21, hex_chars
    add     x21, x21, :lo12:hex_chars
    ldrb    w20, [x21, x20]
    
    // Guardar carácter en el array
    adrp    x21, result_length
    add     x21, x21, :lo12:result_length
    ldr     w22, [x21]
    
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    strb    w20, [x0, x22]
    
    // Incrementar longitud
    add     w22, w22, #1
    str     w22, [x21]
    
    // Dividir número entre 16
    lsr     x19, x19, #4
    
    b       conversion_loop

reverse_result:
    // Invertir el resultado ya que se generó al revés
    adrp    x0, hex_array
    add     x0, x0, :lo12:hex_array
    adrp    x1, result_length
    add     x1, x1, :lo12:result_length
    ldr     w1, [x1]           // w1 = longitud
    
    mov     x2, #0             // índice inicio
    sub     w3, w1, #1         // índice final
    
reverse_loop:
    cmp     w2, w3
    b.ge    end_conversion
    
    // Intercambiar caracteres
    ldrb    w4, [x0, x2]
    ldrb    w5, [x0, x3]
    strb    w5, [x0, x2]
    strb    w4, [x0, x3]
    
    add     w2, w2, #1
    sub     w3, w3, #1
    b       reverse_loop

end_conversion:
    ldp     x19, x20, [sp, 16]
    ldp     x21, x22, [sp, 32]
    ldp     x29, x30, [sp], 48
    ret

// Función para obtener un carácter del resultado
// Entrada: x0 = índice
// Salida: x0 = carácter en esa posición
get_hex_char:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp
    
    adrp    x1, result_length
    add     x1, x1, :lo12:result_length
    ldr     w1, [x1]
    cmp     w0, w1
    b.ge    invalid_index
    
    adrp    x1, hex_array
    add     x1, x1, :lo12:hex_array
    ldrb    w0, [x1, x0]
    
    ldp     x29, x30, [sp], 16
    ret

invalid_index:
    mov     x0, #0
    ldp     x29, x30, [sp], 16
    ret

// Función para obtener la longitud del resultado
get_length:
    adrp    x0, result_length
    add     x0, x0, :lo12:result_length
    ldr     w0, [x0]
    ret
