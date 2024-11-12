/*==========================================================
 * Programa:     minimo_array.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        9 de noviembre de 2024
 * Descripción:  Encuentra el valor mínimo en un arreglo de números ingresados por el usuario.
 *               El programa finaliza cuando se ingresa el valor 0.
 * Link ASCII: https://asciinema.org/a/JN35i70vSkGp7OUTmsOOXjN9u
 *
 * Compilación:  as -o minimo_array.o minimo_array.s
 *               gcc -o minimo_array minimo_array.o -no-pie -lc
 * Ejecución:    ./minimo_array
 *
 * Sistema objetivo: Raspberry Pi 5 con Raspbian OS 64-bit
 * Ensamblador: as (GNU assembler), ld (GNU linker)
 * Depurador: gdb con GEF
 * ----------------------------------------------------------
 * Solución en C:
 * ----------------------------------------------------------
 * #include <stdio.h>
 *
 * int encontrar_minimo(int array[], int size) {
 *     int min = array[0];
 *     for (int i = 1; i < size; i++) {
 *         if (array[i] < min) {
 *             min = array[i];
 *         }
 *     }
 *     return min;
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
 *         int min = encontrar_minimo(array, size);
 *         printf("El mínimo es: %d\n", min);
 *     }
 *     return 0;
 * }
 * ----------------------------------------------------------
 ==========================================================*/

.section .data
    msg_input:    .string "Ingrese un número (0 para terminar): "
    msg_result:   .string "El mínimo es: %d\n"
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
    add x19, x19, :lo12:array  // Obtener dirección base del arreglo
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
    cbz w21, find_min

    // Guardar número en el arreglo
    str w21, [x19, x20, lsl #2]
    add x20, x20, #1
    
    // Continuar si no hemos llegado al límite
    cmp x20, #100
    b.lt input_loop

find_min:
    // Verificar si hay elementos
    cbz x20, end

    // Llamar a encontrar_minimo
    mov x0, x19              // Dirección del arreglo
    mov x1, x20              // Número de elementos
    bl encontrar_minimo

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

// Función para encontrar el mínimo en un arreglo
// Parámetros: x0 = puntero al arreglo, x1 = número de elementos
// Retorno: x0 = valor mínimo
encontrar_minimo:
    // Verificar si hay elementos
    cbz x1, min_fin         // Si no hay elementos, retornar
    
    ldr w2, [x0]           // Primer elemento como mínimo inicial
    mov x4, x0             // Guardar puntero original
    mov x3, x1             // Copiar contador
    sub x3, x3, #1         // Ajustar contador para el bucle
    
min_loop:
    cbz x3, min_fin        // Si no hay más elementos, terminar
    
    ldr w5, [x4, #4]!      // Cargar siguiente elemento
    cmp w5, w2             // Comparar con mínimo actual
    csel w2, w5, w2, lt    // Seleccionar el menor
    
    subs x3, x3, #1        // Decrementar contador
    b.ne min_loop          // Continuar si no hemos terminado
    
min_fin:
    mov w0, w2             // Retornar mínimo
    ret
