/*==========================================================
 * Programa:     busqueda_lineal.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        9 de noviembre de 2024
 * Descripción:  Realiza una búsqueda lineal en un arreglo de números ingresados
 *               por el usuario. El programa solicita la cantidad de números,
 *               luego los almacena en un arreglo y busca un número específico,
 *               mostrando si lo encuentra y en qué posición.
 *
 * Compilación:  as -o busqueda_lineal.o busqueda_lineal.s
 *               gcc -o busqueda_lineal busqueda_lineal.o -no-pie -lc
 * Ejecución:    ./busqueda_lineal
 *
 * Sistema objetivo: Raspberry Pi 5 con Raspbian OS 64-bit
 * Ensamblador: as (GNU assembler), ld (GNU linker)
 * Depurador: gdb con GEF
 * ----------------------------------------------------------
 * Solución en C:
 * ----------------------------------------------------------
 * #include <stdio.h>
 *
 * int busqueda_lineal(int array[], int size, int valor) {
 *     for (int i = 0; i < size; i++) {
 *         if (array[i] == valor) {
 *             return i;
 *         }
 *     }
 *     return -1;
 * }
 *
 * int main() {
 *     int array[100], size, num, buscar, pos;
 *
 *     printf("Ingrese la cantidad de números: ");
 *     scanf("%d", &size);
 *
 *     for (int i = 0; i < size; i++) {
 *         printf("Ingrese el número %d: ", i + 1);
 *         scanf("%d", &num);
 *         array[i] = num;
 *     }
 *
 *     printf("Ingrese el número a buscar: ");
 *     scanf("%d", &buscar);
 *
 *     pos = busqueda_lineal(array, size, buscar);
 *     if (pos != -1) {
 *         printf("El número %d se encontró en la posición %d\n", buscar, pos);
 *     } else {
 *         printf("El número %d no se encontró en el arreglo\n", buscar);
 *     }
 *
 *     return 0;
 * }
 * ----------------------------------------------------------
 ==========================================================*/

.section .data
    msg_cant:     .string "Ingrese la cantidad de números: "
    msg_input:    .string "Ingrese el número %d: "
    msg_search:   .string "Ingrese el número a buscar: "
    msg_found:    .string "El número %d se encontró en la posición %d\n"
    msg_notfound: .string "El número %d no se encontró en el arreglo\n"
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

    // Pedir cantidad de números
    adrp x0, msg_cant
    add x0, x0, :lo12:msg_cant
    bl printf

    // Leer cantidad
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf
    ldr w20, [sp]    // w20 = cantidad de números
    add sp, sp, #16

    // Inicializar variables
    adrp x19, array
    add x19, x19, :lo12:array
    mov w21, #0      // Contador para el bucle

input_loop:
    // Imprimir mensaje de entrada
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    add w1, w21, #1
    bl printf

    // Leer número
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf
    
    // Guardar número en el arreglo
    ldr w22, [sp]
    str w22, [x19, x21, lsl #2]   // Almacenar número en el arreglo
    add sp, sp, #16
    
    // Incrementar contador y verificar si terminamos
    add w21, w21, #1
    cmp w21, w20
    b.lt input_loop

    // Pedir número a buscar
    adrp x0, msg_search
    add x0, x0, :lo12:msg_search
    bl printf

    // Leer número a buscar
    sub sp, sp, #16
    mov x1, sp
    adrp x0, fmt_input
    add x0, x0, :lo12:fmt_input
    bl scanf
    ldr w22, [sp]    // w22 = número a buscar
    add sp, sp, #16

    // Llamar a búsqueda lineal
    mov x0, x19      // Dirección del arreglo
    mov w1, w20      // Tamaño del arreglo
    mov w2, w22      // Valor a buscar
    bl busqueda_lineal

    // Verificar resultado y mostrar
    cmp w0, #-1
    b.eq not_found

    // Número encontrado
    adrp x0, msg_found
    add x0, x0, :lo12:msg_found
    mov w1, w22      // Número buscado
    mov w2, w0       // Posición donde se encontró
    bl printf
    b end

not_found:
    // Número no encontrado
    adrp x0, msg_notfound
    add x0, x0, :lo12:msg_notfound
    mov w1, w22      // Número buscado
    bl printf

end:
    // Epílogo y retorno
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función de búsqueda lineal
// Parámetros: x0 = arreglo, x1 = tamaño, w2 = valor a buscar
// Retorno: w0 = índice (-1 si no se encuentra)
busqueda_lineal:
    mov x4, x0              // Guardar puntero al arreglo
    mov w5, #0              // Inicializar índice en 0
    
buscar_loop:
    cbz x1, no_encontrado   // Si no quedan elementos, no se encontró
    
    ldr w3, [x4]           // Cargar elemento actual
    cmp w3, w2             // Comparar con valor buscado
    b.eq encontrado        // Si es igual, encontramos el valor
    
    add x4, x4, #4         // Avanzar al siguiente elemento
    add w5, w5, #1         // Incrementar índice
    sub x1, x1, #1         // Decrementar contador
    b buscar_loop          // Continuar búsqueda
    
no_encontrado:
    mov w0, #-1            // Retornar -1 (no encontrado)
    ret
    
encontrado:
    mov w0, w5             // Retornar índice donde se encontró
    ret
