/*=========================================================
 * Programa:     decimal_to_binary.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número decimal
 *               a binario, obtener un bit específico y obtener el tamaño del 
 *               resultado binario.
 * Compilación:  as -o decimal_to_binary.o decimal_to_binary.s
 *               gcc -o decimal_to_binary decimal_to_binary.o
 * Ejecución:    ./decimal_to_binary
 =========================================================*/

/*
#include <stdio.h>

// Declaraciones de mensajes y buffer
const char* prompt = "Ingresa un número decimal: ";
const char* result = "El número en binario es: ";
const char* newline = "\n";
char binario[33];  // Buffer para almacenar el número en binario (32 bits + terminador nulo)

// Función principal
int main() {
    long numero;
    
    // Mostrar mensaje de entrada
    printf("%s", prompt);

    // Leer número decimal ingresado por el usuario
    scanf("%ld", &numero);

    // Mostrar mensaje de resultado
    printf("%s", result);

    // Conversión del número a binario
    int indice = 31;  // Índice para llenar el buffer de binario desde el final
    binario[32] = '\0';  // Colocar el terminador nulo al final del buffer
    
    for (int i = 0; i < 32; i++) {
        binario[indice--] = (numero & 1) ? '1' : '0';  // Obtener bit y convertir a ASCII
        numero >>= 1;  // Desplazar el número a la derecha
    }

    // Imprimir el número en binario
    printf("%s", binario);

    // Imprimir nueva línea
    printf("%s", newline);

    return 0;
}
*/

.data
    prompt:     .string "Ingresa un número decimal: "
    result:     .string "El número en binario es: "
    newline:    .string "\n"
    buffer:     .skip 12        // Buffer para entrada del usuario
    binario:    .skip 33        // Buffer para resultado binario (32 bits + null)
    formato:    .string "%ld"   // Formato para scanf

.text
.global main

main:
    stp x29, x30, [sp, #-16]!  // Guardar frame pointer y link register
    mov x29, sp

    // Imprimir prompt
    adr x0, prompt
    bl printf

    // Leer número decimal
    sub sp, sp, #16            // Reservar espacio en stack
    mov x2, sp                 // Dirección donde guardar el número
    adr x0, formato
    mov x1, x2
    bl scanf

    // Cargar número ingresado
    ldr x19, [sp]              // x19 contendrá nuestro número
    add sp, sp, #16            // Restaurar stack

    // Imprimir mensaje de resultado
    adr x0, result
    bl printf

    // Preparar conversión a binario
    mov x20, #31               // Índice para el string (31 posiciones + null)
    adr x21, binario           // Dirección del buffer resultado
    mov x22, #0                // Para el terminador null
    strb w22, [x21, x20]       // Colocar terminador null al final
    sub x20, x20, #1           // Decrementar índice

convert_loop:
    and x22, x19, #1          // Obtener el bit menos significativo
    add w22, w22, #'0'        // Convertir a ASCII
    strb w22, [x21, x20]      // Guardar el dígito
    lsr x19, x19, #1          // Desplazar a la derecha
    sub x20, x20, #1          // Mover índice
    cmp x20, #-1              // Verificar si terminamos
    b.ge convert_loop         // Si no, continuar

    // Imprimir resultado
    add x21, x21, #0          // Ajustar dirección al inicio
    mov x0, x21
    bl printf

    // Imprimir nueva línea
    adr x0, newline
    bl printf

    // Retornar
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
