/*=========================================================
 * Programa:     operacion_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa operaciones de establecer, borrar
 *               y alternar un bit en una posición específica
 *               de un número en ensamblador ARM64.
 * Compilación:  as -o operacion_bits.o operacion_bits.s
 *               gcc -o operacion_bits operacion_bits.o
 * Ejecución:    ./operacion_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Establecer un bit en la posición 'n'
 * void establecer_bit(unsigned int *valor, int n) {
 *     *valor |= (1 << n);
 * }
 * 
 * // Borrar un bit en la posición 'n'
 * void borrar_bit(unsigned int *valor, int n) {
 *     *valor &= ~(1 << n);
 * }
 * 
 * // Alternar un bit en la posición 'n'
 * void alternar_bit(unsigned int *valor, int n) {
 *     *valor ^= (1 << n);
 * }
 * 
 * int main() {
 *     unsigned int numero = 29;  // Ejemplo de número
 *     int posicion = 3;          // Ejemplo de posición de bit
 *     
 *     printf("Valor original: %u\n", numero);
 *     
 *     establecer_bit(&numero, posicion);
 *     printf("Después de establecer el bit: %u\n", numero);
 *     
 *     borrar_bit(&numero, posicion);
 *     printf("Después de borrar el bit: %u\n", numero);
 *     
 *     alternar_bit(&numero, posicion);
 *     printf("Después de alternar el bit: %u\n", numero);
 *     
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_menu:       .string "\nManipulación de bits\n"
                .string "1. Establecer bit (SET)\n"
                .string "2. Borrar bit (CLEAR)\n"
                .string "3. Alternar bit (TOGGLE)\n"
                .string "4. Salir\n"
                .string "Seleccione una opción: "

msg_num:        .string "Ingrese el número: "
msg_pos:        .string "Ingrese la posición del bit (0-31): "
msg_resultado:  .string "Resultado: %d\n"
msg_binario:    .string "En binario: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

opcion:         .word 0
numero:         .word 0
posicion:       .word 0

    .text
    .global main
    .align 2

main:
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

menu_loop:
    // Mostrar menú
    adr     x0, msg_menu
    bl      printf

    // Leer opción
    adr     x0, formato_int
    adr     x1, opcion
    bl      scanf

    // Verificar salida
    adr     x0, opcion
    ldr     w0, [x0]
    cmp     w0, #4
    b.eq    fin_programa

    // Leer número
    adr     x0, msg_num
    bl      printf
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Leer posición
    adr     x0, msg_pos
    bl      printf
    adr     x0, formato_int
    adr     x1, posicion
    bl      scanf

    // Cargar valores
    adr     x0, numero
    ldr     w1, [x0]        // Número original
    adr     x0, posicion
    ldr     w2, [x0]        // Posición
    adr     x0, opcion
    ldr     w0, [x0]        // Opción

    // Seleccionar operación
    cmp     w0, #1
    b.eq    set_bit
    cmp     w0, #2
    b.eq    clear_bit
    cmp     w0, #3
    b.eq    toggle_bit
    b       menu_loop

set_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    orr     w1, w1, w3      // OR con la máscara
    b       mostrar_resultado

clear_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    mvn     w3, w3          // Invertir bits
    and     w1, w1, w3      // AND con la máscara
    b       mostrar_resultado

toggle_bit:
    mov     w3, #1          // Crear máscara
    lsl     w3, w3, w2      // Desplazar 1 a la posición
    eor     w1, w1, w3      // XOR con la máscara

mostrar_resultado:
    // Guardar resultado
    mov     w19, w1

    // Mostrar en decimal
    adr     x0, msg_resultado
    bl      printf

    // Mostrar en binario
    adr     x0, msg_binario
    bl      printf

    mov     w20, #32
mostrar_bits:
    sub     w20, w20, #1
    lsr     w21, w19, w20
    and     w1, w21, #1
    adr     x0, msg_bit
    bl      printf

    cmp     w20, #0
    b.ne    mostrar_bits

    adr     x0, msg_newline
    bl      printf

    b       menu_loop

fin_programa:
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
