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
msg_input: .string "Ingrese un número binario: "
msg_output: .string "El número en decimal es: %d\n"
msg_error: .string "Error: Ingrese solo 0s y 1s\n"
formato_str: .string "%s"  
buffer: .space 33        // 32 bits + null terminator
numero: .word 0

.text
.global main
.align 2

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Solicitar número binario
    adr x0, msg_input
    bl printf
    
    // Leer string binario
    adr x0, formato_str
    adr x1, buffer
    bl scanf
    
    // Inicializar registros
    mov w19, #0          // Resultado decimal
    mov w20, #1          // Potencia de 2 actual
    adr x21, buffer      // Puntero al string
    
    // Obtener longitud del string
    mov x22, x21        // Copiar dirección inicial
longitud_loop:
    ldrb w23, [x22]     // Cargar byte actual
    cbz w23, comenzar_conversion  // Si es null, terminar
    add x22, x22, #1    // Siguiente carácter
    b longitud_loop

comenzar_conversion:
    sub x22, x22, #1    // Retroceder al último dígito

conversion_loop:
    cmp x22, x21        // ¿Llegamos al inicio?
    b.lt fin_conversion
    
    // Cargar dígito actual
    ldrb w23, [x22]
    
    // Verificar si es válido (0 o 1)
    cmp w23, #'0'
    b.lt error_input
    cmp w23, #'1'
    b.gt error_input
    
    // Convertir ASCII a valor numérico
    sub w23, w23, #'0'
    
    // Si es 1, sumar la potencia actual
    cbz w23, siguiente_digito
    add w19, w19, w20
    
siguiente_digito:
    lsl w20, w20, #1    // Multiplicar potencia por 2
    sub x22, x22, #1    // Retroceder un dígito
    b conversion_loop

error_input:
    adr x0, msg_error
    bl printf
    b fin_programa

fin_conversion:
    // Mostrar resultado
    adr x0, msg_output
    mov w1, w19
    bl printf
    
fin_programa:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
