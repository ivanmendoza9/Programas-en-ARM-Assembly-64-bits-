/*=========================================================
 * Programa:     binary_to_decimal.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número binario 
 *               representado como un string en decimal, con manejo de errores.
 * Compilación:  as -o binary_to_decimal.o binary_to_decimal.s
 *               gcc -o binary_to_decimal binary_to_decimal.o
 * Ejecución:    ./binary_to_decimal
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int error_flag = 0;
 * 
 * int binary_to_decimal(const char *binary_str) {
 *     int decimal = 0;
 *     int power_of_2 = 1;
 *     int i = 0;
 *     while (binary_str[i] != '\0') {
 *         if (binary_str[i] != '0' && binary_str[i] != '1') {
 *             error_flag = 1;
 *             return -1;
 *         }
 *         if (binary_str[i] == '1') {
 *             decimal += power_of_2;
 *         }
 *         power_of_2 *= 2;
 *         i++;
 *     }
 *     return decimal;
 * }
 * 
 * void clear_error() {
 *     error_flag = 0;
 * }
 * 
 * int get_error() {
 *     return error_flag;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    .align 3
    error_flag: .word 0        // Flag para indicar error en la entrada

.text
.align 2
.global binary_to_decimal
.global get_error
.global clear_error

// Función para convertir binario a decimal
// Entrada: x0 = dirección del string binario
// Salida: x0 = número decimal resultante
binary_to_decimal:
    stp     x29, x30, [sp, -48]!
    mov     x29, sp
    stp     x19, x20, [sp, 16]     // Guardar registros que usaremos
    stp     x21, x22, [sp, 32]

    // Inicializar registros
    mov     x19, x0                 // Guardar dirección del string
    mov     x20, #0                 // Resultado decimal
    mov     x21, #0                 // Índice actual
    mov     x22, #1                 // Valor de potencia de 2

    // Limpiar flag de error
    bl      clear_error

validate_loop:
    // Cargar carácter actual
    ldrb    w0, [x19, x21]
    
    // Si es null (fin del string), terminar validación
    cbz     w0, start_conversion
    
    // Verificar si es '0' o '1'
    cmp     w0, #'0'
    b.lt    invalid_input
    cmp     w0, #'1'
    b.gt    invalid_input
    
    // Siguiente carácter
    add     x21, x21, #1
    b       validate_loop

invalid_input:
    // Marcar error y retornar
    bl      set_error
    mov     x0, #-1
    b       end_conversion

start_conversion:
    // x21 ahora tiene la longitud del string
    mov     x22, #1                 // Reiniciar potencia de 2
    mov     x20, #0                 // Reiniciar resultado
    
convert_loop:
    // Si ya procesamos todos los dígitos, terminar
    cbz     x21, end_conversion
    
    // Decrementar índice para procesar desde el último dígito
    sub     x21, x21, #1
    
    // Cargar dígito actual
    ldrb    w0, [x19, x21]
    
    // Si es '1', sumar la potencia actual
    cmp     w0, #'1'
    b.ne    next_digit
    
    // Sumar potencia actual al resultado
    add     x20, x20, x22
    
next_digit:
    // Multiplicar potencia por 2
    lsl     x22, x22, #1
    b       convert_loop

end_conversion:
    mov     x0, x20                 // Mover resultado a x0
    
    // Restaurar registros
    ldp     x19, x20, [sp, 16]
    ldp     x21, x22, [sp, 32]
    ldp     x29, x30, [sp], 48
    ret

// Función para establecer error
set_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    mov     w1, #1
    str     w1, [x0]
    ret

// Función para limpiar error
clear_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    str     wzr, [x0]
    ret

// Función para obtener estado de error
get_error:
    adrp    x0, error_flag
    add     x0, x0, :lo12:error_flag
    ldr     w0, [x0]
    ret
