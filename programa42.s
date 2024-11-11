/*=========================================================
 * Programa:     hexa.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Convierte un carácter hexadecimal ('0'-'9', 'A'-'F', 'a'-'f') 
 *               a su valor decimal correspondiente.
 * Compilación:  as -o hexa.o hexa.s
 *               gcc -o hexa hexa.o
 * Ejecución:    ./hexa
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * int hex_char_to_dec(char hex_char) {
 *     if (hex_char >= '0' && hex_char <= '9') {
 *         return hex_char - '0';  // Para '0' a '9'
 *     }
 *     if (hex_char >= 'A' && hex_char <= 'F') {
 *         return hex_char - 'A' + 10;  // Para 'A' a 'F'
 *     }
 *     if (hex_char >= 'a' && hex_char <= 'f') {
 *         return hex_char - 'a' + 10;  // Para 'a' a 'f'
 *     }
 *     return -1;  // Si no es un carácter hexadecimal válido
 * }
 * ---------------------------------------------------------
 =========================================================*/

.global hex_char_to_dec

// Convierte un carácter hexadecimal a decimal
// Entrada: w0 (carácter hexadecimal, como 'A' o 'F')
// Salida: w0 (valor decimal)
hex_char_to_dec:
    cmp w0, '0'
    blt invalid_hex               // Si es menor que '0', no es hexadecimal
    cmp w0, '9'
    ble convert_digit             // Si está entre '0' y '9', es dígito decimal

    cmp w0, 'A'
    blt invalid_hex               // Si es menor que 'A', no es hexadecimal
    cmp w0, 'F'
    ble convert_upper_letter      // Si está entre 'A' y 'F', es letra mayúscula

    cmp w0, 'a'
    blt invalid_hex               // Si es menor que 'a', no es hexadecimal
    cmp w0, 'f'
    ble convert_lower_letter      // Si está entre 'a' y 'f', es letra minúscula

invalid_hex:
    mov w0, -1                    // Retornar -1 si no es válido
    ret

convert_digit:
    sub w0, w0, '0'               // Convertir '0'-'9' a 0-9
    ret

convert_upper_letter:
    sub w0, w0, 'A'               // Convertir 'A'-'F' a 10-15
    add w0, w0, 10
    ret

convert_lower_letter:
    sub w0, w0, 'a'               // Convertir 'a'-'f' a 10-15
    add w0, w0, 10
    ret
