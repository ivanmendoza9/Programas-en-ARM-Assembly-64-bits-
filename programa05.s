# División de dos números

/*=======================================================
 * Programa:     division.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        06 de noviembre de 2024
 * Descripción:  Realiza la división de dos números usando ensamblador ARM64 en RaspbianOS.
 * Compilación:  as -o division.o division.s
 *               gcc -o division division.o
 * Ejecución:    ./division
 * Versión:      1.0
 * LINK DE ASCIINEMA Y DEBUG: https://asciinema.org/a/KP55WksurL6SYekpTlt02wk58
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     double num1, num2, division;
 *     printf("Ingresa el primer numero (dividendo): ");
 *     scanf("%lf", &num1);
 *     printf("Ingresa el segundo numero (divisor): ");
 *     scanf("%lf", &num2);
 *     division = num1 / num2;
 *     printf("La division de los numeros es: %.2f\n", division);
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

    .data
msg_prompt1: .asciz "Ingresa el primer numero (dividendo): " // Mensaje para solicitar el primer número
msg_prompt2: .asciz "Ingresa el segundo numero (divisor): "  // Mensaje para solicitar el segundo número
msg_result: .asciz "La division de los numeros es: %.2f\n"   // Mensaje para imprimir el resultado
fmt_float: .asciz "%lf"                                      // Formato para leer flotantes

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp              // Establecer el puntero de marco
    sub sp, sp, #16          // Reservar espacio en la pila para dos números (double, 8 bytes cada uno)

    // Solicitar el primer número (dividendo)
    ldr x0, =msg_prompt1     // Cargar el mensaje para el primer número
    bl printf                // Imprimir el mensaje
    ldr x0, =fmt_float       // Cargar el formato para leer un número de punto flotante
    mov x1, sp               // Dirección donde se guardará el primer número en la pila
    bl scanf                 // Leer el primer número (double) desde el usuario

    // Solicitar el segundo número (divisor)
    ldr x0, =msg_prompt2     // Cargar el mensaje para el segundo número
    bl printf                // Imprimir el mensaje
    ldr x0, =fmt_float       // Cargar el formato para leer un número de punto flotante
    add x1, sp, #8           // Dirección donde se guardará el segundo número en la pila (8 bytes después del primero)
    bl scanf                 // Leer el segundo número (double) desde el usuario

    // Cargar los dos números desde la pila
    ldr d0, [sp]             // Cargar el primer número (dividendo) en d0 (double)
    ldr d1, [sp, #8]         // Cargar el segundo número (divisor) en d1 (double)

    // Realizar la división
    fdiv d2, d0, d1          // Dividir el dividendo entre el divisor -> d2 = num1 / num2

    // Imprimir el resultado
    ldr x0, =msg_result       // Cargar el mensaje de resultado
    fmov d0, d2               // Mover el resultado de la división a d0 para printf
    bl printf                 // Imprimir la división

    // Restaurar el puntero de pila y regresar
    add sp, sp, #16           // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16    // Restaurar el puntero de marco y el enlace de retorno
    ret                       // Regresar del programa
