# Verificar si un número es primo

/*==========================================================
 * Programa:     numeroprimo.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        6 de noviembre de 2024
 * Descripción:  Verifica si un número es primo en ensamblador ARM64.
 *
 * Compilación:  as -o numeroprimo.o numeroprimo.s
 *               gcc -o numeroprimo numeroprimo.o
 * Ejecución:    ./numeroprimo
 * LINK DE ASCIINEMA Y DEBUG: https://asciinema.org/a/XXXXXXXXXXXX
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     int N, i, flag = 1;
 *     printf("Ingresa un número para verificar si es primo: ");
 *     scanf("%d", &N);
 *     
 *     if (N <= 1) {
 *         flag = 0; // No es primo si es <= 1
 *     } else {
 *         for (i = 2; i * i <= N; i++) {
 *             if (N % i == 0) {
 *                 flag = 0; // No es primo si tiene divisores
 *                 break;
 *             }
 *         }
 *     }
 *     
 *     if (flag) {
 *         printf("El número %d es primo.\n", N);
 *     } else {
 *         printf("El número %d no es primo.\n", N);
 *     }
 *     return 0;
 * }
 * -----------------------------------------------------
 ===========================================================*/

    .data
msg_prompt_n: .asciz "Ingresa un número para verificar si es primo: " // Solicitar número N
msg_prime: .asciz "El número %d es primo.\n" // Mensaje si el número es primo
msg_not_prime: .asciz "El número %d no es primo.\n" // Mensaje si el número no es primo
fmt_int: .asciz "%d" // Formato para leer enteros

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp             // Establecer el puntero de marco
    sub sp, sp, #16         // Reservar espacio para N y el resultado en la pila

    // Solicitar el valor de N
    ldr x0, =msg_prompt_n   // Cargar el mensaje para solicitar N
    bl printf               // Imprimir el mensaje
    ldr x0, =fmt_int        // Cargar el formato para leer un entero
    mov x1, sp              // Dirección donde se guardará N en la pila
    bl scanf                // Leer el valor de N desde el usuario

    // Cargar N desde la pila
    ldr w1, [sp]            // Cargar N en w1

    // Verificar si el número es menor o igual a 1 (no primo)
    cmp w1, #1              // Comparar N con 1
    ble not_prime           // Si N <= 1, no es primo

    // Inicializar el contador i en 2
    mov w2, #2              // w2 será el contador i

    // Bucle para verificar si N es divisible por algún número desde 2 hasta √N
check_prime_loop:
    mul w3, w2, w2          // w3 = i * i
    cmp w3, w1              // Comparar i * i con N
    bgt prime               // Si i * i > N, el número es primo

    // Verificar si N es divisible por i
    udiv w4, w1, w2         // w4 = N / i
    mul w5, w4, w2          // w5 = (N / i) * i
    cmp w5, w1              // Comparar (N / i) * i con N
    beq not_prime           // Si son iguales, N es divisible por i, no es primo

    // Incrementar el contador i
    add w2, w2, #1          // i = i + 1
    b check_prime_loop      // Repetir el bucle

prime:
    // El número es primo
    ldr x0, =msg_prime      // Cargar el mensaje "es primo"
    ldr w1, [sp]            // Cargar N en w1 para mostrarlo en el mensaje
    bl printf               // Imprimir el mensaje

    b end_program           // Saltar al final del programa

not_prime:
    // El número no es primo
    ldr x0, =msg_not_prime  // Cargar el mensaje "no es primo"
    ldr w1, [sp]            // Cargar N en w1 para mostrarlo en el mensaje
    bl printf               // Imprimir el mensaje

end_program:
    // Restaurar el puntero de pila y regresar
    add sp, sp, #16         // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16  // Restaurar el puntero de marco y el enlace de retorno
    ret                     // Regresar del programa
