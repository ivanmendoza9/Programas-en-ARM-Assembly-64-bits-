/*=========================================================
 * Programa:     grande.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Encuentra el segundo elemento más grande
 *               en un arreglo de enteros. Los parámetros de
 *               entrada son: x0 = puntero al arreglo, 
 *               x1 = tamaño del arreglo.
 * Compilación:  as -o grande.o grande.s
 *               gcc -o grande grande.o
 * Ejecución:    ./grande
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int segundo_mas_grande(int *arr, int tam) {
 *     int max1 = -1, max2 = -1;
 *     for (int i = 0; i < tam; i++) {
 *         if (arr[i] > max1) {
 *             max2 = max1;
 *             max1 = arr[i];
 *         } else if (arr[i] > max2) {
 *             max2 = arr[i];
 *         }
 *     }
 *     return (max2 == -1) ? -1 : max2;
 * }
 * 
 * int main() {
 *     int arreglo[] = {3, 1, 4, 1, 5, 9, 2, 6};
 *     int tam = 8;
 *     int segundo = segundo_mas_grande(arreglo, tam);
 *     printf("El segundo elemento más grande es: %d\n", segundo);
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    msg_menu: 
        .string "\nBúsqueda del Segundo Elemento más Grande\n"
        .string "1. Encontrar segundo mayor\n"
        .string "2. Mostrar arreglo\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_array: .string "Arreglo actual: "
    msg_max: .string "El elemento más grande es: %d\n"
    msg_second: .string "El segundo elemento más grande es: %d\n"
    msg_error: .string "No existe un segundo elemento más grande (todos son iguales)\n"
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Arreglo y variables
    array: .word 12, 35, 1, 10, 34, 1, 35, 8, 23, 19  // Arreglo de ejemplo con 10 elementos
    array_size: .word 10
    opcion: .word 0
    max_num: .word 0
    second_max: .word 0

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
    
    cmp w0, #3
    b.eq fin_programa
    
    cmp w0, #1
    b.eq encontrar_segundo
    
    cmp w0, #2
    b.eq mostrar_arreglo
    
    b menu_loop

encontrar_segundo:
    // Inicializar variables
    adr x20, array        // Dirección base del arreglo
    adr x21, array_size
    ldr w21, [x21]        // Tamaño del arreglo
    
    // Encontrar el máximo primero
    ldr w22, [x20]        // max_num = array[0]
    mov w23, w22          // second_max = array[0]
    mov w24, #1           // índice = 1

encontrar_max_loop:
    ldr w25, [x20, w24, SXTW #2]  // Cargar elemento actual
    
    // Comparar con máximo actual
    cmp w25, w22
    b.le no_es_max       // Si es menor o igual, saltar
    mov w23, w22         // El antiguo máximo se convierte en segundo
    mov w22, w25         // Actualizar máximo
    b continuar_max

no_es_max:
    // Comparar con segundo máximo
    cmp w25, w23
    b.le continuar_max   // Si es menor o igual, saltar
    cmp w25, w22
    b.eq continuar_max   // Si es igual al máximo, saltar
    mov w23, w25         // Actualizar segundo máximo

continuar_max:
    add w24, w24, #1     // Incrementar índice
    cmp w24, w21         // Comparar con tamaño
    b.lt encontrar_max_loop

    // Verificar si encontramos un segundo máximo válido
    cmp w22, w23
    b.eq no_segundo_max

    // Mostrar resultados
    adr x0, msg_max
    mov w1, w22
    bl printf
    
    adr x0, msg_second
    mov w1, w23
    bl printf
    b menu_loop

no_segundo_max:
    adr x0, msg_error
    bl printf
    b menu_loop

mostrar_arreglo:
    adr x0, msg_array
    bl printf
    
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    mov w22, #0          // índice

mostrar_loop:
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    add w22, w22, #1
    cmp w22, w21
    b.lt mostrar_loop
    
    adr x0, msg_newline
    bl printf
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
