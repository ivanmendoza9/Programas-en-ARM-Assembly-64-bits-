/*=========================================================
 * Programa:     hexa.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Convierte un carácter hexadecimal ('0'-'9', 'A'-'F', 'a'-'f') 
 *               a su valor decimal correspondiente.
 * Compilación:  as -o hexa.o hexa.s
 *               gcc -o hexa hexa.o
 * Ejecución:    ./hexa
 =========================================================*/

/*
#include <stdio.h>   // Biblioteca estándar para entrada/salida

// Definición de cadenas (equivalente a la sección .data en ensamblador)
const char *prompt = "Ingrese un numero hexadecimal (con 0x): ";
const char *result_msg = "El numero en decimal es: %ld\n";
const char *format_input = "%lx";    // Formato para leer hexadecimal como long
const char *error_msg = "Error: Ingrese un numero hexadecimal valido\n";
char buffer[20];                    // Buffer para almacenar la entrada

int main() {
    // Variable para almacenar el número ingresado
    unsigned long number;

    // Imprimir el mensaje para pedir un número hexadecimal
    printf("%s", prompt);

    // Leer el número hexadecimal ingresado por el usuario
    // scanf devuelve el número de variables asignadas correctamente
    if (scanf(format_input, &number) != 1) {
        // Si la entrada es inválida, mostrar mensaje de error
        printf("%s", error_msg);
        return 1;  // Salir con código de error
    }

    // Imprimir el número convertido en decimal
    printf(result_msg, number);

    // Salir con éxito
    return 0;
}
*/


.data
    prompt:         .string "Ingrese un numero hexadecimal (con 0x): "
    result_msg:     .string "El numero en decimal es: %ld\n"
    format_input:   .string "%lx"          // Formato para leer hexadecimal long
    error_msg:      .string "Error: Ingrese un numero hexadecimal valido\n"
    buffer:         .skip 20              // Buffer para almacenar la entrada
    newline:        .string "\n"

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

    // Leer número hexadecimal
    adr     x0, format_input        // Formato para scanf
    mov     x1, sp                  // Dirección donde guardar el número
    bl      scanf
    
    // Verificar si la lectura fue exitosa
    cmp     x0, #1
    b.ne    error_input

    // Cargar el número convertido
    ldr     x1, [sp]
    
    // Imprimir resultado en decimal
    adr     x0, result_msg
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
