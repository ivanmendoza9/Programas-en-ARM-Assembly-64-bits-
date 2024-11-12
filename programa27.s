/*=========================================================
 * Programa:     desplazar_bits.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa operaciones de desplazamiento a la izquierda
 *               y a la derecha de un número en ensamblador ARM64.
 * Compilación:  as -o desplazar_bits.o desplazar_bits.s
 *               gcc -o desplazar_bits desplazar_bits.o
 * Ejecución:    ./desplazar_bits
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * void desplazar_izquierda(long int num, int desplazamiento) {
 *     num <<= desplazamiento;  // Desplazamiento a la izquierda
 *     printf("Desplazamiento a la izquierda: %ld\n", num);
 * }
 * 
 * void desplazar_derecha(long int num, int desplazamiento) {
 *     num >>= desplazamiento;  // Desplazamiento a la derecha
 *     printf("Desplazamiento a la derecha: %ld\n", num);
 * }
 * 
 * int main() {
 *     long int numero = 16;  // Ejemplo de número
 *     int desplazamiento = 2;  // Ejemplo de desplazamiento
 *     
 *     desplazar_izquierda(numero, desplazamiento);  // Llamada a desplazamiento a la izquierda
 *     desplazar_derecha(numero, desplazamiento);    // Llamada a desplazamiento a la derecha
 *     
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_menu:       .string "\nDesplazamientos de bits\n"
                .string "1. Desplazamiento a la izquierda (LSL)\n"
                .string "2. Desplazamiento a la derecha (LSR)\n"
                .string "3. Salir\n"
                .string "Seleccione una opción: "

msg_num:        .string "Ingrese el número: "
msg_pos:        .string "Ingrese posiciones a desplazar: "
msg_resultado:  .string "Resultado: %d\n"
msg_binario:    .string "En binario: "
msg_bit:        .string "%d"
msg_newline:    .string "\n"
formato_int:    .string "%d"

opcion:         .word 0
numero:         .word 0
posiciones:     .word 0

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
    cmp     w0, #3
    b.eq    fin_programa

    // Leer número
    adr     x0, msg_num
    bl      printf
    adr     x0, formato_int
    adr     x1, numero
    bl      scanf

    // Leer posiciones
    adr     x0, msg_pos
    bl      printf
    adr     x0, formato_int
    adr     x1, posiciones
    bl      scanf

    // Cargar valores
    adr     x0, numero
    ldr     w1, [x0]
    adr     x0, posiciones
    ldr     w2, [x0]
    adr     x0, opcion
    ldr     w0, [x0]

    // Seleccionar operación
    cmp     w0, #1
    b.eq    shift_left
    cmp     w0, #2
    b.eq    shift_right
    b       menu_loop

shift_left:
    lsl     w1, w1, w2
    b       mostrar_resultado

shift_right:
    lsr     w1, w1, w2

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
