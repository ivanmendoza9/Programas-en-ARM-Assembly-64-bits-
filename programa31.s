/*=========================================================
 * Programa:     mcm.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Calcula el Mínimo Común Múltiplo (MCM) de
 *               dos números a y b usando el algoritmo de
 *               Euclides para calcular el MCD.
 * Compilación:  as -o mcm.o mcm.s
 *               gcc -o mcm mcm.o
 * Ejecución:    ./mcm
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función para calcular el MCD utilizando el algoritmo de Euclides
 * int mcd(int a, int b) {
 *     while (b != 0) {
 *         int temp = b;
 *         b = a % b;
 *         a = temp;
 *     }
 *     return a;
 * }
 * 
 * // Función para calcular el MCM utilizando la relación MCM(a, b) = (a * b) / MCD(a, b)
 * int mcm(int a, int b) {
 *     return (a * b) / mcd(a, b);
 * }
 * 
 * int main() {
 *     int a = 56, b = 98;  // Ejemplo de números
 *     printf("El MCM de %d y %d es: %d\n", a, b, mcm(a, b));
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

    .data
msg_menu:       .string "\nCálculo de MCD y MCM\n"
                .string "1. Calcular MCD\n"
                .string "2. Calcular MCM\n"
                .string "3. Salir\n"
                .string "Seleccione una opción: "

msg_num1:       .string "Ingrese el primer número: "
msg_num2:       .string "Ingrese el segundo número: "
msg_mcd:        .string "El MCD es: %d\n"
msg_mcm:        .string "El MCM es: %d\n"
formato_int:    .string "%d"

opcion:         .word 0
numero1:        .word 0
numero2:        .word 0

    .text
    .global main
    .align 2

// Función principal
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

    // Leer números
    adr     x0, msg_num1
    bl      printf
    adr     x0, formato_int
    adr     x1, numero1
    bl      scanf

    adr     x0, msg_num2
    bl      printf
    adr     x0, formato_int
    adr     x1, numero2
    bl      scanf

    // Cargar números en registros
    adr     x0, numero1
    ldr     w19, [x0]        // Primer número en w19
    adr     x0, numero2
    ldr     w20, [x0]        // Segundo número en w20

    // Verificar opción
    adr     x0, opcion
    ldr     w0, [x0]
    cmp     w0, #1
    b.eq    calcular_mcd
    cmp     w0, #2
    b.eq    calcular_mcm
    b       menu_loop

calcular_mcd:
    // Preservar valores originales para MCM
    mov     w21, w19         // Guardar primer número
    mov     w22, w20         // Guardar segundo número

mcd_loop:
    // Algoritmo de Euclides
    cmp     w20, #0
    b.eq    mostrar_mcd
    
    // Calcular residuo
    sdiv    w23, w19, w20    // División
    msub    w23, w23, w20, w19  // Residuo = Dividendo - (Cociente * Divisor)
    
    // Actualizar valores
    mov     w19, w20         // a = b
    mov     w20, w23         // b = residuo
    b       mcd_loop

mostrar_mcd:
    mov     w1, w19          // MCD está en w19
    adr     x0, msg_mcd
    bl      printf
    b       menu_loop

calcular_mcm:
    // Primero calculamos el MCD
    mov     w21, w19         // Guardar primer número
    mov     w22, w20         // Guardar segundo número

mcm_mcd_loop:
    cmp     w20, #0
    b.eq    calcular_mcm_final
    
    sdiv    w23, w19, w20
    msub    w23, w23, w20, w19
    
    mov     w19, w20
    mov     w20, w23
    b       mcm_mcd_loop

calcular_mcm_final:
    // MCM = (a * b) / MCD
    mul     w20, w21, w22    // a * b
    sdiv    w20, w20, w19    // Dividir por MCD

mostrar_mcm:
    mov     w1, w20
    adr     x0, msg_mcm
    bl      printf
    b       menu_loop

fin_programa:
    mov     w0, #0
    ldp     x29, x30, [sp], 16
    ret
