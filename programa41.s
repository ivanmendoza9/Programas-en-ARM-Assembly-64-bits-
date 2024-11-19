/*=========================================================
 * Programa:     decimal_to_hex.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de funciones para convertir un número decimal 
 *               a hexadecimal, y obtener caracteres del resultado y su longitud.
 * Compilación:  as -o decimal_to_hex.o decimal_to_hex.s
 *               gcc -o decimal_to_hex decimal_to_hex.o
 * Ejecución:    ./decimal_to_hex
 =========================================================*/

/*
#include <stdio.h>   // Biblioteca estándar para entrada/salida

// Definición de cadenas (equivalente a la sección .data en ensamblador)
const char *prompt = "Ingrese un numero decimal: ";
const char *result_msg = "El numero en hexadecimal es: ";
const char *format_input = "%ld";    // Formato para leer un long
const char *format_hex = "0x%X\n";  // Formato para imprimir en hexadecimal
const char *newline = "\n";
const char *error_msg = "Error: Ingrese un numero valido\n";

int main() {
    // Variable para almacenar el número ingresado
    long number;

    // Imprimir el mensaje para pedir un número decimal
    printf("%s", prompt);

    // Leer el número ingresado por el usuario
    // scanf devuelve el número de variables asignadas correctamente
    if (scanf(format_input, &number) != 1) {
        // Si la entrada es inválida, mostrar mensaje de error
        printf("%s", error_msg);
        return 1;  // Salir con código de error
    }

    // Imprimir el mensaje con el resultado
    printf("%s", result_msg);

    // Convertir el número a hexadecimal y mostrarlo
    printf(format_hex, (unsigned int)number);

    // Salir con éxito
    return 0;
}
*/

.data
    prompt:         .string "Ingrese un numero decimal: "
    result_msg:     .string "El numero en hexadecimal es: "
    format_input:   .string "%ld"          // Formato para leer un long
    format_hex:     .string "0x%X\n"       // Formato para imprimir en hexadecimal
    newline:        .string "\n"
    error_msg:      .string "Error: Ingrese un numero valido\n"

.text
.global main

// Función principal
main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!   // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

    // Reservar espacio para variable local
    sub     sp, sp, #16             // 16 bytes para almacenar el número
    
    // Imprimir prompt
    adr     x0, prompt
    bl      printf

    // Leer número decimal
    adr     x0, format_input        // Formato para scanf
    mov     x1, sp                  // Dirección donde guardar el número
    bl      scanf
    
    // Verificar si la lectura fue exitosa
    cmp     x0, #1
    b.ne    error_input

    // Imprimir mensaje de resultado
    adr     x0, result_msg
    bl      printf

    // Cargar el número ingresado
    ldr     x1, [sp]
    
    // Imprimir en hexadecimal
    adr     x0, format_hex
    bl      printf
    
    mov     w0, #0                  // Retornar 0
    b       end

error_input:
    // Manejar error de entrada
    adr     x0, error_msg
    bl      printf
    mov     w0, #1                  // Retornar 1 para indicar error

end:
    // Epílogo
    add     sp, sp, #16             // Liberar espacio local
    ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
    ret
