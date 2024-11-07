# Invertir una cadena

/*=======================================================
 * Programa:     inversa.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        06 de noviembre de 2024
 * Descripción:  Invierte una cadena de texto proporcionada por el usuario en ensamblador ARM64 en RaspbianOS.
 * Compilación:  as -o inversa.o inversa.s
 *               gcc -o inversa inversa.o
 * Ejecución:    ./inversa
 * Versión:      1.0
 * LINK DE ASCIINEMA Y DEBUG: https://asciinema.org/a/XXXXXXXXXXXX
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * #include <string.h>
 * int main() {
 *     char str[256];
 *     printf("Ingresa una cadena de texto: ");
 *     scanf("%255s", str);
 *     int len = strlen(str);
 *     for (int i = 0; i < len / 2; i++) {
 *         char temp = str[i];
 *         str[i] = str[len - 1 - i];
 *         str[len - 1 - i] = temp;
 *     }
 *     printf("La cadena invertida es: %s\n", str);
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

    .data
msg_prompt: .asciz "Ingresa una cadena de texto: " // Mensaje para solicitar la cadena
msg_result: .asciz "La cadena invertida es: %s\n" // Mensaje para imprimir la cadena invertida
input_format: .asciz "%255s" // Formato para leer una cadena de hasta 255 caracteres

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp              // Establecer el puntero de marco
    sub sp, sp, #256         // Reservar espacio para la cadena de entrada (máximo 255 caracteres)

    // Solicitar la cadena de texto
    ldr x0, =msg_prompt      // Cargar el mensaje para solicitar la cadena
    bl printf                // Imprimir el mensaje
    ldr x0, =input_format    // Cargar el formato para leer una cadena
    mov x1, sp               // Dirección donde se guardará la cadena en la pila
    bl scanf                 // Leer la cadena desde el usuario

    // Encontrar el final de la cadena (buscando el carácter nulo '\0')
    mov x2, sp               // Dirección de la cadena
find_end:
    ldrb w3, [x2]            // Cargar el siguiente byte de la cadena
    cmp w3, #0               // Verificar si es el carácter nulo ('\0')
    beq reverse_string       // Si es el final de la cadena, salir del bucle
    add x2, x2, #1           // Avanzar al siguiente carácter
    b find_end               // Continuar buscando

reverse_string:
    // x2 contiene la dirección del carácter nulo ('\0'), retrocedemos una posición
    sub x2, x2, #1           // Retroceder una posición, apuntar al último carácter válido

    // Iniciar el proceso de invertir la cadena
    mov x3, sp               // Dirección inicial de la cadena
reverse_loop:
    cmp x3, x2               // Comparar los punteros
    bge end_reverse          // Si los punteros se cruzan, terminamos
    ldrb w4, [x3]            // Cargar el carácter de la posición inicial
    ldrb w5, [x2]            // Cargar el carácter de la posición final
    strb w5, [x3]            // Colocar el carácter final en la posición inicial
    strb w4, [x2]            // Colocar el carácter inicial en la posición final
    add x3, x3, #1           // Avanzar el puntero inicial
    sub x2, x2, #1           // Retroceder el puntero final
    b reverse_loop           // Continuar invirtiendo

end_reverse:
    // Imprimir la cadena invertida
    ldr x0, =msg_result      // Cargar el mensaje para mostrar el resultado
    mov x1, sp               // Dirección de la cadena invertida
    bl printf                // Imprimir la cadena invertida

    // Restaurar el puntero de pila y regresar
    add sp, sp, #256         // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16   // Restaurar el puntero de marco y el enlace de retorno
    ret                      // Regresar del programa
