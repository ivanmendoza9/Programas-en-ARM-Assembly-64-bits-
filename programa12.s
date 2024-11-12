/*==========================================================
 * Programa:     maximo_array.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        9 de noviembre de 2024
 * Descripción:  Encuentra el valor máximo en un arreglo de números ingresados por el usuario.
 *               El programa finaliza cuando se ingresa el valor 0.
 *
 * Compilación:  as -o maximo_array.o maximo_array.s
 *               gcc -o maximo_array maximo_array.o -no-pie -lc
 * Ejecución:    ./maximo_array
 *
 * Sistema objetivo: Raspberry Pi 5 con Raspbian OS 64-bit
 * Ensamblador: as (GNU assembler), ld (GNU linker)
 * Depurador: gdb con GEF
 * LINK ASCIINEMA: https://asciinema.org/a/yLn7dEpdosAajPugw6SRQXLxc
 * ----------------------------------------------------------
 * Solución en C:
 * ----------------------------------------------------------
 * #include <stdio.h>
 *
 * int encontrar_maximo(int array[], int size) {
 *     int max = array[0];
 *     for (int i = 1; i < size; i++) {
 *         if (array[i] > max) {
 *             max = array[i];
 *         }
 *     }
 *     return max;
 * }
 *
 * int main() {
 *     int array[100], size = 0, num;
 *
 *     while (1) {
 *         printf("Ingrese un número (0 para terminar): ");
 *         scanf("%d", &num);
 *         if (num == 0) break;
 *         array[size++] = num;
 *     }
 *
 *     if (size > 0) {
 *         int max = encontrar_maximo(array, size);
 *         printf("El máximo es: %d\n", max);
 *     }
 *     return 0;
 * }
 * ----------------------------------------------------------
 ==========================================================*/

.section .data
    msg_input:    .string "Ingrese un número (0 para terminar): "
    msg_result:   .string "El máximo es: %d\n"
    fmt_input:    .string "%d"
    .align 4
    array:        .skip 400    // Espacio para 100 números
    size:         .word 0      // Tamaño actual del arreglo

.section .text
.global main
.extern printf
.extern scanf

main:
    // Prólogo
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Inicializar variables
    adrp x19, array
    add x19, x19, :lo12:array  // Dirección base del arreglo
    mov x20, #0              // Contador de elementos

input_loop:
    // Imprimir mensaje de entrada
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Leer número
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf

    // Cargar número ingresado
    ldr w21, [sp]
    add sp, sp, #16

    // Verificar si es 0 (terminar)
    cbz w21, find_max

    // Guardar número en el arreglo
    str w21, [x19, x20, lsl #2]
    add x20, x20, #1
    
    // Continuar si no hemos llegado al límite
    cmp x20, #100
    b.lt input_loop

find_max:
    // Verificar si hay elementos
    cbz x20, end

    // Llamar a encontrar_maximo
    mov x0, x19              // Dirección del arreglo
    mov x1, x20              // Número de elementos
    bl encontrar_maximo

    // Imprimir resultado
    mov x1, x0
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    bl printf

end:
    // Epílogo y retorno
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para encontrar el máximo en un arreglo
// Parámetros: x0 = puntero al arreglo, x1 = número de elementos
// Retorno: x0 = valor máximo
encontrar_maximo:
    cbz x1, max_fin          // Si no hay elementos, retornar
    
    ldr w2, [x0]            // Primer elemento como máximo inicial
    mov x4, x0              // Guardar puntero
    mov x3, x1              // Copiar contador
    
max_loop:
    ldr w5, [x4, #4]!       // Cargar siguiente elemento
    cmp w5, w2              // Comparar con máximo actual
    csel w2, w5, w2, gt     // Seleccionar el mayor
    
    subs x3, x3, #1         // Decrementar contador
    cbnz x3, max_loop       // Continuar si no terminamos
    
max_fin:
    mov w0, w2              // Retornar máximo
    ret
