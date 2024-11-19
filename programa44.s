/*=========================================================
 * Programa:     GenerarAleatorio.s
 * Autor:        IVAN MENDOZA
 * Fecha:        19 de noviembre de 2024
 * Descripción:  Implementa un generador de números pseudoaleatorios
 *               usando la fórmula (semilla * 1103515245 + 12345) & 0x7FFFFFFF
 * Compilación:  gcc -o GenerarAleatorio GenerarAleatorio.c
 * Ejecución:    ./GenerarAleatorio <semilla>
 =========================================================*/

/*
#include <stdio.h>   // Biblioteca estándar para entrada/salida

// Constantes para el generador LCG
const long multiplier = 1103515245; // a
const long increment = 12345;      // c
const long modulus = 2147483648;   // m (2^31)
const int range_mod = 100;         // Para rango 1-100

// Mensajes para la interacción con el usuario
const char *prompt_seed = "Ingrese una semilla (numero entero): ";
const char *prompt_count = "Cuantos numeros desea generar? ";
const char *result_fmt = "Numero aleatorio %d: %d (en rango 1-100)\n";
const char *input_fmt = "%ld"; // Formato para leer enteros largos
const char *error_msg = "Error: Ingrese un numero valido\n";

int main() {
    long seed;  // Variable para almacenar la semilla
    long count; // Variable para la cantidad de números a generar

    // Solicitar la semilla al usuario
    printf("%s", prompt_seed);
    if (scanf(input_fmt, &seed) != 1) {
        // Mostrar mensaje de error si la entrada es inválida
        printf("%s", error_msg);
        return 1;
    }

    // Solicitar la cantidad de números a generar
    printf("%s", prompt_count);
    if (scanf(input_fmt, &count) != 1) {
        // Mostrar mensaje de error si la entrada es inválida
        printf("%s", error_msg);
        return 1;
    }

    // Generar los números aleatorios
    for (int i = 1; i <= count; i++) {
        // Implementación del Linear Congruential Generator (LCG)
        // Xn+1 = (a * Xn + c) mod m
        seed = (multiplier * seed + increment) % modulus;

        // Escalar el resultado al rango 1-100
        int random_number = (seed % range_mod) + 1;

        // Mostrar el número generado
        printf(result_fmt, i, random_number);
    }

    return 0; // Finalizar el programa exitosamente
}
*/


.data
    prompt_seed:    .string "Ingrese una semilla (numero entero): "
    prompt_count:   .string "Cuantos numeros desea generar? "
    result_fmt:     .string "Numero aleatorio %d: %d (en rango 1-100)\n"
    input_fmt:      .string "%ld"
    error_msg:      .string "Error: Ingrese un numero valido\n"
    newline:        .string "\n"

    // Constantes para el generador LCG
    .align 8
    multiplier:     .dword 1103515245    // a
    increment:      .dword 12345         // c
    modulus:        .dword 2147483648    // m (2^31)
    range_mod:      .dword 100           // Para obtener números entre 1-100

.text
.global main

// Función principal
main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Reservar espacio para variables locales
    sub     sp, sp, #32     // Espacio para semilla y contador
    
    // Solicitar semilla
    adr     x0, prompt_seed
    bl      printf
    
    // Leer semilla
    adr     x0, input_fmt
    mov     x1, sp          // Guardar semilla en [sp]
    bl      scanf
    
    // Verificar lectura exitosa
    cmp     x0, #1
    b.ne    input_error
    
    // Solicitar cantidad de números
    adr     x0, prompt_count
    bl      printf
    
    // Leer cantidad
    adr     x0, input_fmt
    add     x1, sp, #8      // Guardar contador en [sp + 8]
    bl      scanf
    
    // Verificar lectura exitosa
    cmp     x0, #1
    b.ne    input_error
    
    // Inicializar registros para el generador
    ldr     x19, [sp]           // Semilla actual
    ldr     x20, [sp, #8]       // Contador
    mov     x21, #1             // Contador de números generados
    
    // Cargar constantes
    adr     x22, multiplier
    ldr     x22, [x22]          // a
    adr     x23, increment
    ldr     x23, [x23]          // c
    adr     x24, modulus
    ldr     x24, [x24]          // m
    adr     x25, range_mod
    ldr     x25, [x25]          // 100 para rango 1-100

generate_loop:
    // Verificar si hemos generado todos los números
    cmp     x21, x20
    b.gt    end_program
    
    // Generar siguiente número usando LCG
    // Xn+1 = (a * Xn + c) mod m
    mul     x26, x22, x19       // a * Xn
    add     x26, x26, x23       // + c
    udiv    x27, x26, x24       // División para obtener módulo
    msub    x19, x27, x24, x26  // Xn+1 = resultado mod m
    
    // Convertir a rango 1-100
    udiv    x27, x19, x25       // División por 100
    msub    x28, x27, x25, x19  // Obtener módulo
    add     x28, x28, #1        // +1 para rango 1-100
    
    // Imprimir número generado
    adr     x0, result_fmt
    mov     x1, x21             // Número de secuencia
    mov     x2, x28             // Número generado
    bl      printf
    
    // Incrementar contador
    add     x21, x21, #1
    b       generate_loop

input_error:
    adr     x0, error_msg
    bl      printf
    mov     w0, #1
    b       cleanup

end_program:
    mov     w0, #0

cleanup:
    // Epílogo
    add     sp, sp, #32
    ldp     x29, x30, [sp], #16
    ret
