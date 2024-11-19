/*=========================================================
 * Programa:     decimal_to_binary.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número decimal
 *               a binario, obtener un bit específico y obtener el tamaño del 
 *               resultado binario.
 * Compilación:  as -o decimal_to_binary.o decimal_to_binary.s
 *               gcc -o decimal_to_binary decimal_to_binary.o
 * Ejecución:    ./decimal_to_binary
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * #define BINARY_SIZE 64
 * char binary_array[BINARY_SIZE];
 * int result_size = 0;
 * 
 * void decimal_to_binary(long num) {
 *     result_size = 0;
 *     if (num == 0) {
 *         binary_array[0] = '0';
 *         result_size = 1;
 *         return;
 *     }
 *     int i = 0;
 *     while (num > 0) {
 *         binary_array[i++] = (num & 1) + '0';
 *         num >>= 1;
 *     }
 *     result_size = i;
 * }
 * 
 * char get_bit(int index) {
 *     if (index < 0 || index >= result_size) return -1;
 *     return binary_array[index];
 * }
 * 
 * int get_size() {
 *     return result_size;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    msg_menu: 
        .string "\nConversor Decimal a Binario\n"
        .string "1. Convertir número\n"
        .string "2. Salir\n"
        .string "Seleccione una opción: "
    
    msg_input: .string "Ingrese un número decimal (positivo): "
    msg_result: .string "El número %d en binario es: "
    msg_negative: .string "Por favor ingrese un número positivo\n"
    msg_bit: .string "%d"
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Variables
    opcion: .word 0
    numero: .word 0
    binary: .skip 32     // Arreglo para almacenar bits (32 bits máximo)
    binary_size: .word 0

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

menu_loop:
    // Mostrar menú
    adr x0, msg_menu
    bl printf

    // Leer opción
    adr x0, formato_int
    adr x1, opcion
    bl scanf

    // Verificar opción
    adr x0, opcion
    ldr w0, [x0]
    
    cmp w0, #2
    b.eq fin_programa
    
    cmp w0, #1
    b.eq convertir_numero
    
    b menu_loop

convertir_numero:
    // Solicitar número
    adr x0, msg_input
    bl printf
    
    // Leer número
    adr x0, formato_int
    adr x1, numero
    bl scanf
    
    // Verificar si es positivo
    adr x0, numero
    ldr w0, [x0]
    cmp w0, #0
    b.lt numero_negativo
    
    // Preparar para conversión
    mov w19, w0          // Guardar número original
    adr x20, binary      // Dirección del arreglo de bits
    mov w21, #0          // Contador de bits
    
    // Si el número es 0, manejo especial
    cmp w19, #0
    b.eq caso_cero

conversion_loop:
    // Verificar si el número es 0
    cmp w19, #0
    b.eq mostrar_resultado
    
    // Obtener bit actual (número & 1)
    and w22, w19, #1
    
    // Guardar bit en el arreglo
    str w22, [x20, w21, SXTW #2]
    
    // Incrementar contador
    add w21, w21, #1
    
    // Dividir número por 2 (shift right)
    lsr w19, w19, #1
    
    b conversion_loop

caso_cero:
    mov w22, #0
    str w22, [x20]
    mov w21, #1
    b mostrar_resultado

mostrar_resultado:
    // Guardar tamaño del binario
    adr x22, binary_size
    str w21, [x22]
    
    // Mostrar mensaje inicial
    adr x0, msg_result
    adr x1, numero
    ldr w1, [x1]
    bl printf
    
    // Mostrar bits en orden inverso
    sub w21, w21, #1     // Índice del último bit
    
mostrar_bits:
    ldr w1, [x20, w21, SXTW #2]
    adr x0, msg_bit
    bl printf
    
    sub w21, w21, #1
    cmp w21, #-1
    b.ge mostrar_bits
    
    // Nueva línea
    adr x0, msg_newline
    bl printf
    
    b menu_loop

numero_negativo:
    adr x0, msg_negative
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
