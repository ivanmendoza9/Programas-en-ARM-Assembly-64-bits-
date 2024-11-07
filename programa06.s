# Suma de los N primeros números naturales

/*=======================================================
 * Programa:     suma_n.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        06 de noviembre de 2024
 * Descripción:  Suma los primeros N números naturales usando ensamblador ARM64 en RaspbianOS.
 * Compilación:  as -o suma_n.o suma_n.s
 *               gcc -o suma_n suma_n.o
 * Ejecución:    ./suma_n
 * Versión:      1.0
 * LINK ASCIINEMA Y DEBUG: https://asciinema.org/a/cGfPsV1jYhHJg3osQ0FO6SICL
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     int N, suma = 0;
 *     printf("Ingresa el valor de N (número de términos a sumar): ");
 *     scanf("%d", &N);
 *     for (int i = 1; i <= N; i++) {
 *         suma += i;
 *     }
 *     printf("La suma de los primeros N números naturales es: %d\n", suma);
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

    .data
msg_prompt_n: .asciz "Ingresa el valor de N (número de términos a sumar): " // Mensaje para solicitar N
msg_result: .asciz "La suma de los primeros N números naturales es: %d\n" // Mensaje para imprimir el resultado
fmt_int: .asciz "%d" // Formato para leer enteros

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp              // Establecer el puntero de marco
    sub sp, sp, #16          // Reservar espacio para N y el resultado en la pila

    // Solicitar el valor de N
    ldr x0, =msg_prompt_n     // Cargar el mensaje para solicitar N
    bl printf                 // Imprimir el mensaje
    ldr x0, =fmt_int          // Cargar el formato para leer un entero
    mov x1, sp                // Dirección donde se guardará N en la pila
    bl scanf                  // Leer el valor de N desde el usuario

    // Cargar N desde la pila
    ldr w1, [sp]              // Cargar N en w1

    // Inicializar variables para la suma
    mov w2, #0                // Inicializar la suma en 0
    mov w3, #1                // Inicializar el contador en 1

loop:
    cmp w3, w1                // Comparar el contador con N
    bgt end                   // Si el contador es mayor que N, salir del bucle
    add w2, w2, w3            // Acumular el contador en la suma
    add w3, w3, #1            // Incrementar el contador
    b loop                    // Volver al inicio del bucle

end:
    // Guardar el resultado en la pila
    str w2, [sp, #4]          // Guardar la suma en la posición de pila reservada

    // Imprimir el resultado
    ldr x0, =msg_result       // Cargar el mensaje de resultado
    ldr w1, [sp, #4]          // Cargar el resultado en w1 para printf
    bl printf                 // Imprimir la suma

    // Restaurar el puntero de pila y regresar
    add sp, sp, #16           // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16    // Restaurar el puntero de marco y el enlace de retorno
    ret                       // Regresar del programa
