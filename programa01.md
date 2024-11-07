# Convertir temperatura de Celsius a Fahrenheit
```assembly
/*=======================================================
 * Programa:     temperatura.s
 * Autor:        IVAN MENDOZA
 * Fecha:        06 de noviembre de 2024
 * Descripción:  Convierte una temperatura de Celsius a Fahrenheit usando 
 *               ensamblador ARM64 en RaspbianOS.
 * Compilación:  as -o temperatura.o temperatura.s
 *               gcc -o temperatura temperatura.o
 * Ejecución:    ./temperatura
 * Versión:      1.0
 *
 * Código equivalente en c:
 * -----------------------------------------------------
 * #include <stdio.h> 
 * int main() { 
 *     float celsius, fahrenheit; 
 *     printf("Ingresa la temperatura en Celsius: "); 
 *     scanf("%f", &celsius); 
 *     fahrenheit = (celsius * 9 / 5) + 32; 
 *     printf("Temperatura en Fahrenheit: %.2f\n", fahrenheit); 
 *     return 0; 
 * } 
 * -----------------------------------------------------
 =========================================================*/

.data
prompt:     .string "Ingrese temperatura en Celsius: "
format_in:  .string "%lf"          // Formato para scanf
format_out: .string "%.2f°C = %.2f°F\n"  // Formato para printf
const32:    .double 32.0
const9:     .double 9.0
const5:     .double 5.0

    .text
    .global main
    .arch armv8-a

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Imprimir prompt
    adrp    x0, prompt
    add     x0, x0, :lo12:prompt
    bl      printf

    // Reservar espacio para la temperatura en Celsius
    sub     sp, sp, #16
    mov     x1, sp

    // Leer temperatura
    adrp    x0, format_in
    add     x0, x0, :lo12:format_in
    bl      scanf

    // Cargar temperatura en Celsius
    ldr     d0, [sp]

    // Realizar conversión: (celsius * 9/5) + 32
    adrp    x0, const9
    add     x0, x0, :lo12:const9
    ldr     d1, [x0]
    fmul    d0, d0, d1        // celsius * 9

    adrp    x0, const5
    add     x0, x0, :lo12:const5
    ldr     d1, [x0]
    fdiv    d0, d0, d1        // (celsius * 9) / 5

    adrp    x0, const32
    add     x0, x0, :lo12:const32
    ldr     d1, [x0]
    fadd    d1, d0, d1        // + 32

    // Imprimir resultado
    adrp    x0, format_out
    add     x0, x0, :lo12:format_out
    ldr     d0, [sp]          // Cargar celsius original
    bl      printf

    // Epílogo
    add     sp, sp, #16
    ldp     x29, x30, [sp], #16
    ret
```
