/*=======================================================
 * Programa:     operaciones_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Realiza operaciones bit a bit (AND, OR, XOR)
 *               entre dos números enteros y guarda los resultados
 *               en las direcciones proporcionadas.
 * Compilación:  as -o operaciones_bits.o operaciones_bits.s
 *               gcc -o operaciones_bits operaciones_bits.o
 * Ejecución:    ./operaciones_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * void operaciones_bits(int num1, int num2, int* and_result, int* or_result, int* xor_result) {
 *     *and_result = num1 & num2;
 *     *or_result = num1 | num2;
 *     *xor_result = num1 ^ num2;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.global operaciones_bits

.section .text
operaciones_bits:
    // x0 = primer número
    // x1 = segundo número
    // x2 = puntero para resultado AND
    // x3 = puntero para resultado OR
    // x4 = puntero para resultado XOR
    
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    
    // Realizar operación AND
    and x5, x0, x1
    str x5, [x2]    // Guardar resultado AND
    
    // Realizar operación OR
    orr x5, x0, x1
    str x5, [x3]    // Guardar resultado OR
    
    // Realizar operación XOR
    eor x5, x0, x1
    str x5, [x4]    // Guardar resultado XOR
    
    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
