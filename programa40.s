/*=========================================================
 * Programa:     binary_to_decimal.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número binario 
 *               representado como un string en decimal, con manejo de errores.
 * Compilación:  as -o binary_to_decimal.o binary_to_decimal.s
 *               gcc -o binary_to_decimal binary_to_decimal.o
 * Ejecución:    ./binary_to_decimal
 =========================================================*/

/*
#include <stdio.h>
#include <string.h>

// Declaraciones de mensajes y buffer
const char* prompt = "Ingresa un número binario: ";
const char* result = "El número en decimal es: %ld\n";
const char* error_msg = "Error: Ingresa solo 1s y 0s\n";
char buffer[100];  // Buffer para la entrada del usuario

// Función principal
int main() {
    long decimal = 0;  // Variable para almacenar el resultado en decimal

    // Mostrar mensaje de entrada
    printf("%s", prompt);

    // Leer el número binario ingresado por el usuario
    scanf("%s", buffer);

    // Validar y convertir el número binario a decimal
    int longitud = strlen(buffer);  // Obtener la longitud del string ingresado
    for (int i = 0; i < longitud; i++) {
        char c = buffer[i];
        
        // Verificar si el carácter es '0' o '1'
        if (c != '0' && c != '1') {
            printf("%s", error_msg);  // Mensaje de error si no es válido
            return 1;  // Código de error
        }

        // Desplazar el resultado y sumar el dígito actual
        decimal = (decimal << 1) + (c - '0');  // Multiplica por 2 y suma el dígito
    }

    // Verificar si al menos se ingresó un dígito válido
    if (longitud == 0) {
        printf("%s", error_msg);
        return 1;  // Código de error
    }

    // Imprimir el resultado en decimal
    printf(result, decimal);
    
    return 0;  // Código de éxito
}
*/


.data
    prompt:     .string "Ingresa un número binario: "
    result:     .string "El número en decimal es: %ld\n"
    error_msg:  .string "Error: Ingresa solo 1s y 0s\n"
    buffer:     .skip 100      // Buffer para entrada del usuario
    formato:    .string "%s"   // Formato para scanf

.text
.global main

main:
    stp x29, x30, [sp, #-16]!  // Guardar frame pointer y link register
    mov x29, sp

    // Imprimir prompt
    adr x0, prompt
    bl printf

    // Leer número binario
    adr x0, formato
    adr x1, buffer
    bl scanf

    // Inicializar registros
    mov x19, #0                // x19 será nuestro resultado decimal
    adr x20, buffer            // x20 apunta al inicio del string
    mov x21, #0                // x21 será nuestro índice

validate_and_convert:
    // Cargar carácter actual
    ldrb w22, [x20, x21]      // Cargar byte en w22
    
    // Verificar si llegamos al final del string (\n o \0)
    cmp w22, #0
    b.eq print_result
    cmp w22, #10              // \n
    b.eq print_result

    // Verificar si es un dígito válido (0 o 1)
    cmp w22, #'0'
    b.lt invalid_input
    cmp w22, #'1'
    b.gt invalid_input

    // Convertir ASCII a valor numérico
    sub w22, w22, #'0'        // Convertir ASCII a valor

    // Multiplicar resultado actual por 2 y sumar nuevo dígito
    lsl x19, x19, #1          // Multiplicar por 2
    add x19, x19, x22         // Sumar nuevo dígito

    // Siguiente carácter
    add x21, x21, #1
    b validate_and_convert

invalid_input:
    // Imprimir mensaje de error
    adr x0, error_msg
    bl printf
    mov w0, #1                // Código de error
    b exit

print_result:
    // Verificar si se ingresó al menos un dígito
    cmp x21, #0
    b.eq invalid_input

    // Imprimir resultado
    adr x0, result
    mov x1, x19
    bl printf
    mov w0, #0                // Código de éxito

exit:
    ldp x29, x30, [sp], #16
    ret
