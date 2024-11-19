/*=======================================================
 * Programa:     DetectOverflow.s
 * Autor:        IVAN MENDOZA
 * Fecha:        19 de Noviembre 2024
 * Descripción:  Función que detecta desbordamiento en la suma de dos números enteros.
 *               Si el resultado de la suma excede los límites de un entero de 32 bits,
 *               retorna 1, de lo contrario, retorna 0.
 * Compilación:  as -o DetectOverflow.o DetectOverflow.s
 *               ld -o DetectOverflow DetectOverflow.o
 * Ejecución:    ./DetectOverflow
 =========================================================*/

/*
#include <stdio.h>
#include <limits.h> // Para LONG_MAX y LONG_MIN

int main() {
    // Variables para almacenar los números y la suma
    long num1, num2, sum;

    // Solicitar al usuario el primer número
    printf("Ingresa el primer número: ");
    scanf("%ld", &num1);

    // Solicitar al usuario el segundo número
    printf("Ingresa el segundo número: ");
    scanf("%ld", &num2);

    // Calcular la suma
    sum = num1 + num2;

    // Verificar desbordamiento
    if ((num1 > 0 && num2 > 0 && sum < 0) || // Desbordamiento positivo
        (num1 < 0 && num2 < 0 && sum > 0)) { // Desbordamiento negativo
        // Imprimir resultado
        printf("La suma es: %ld\n", sum);

        // Informar que hubo desbordamiento
        printf("¡Hubo desbordamiento!\n");
    } else {
        // Imprimir resultado
        printf("La suma es: %ld\n", sum);

        // Informar que no hubo desbordamiento
        printf("No hubo desbordamiento\n");
    }

    return 0;
}
*/

.data
    prompt1:    .string "Ingresa el primer número: "
    prompt2:    .string "Ingresa el segundo número: "
    result:     .string "La suma es: %ld\n"
    overflow:   .string "¡Hubo desbordamiento!\n"
    no_overflow: .string "No hubo desbordamiento\n"
    format:     .string "%ld"
    
    // Constantes para límites de 64 bits
    LONG_MAX:   .quad 9223372036854775807
    LONG_MIN:   .quad -9223372036854775808
    
.text
.global main
main:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Reservar espacio para variables locales
    sub sp, sp, #32
    
    // Pedir primer número
    adr x0, prompt1
    bl printf
    
    // Leer primer número
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x19, [sp]        // x19 = primer número
    
    // Pedir segundo número
    adr x0, prompt2
    bl printf
    
    // Leer segundo número
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x20, [sp]        // x20 = segundo número
    
    // Cargar límites de 64 bits
    adr x0, LONG_MAX
    ldr x21, [x0]        // x21 = LONG_MAX
    adr x0, LONG_MIN
    ldr x22, [x0]        // x22 = LONG_MIN
    
    // Realizar la suma
    adds x23, x19, x20   // x23 = suma, actualiza flags
    
    // Verificar desbordamiento usando el flag de carry
    b.vs overflow_detected   // Branch if overflow set
    
no_overflow_detected:
    // Imprimir resultado
    adr x0, result
    mov x1, x23
    bl printf
    
    // Imprimir mensaje de no desbordamiento
    adr x0, no_overflow
    bl printf
    b end
    
overflow_detected:
    // Imprimir resultado
    adr x0, result
    mov x1, x23
    bl printf
    
    // Imprimir mensaje de desbordamiento
    adr x0, overflow
    bl printf
    
end:
    // Restaurar stack y registros
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
