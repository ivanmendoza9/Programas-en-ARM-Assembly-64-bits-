/*=========================================================
 * Programa:     invertir.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Invierte los elementos de un arreglo de enteros
 *               de 64 bits. El puntero al arreglo se pasa en x0
 *               y el tamaño del arreglo se pasa en x1. El
 *               resultado se almacena en el mismo arreglo.
 * Compilación:  as -o invertir.o invertir.s
 *               gcc -o invertir invertir.o
 * Ejecución:    ./invertir
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para invertir los elementos de un arreglo
 * void invertir_arreglo(long *arr, int tam) {
 *     long temp;
 *     for (int i = 0; i < tam / 2; i++) {
 *         temp = arr[i];
 *         arr[i] = arr[tam - i - 1];
 *         arr[tam - i - 1] = temp;
 *     }
 * }
 * 
 * int main() {
 *     long arreglo[] = {10, 20, 30, 40, 50};  // Ejemplo de arreglo
 *     int tam = 5;                            // Tamaño del arreglo
 *     invertir_arreglo(arreglo, tam);
 *     for (int i = 0; i < tam; i++) {
 *         printf("%ld ", arreglo[i]);
 *     }
 *     printf("\n");
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    // Mensajes del menú
    msg_menu: 
        .string "\nOperaciones con Arreglos\n"
        .string "1. Sumar elementos del arreglo\n"
        .string "2. Invertir arreglo\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_resultado: .string "Resultado de la suma: %d\n"
    msg_array: .string "Arreglo: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Arreglo de ejemplo y variables
    array: .word 1, 2, 3, 4, 5  // Arreglo de 5 elementos
    array_size: .word 5
    opcion: .word 0
    suma: .word 0

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
    b.eq sumar_array
    
    cmp w0, #2
    b.eq invertir_array
    
    b menu_loop

sumar_array:
    // Inicializar suma en 0
    mov w19, #0
    
    // Cargar dirección base del array y tamaño
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    mov w22, #0  // índice
    
suma_loop:
    // Sumar elemento actual
    ldr w23, [x20, w22, SXTW #2]
    add w19, w19, w23
    
    // Incrementar índice
    add w22, w22, #1
    
    // Verificar si terminamos
    cmp w22, w21
    b.lt suma_loop
    
    // Mostrar resultado
    adr x0, msg_resultado
    mov w1, w19
    bl printf
    
    b menu_loop

invertir_array:
    // Cargar dirección base y tamaño
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    
    // Inicializar índices
    mov w22, #0  // inicio
    sub w23, w21, #1  // fin
    
invertir_loop:
    // Verificar si terminamos
    cmp w22, w23
    b.ge mostrar_array
    
    // Intercambiar elementos
    ldr w24, [x20, w22, SXTW #2]  // temp1
    ldr w25, [x20, w23, SXTW #2]  // temp2
    
    str w25, [x20, w22, SXTW #2]
    str w24, [x20, w23, SXTW #2]
    
    // Actualizar índices
    add w22, w22, #1
    sub w23, w23, #1
    
    b invertir_loop

mostrar_array:
    // Mostrar mensaje
    adr x0, msg_array
    bl printf
    
    // Inicializar índice
    mov w22, #0
    
mostrar_loop:
    // Mostrar elemento actual
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    // Incrementar índice
    add w22, w22, #1
    
    // Verificar si terminamos
    cmp w22, w21
    b.lt mostrar_loop
    
    // Nueva línea
    adr x0, msg_newline
    bl printf
    
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
