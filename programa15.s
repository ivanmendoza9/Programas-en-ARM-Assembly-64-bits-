/*=======================================================
 * Programa:     busqueda_binaria.s
 * Autor:        IVAN MENDOZA
 * Fecha:        09 de noviembre de 2024
 * Descripción:  Implementa la búsqueda binaria en ensamblador ARM64 
 *               para encontrar el índice de un valor en un arreglo 
 *               ordenado. Si el valor no está presente, devuelve -1.
 * Compilación:  as -o busqueda_binaria.o busqueda_binaria.s
 *               gcc -o busqueda_binaria busqueda_binaria.o
 * Ejecución:    ./busqueda_binaria
 * Versión:      1.0
 * Link ASCIINEMA: 
 * Link DEBUG: 
 * Código equivalente en c:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int busqueda_binaria(int arr[], int n, int valor) {
 *     int izquierda = 0, derecha = n - 1;
 *     while (izquierda <= derecha) {
 *         int medio = (izquierda + derecha) / 2;
 *         if (arr[medio] == valor)
 *             return medio;
 *         else if (arr[medio] < valor)
 *             izquierda = medio + 1;
 *         else
 *             derecha = medio - 1;
 *     }
 *     return -1;
 * }
 * int main() {
 *     int arr[] = {1, 3, 5, 7, 9};
 *     int n = sizeof(arr) / sizeof(arr[0]);
 *     int valor = 5;
 *     int resultado = busqueda_binaria(arr, n, valor);
 *     printf("Índice: %d\n", resultado);
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

.section .data
    // Mensajes para interactuar con el usuario
    msg_cant:     .string "Ingrese la cantidad de números: "
    msg_input:    .string "Ingrese el número %d: "
    msg_search:   .string "Ingrese el número a buscar: "
    msg_found:    .string "El número %d se encontró en la posición %d\n"
    msg_notfound: .string "El número %d no se encontró en el arreglo\n"
    fmt_input:    .string "%d"
    
    // Arreglo para almacenar números
    .align 4
    array:      .skip 400    // Espacio para 100 números
    size:       .word 0      // Tamaño actual del arreglo

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
    str w22, [x19, x21, lsl #2]   // Cambié w21 por x21 para el desplazamiento
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
    mov w1, w20      // Tamaño del arreglo (cambiado a 32 bits)
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

// Función de búsqueda lineal mejorada
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
