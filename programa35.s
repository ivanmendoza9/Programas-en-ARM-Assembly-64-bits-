/*=========================================================
 * Programa:     rotacion.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Rota los elementos de un arreglo a la izquierda
 *               o a la derecha. Los parámetros de entrada son:
 *               x0 = puntero al arreglo, x1 = tamaño del arreglo
 *               x2 = número de posiciones a rotar, x3 = dirección
 *               (0 = izquierda, 1 = derecha).
 * Compilación:  as -o rotacion.o rotacion.s
 *               gcc -o rotacion rotacion.o
 * Ejecución:    ./rotacion
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función que rota un arreglo
 * void rotar_arreglo(int *arr, int tam, int posiciones, int direccion) {
 *     if (tam == 0 || posiciones == 0) return;
 *     posiciones %= tam;  // Ajustar el número de rotaciones
 *     if (direccion == 0) {  // Rotación a la izquierda
 *         for (int i = 0; i < posiciones; i++) {
 *             int temp = arr[0];
 *             for (int j = 0; j < tam - 1; j++) {
 *                 arr[j] = arr[j + 1];
 *             }
 *             arr[tam - 1] = temp;
 *         }
 *     } else {  // Rotación a la derecha
 *         for (int i = 0; i < posiciones; i++) {
 *             int temp = arr[tam - 1];
 *             for (int j = tam - 1; j > 0; j--) {
 *                 arr[j] = arr[j - 1];
 *             }
 *             arr[0] = temp;
 *         }
 *     }
 * }
 * 
 * int main() {
 *     int arreglo[] = {1, 2, 3, 4, 5};  // Ejemplo de arreglo
 *     int tam = 5;                      // Tamaño del arreglo
 *     rotar_arreglo(arreglo, tam, 2, 0); // Rotar 2 posiciones a la izquierda
 *     for (int i = 0; i < tam; i++) {
 *         printf("%d ", arreglo[i]);
 *     }
 *     printf("\n");
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.data
    // Mensajes del menú
    msg_menu: 
        .string "\nRotación de Arreglos\n"
        .string "1. Rotar a la izquierda\n"
        .string "2. Rotar a la derecha\n"
        .string "3. Salir\n"
        .string "Seleccione una opción: "
    
    msg_pos: .string "Ingrese posiciones a rotar: "
    msg_array: .string "Arreglo: "
    msg_resultado: .string "Resultado: "
    msg_num: .string "%d "
    msg_newline: .string "\n"
    formato_int: .string "%d"
    
    // Arreglo y variables
    array: .word 1, 2, 3, 4, 5  // Arreglo de ejemplo
    temp_array: .skip 20        // Arreglo temporal (5 elementos * 4 bytes)
    array_size: .word 5
    opcion: .word 0
    posiciones: .word 0

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

    // Verificar salida
    adr x0, opcion
    ldr w0, [x0]
    cmp w0, #3
    b.eq fin_programa

    // Leer posiciones a rotar
    adr x0, msg_pos
    bl printf
    adr x0, formato_int
    adr x1, posiciones
    bl scanf

    // Mostrar arreglo original
    adr x0, msg_array
    bl printf
    bl mostrar_array

    // Seleccionar operación
    adr x0, opcion
    ldr w0, [x0]
    cmp w0, #1
    b.eq rotar_izquierda
    cmp w0, #2
    b.eq rotar_derecha
    b menu_loop

rotar_izquierda:
    // Cargar valores necesarios
    adr x20, array
    adr x21, temp_array
    adr x22, array_size
    ldr w22, [x22]         // Tamaño del arreglo
    adr x23, posiciones
    ldr w23, [x23]        // Posiciones a rotar
    
    // Normalizar posiciones
    sdiv w24, w23, w22    // División
    mul w24, w24, w22     // Multiplicación
    sub w23, w23, w24     // Módulo
    
    // Copiar elementos al arreglo temporal
    mov w24, #0           // Índice
copiar_izq_loop:
    ldr w25, [x20, w24, SXTW #2]
    str w25, [x21, w24, SXTW #2]
    add w24, w24, #1
    cmp w24, w22
    b.lt copiar_izq_loop
    
    // Realizar rotación
    mov w24, #0           // Índice destino
rotar_izq_loop:
    add w25, w24, w23     // Índice origen = (i + k) % n
    sdiv w26, w25, w22    // División
    mul w26, w26, w22     // Multiplicación
    sub w25, w25, w26     // Módulo
    
    ldr w27, [x21, w25, SXTW #2]
    str w27, [x20, w24, SXTW #2]
    
    add w24, w24, #1
    cmp w24, w22
    b.lt rotar_izq_loop
    
    b mostrar_resultado

rotar_derecha:
    // Cargar valores necesarios
    adr x20, array
    adr x21, temp_array
    adr x22, array_size
    ldr w22, [x22]
    adr x23, posiciones
    ldr w23, [x23]
    
    // Normalizar posiciones
    sdiv w24, w23, w22
    mul w24, w24, w22
    sub w23, w23, w24
    
    // Copiar elementos al arreglo temporal
    mov w24, #0
copiar_der_loop:
    ldr w25, [x20, w24, SXTW #2]
    str w25, [x21, w24, SXTW #2]
    add w24, w24, #1
    cmp w24, w22
    b.lt copiar_der_loop
    
    // Realizar rotación
    mov w24, #0
rotar_der_loop:
    sub w25, w22, w23     // n - k
    add w25, w25, w24     // (n - k + i)
    sdiv w26, w25, w22    // División
    mul w26, w26, w22     // Multiplicación
    sub w25, w25, w26     // Módulo
    
    ldr w27, [x21, w25, SXTW #2]
    str w27, [x20, w24, SXTW #2]
    
    add w24, w24, #1
    cmp w24, w22
    b.lt rotar_der_loop
    
    b mostrar_resultado

mostrar_array:
    // Mostrar elementos del arreglo
    adr x20, array
    adr x21, array_size
    ldr w21, [x21]
    mov w22, #0

mostrar_loop:
    ldr w1, [x20, w22, SXTW #2]
    adr x0, msg_num
    bl printf
    
    add w22, w22, #1
    cmp w22, w21
    b.lt mostrar_loop
    
    adr x0, msg_newline
    bl printf
    ret

mostrar_resultado:
    // Mostrar mensaje de resultado
    adr x0, msg_resultado
    bl printf
    
    // Mostrar arreglo rotado
    bl mostrar_array
    
    b menu_loop

fin_programa:
    mov w0, #0
    ldp x29, x30, [sp], 16
    ret
