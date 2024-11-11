/*=======================================================
 * Programa:     ascii_a_entero.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Convierte una cadena de caracteres que representa
 *               un número decimal en su valor entero correspondiente
 *               utilizando ensamblador ARM64.
 * Compilación:  as -o ascii_a_entero.o ascii_a_entero.s
 *               gcc -o ascii_a_entero ascii_a_entero.o
 * Ejecución:    ./ascii_a_entero
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * int ascii_a_entero(const char* str) {
 *     int resultado = 0;
 *     int i = 0;
 *     
 *     while (str[i] != '\0') {
 *         int digito = str[i] - '0';  // Convertir ASCII a dígito
 *         resultado = resultado * 10 + digito;  // Acumular el resultado
 *         i++;
 *     }
 *     return resultado;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.global ascii_a_entero

ascii_a_entero:
    mov w1, #0           // Inicializar el resultado en 0
    mov x2, #0           // Índice de posición en la cadena (64 bits para el offset)

1:
    ldrb w3, [x0, x2]    // Leer el siguiente carácter de la cadena (con offset en x2)
    cmp w3, #0           // ¿Es el final de la cadena (valor nulo)?
    beq fin              // Si es el final de la cadena, salir del bucle

    sub w3, w3, #'0'     // Convertir ASCII a dígito (restar '0')
    
    // Multiplicar el resultado acumulado por 10
    mov w4, #10          // Usar un registro temporal para la constante 10
    mul w1, w1, w4       // Multiplicar w1 por 10 usando w4
    add w1, w1, w3       // Sumar el dígito al resultado acumulado

    add x2, x2, #1       // Avanzar al siguiente carácter
    b 1b                 // Repetir

fin:
    mov w0, w1           // Colocar el resultado en w0 para retornar
    ret
