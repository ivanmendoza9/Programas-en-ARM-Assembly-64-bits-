/*=========================================================
 * Programa:     operaciones.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa funciones para realizar operaciones 
 *               básicas: suma, resta, multiplicación y división.
 *               La función de división maneja el caso cuando 
 *               el divisor es cero.
 * Compilación:  as -o operaciones.o operaciones.s
 *               gcc -o operaciones operaciones.o
 * Ejecución:    ./operaciones
 =========================================================*/

/*
#include <stdio.h>  // Biblioteca estándar para entrada/salida

// Definición de cadenas (equivalente a la sección .data en ensamblador)
const char *menu = "\n=== Calculadora Simple ===\n";
const char *menu_ops = "1. Suma\n2. Resta\n3. Multiplicacion\n4. Division\n5. Salir\nElija una opcion: ";
const char *prompt_num1 = "Ingrese primer numero: ";
const char *prompt_num2 = "Ingrese segundo numero: ";
const char *result_msg = "Resultado: %ld\n";
const char *div_result = "Resultado: %ld (Cociente), %ld (Residuo)\n";
const char *div_zero = "Error: Division por cero!\n";
const char *format_input = "%ld";
const char *invalid_op = "Opcion invalida!\n";

int main() {
    long option;          // Variable para almacenar la opción elegida
    long num1, num2;      // Variables para almacenar los números ingresados
    long result, remainder; // Variables para resultado y residuo

    while (1) { // Ciclo principal para mostrar el menú
        // Mostrar el menú
        printf("%s", menu);
        printf("%s", menu_ops);

        // Leer la opción del usuario
        if (scanf(format_input, &option) != 1) {
            printf("%s", invalid_op);
            continue; // Reiniciar el ciclo si la entrada es inválida
        }

        // Verificar si el usuario eligió salir
        if (option == 5) {
            break; // Salir del ciclo
        }

        // Verificar si la opción es válida (1 a 4)
        if (option < 1 || option > 4) {
            printf("%s", invalid_op);
            continue; // Reiniciar el ciclo si la opción es inválida
        }

        // Leer el primer número
        printf("%s", prompt_num1);
        if (scanf(format_input, &num1) != 1) {
            printf("%s", invalid_op);
            continue;
        }

        // Leer el segundo número
        printf("%s", prompt_num2);
        if (scanf(format_input, &num2) != 1) {
            printf("%s", invalid_op);
            continue;
        }

        // Realizar la operación seleccionada
        switch (option) {
            case 1: // Suma
                result = num1 + num2;
                printf(result_msg, result);
                break;
            case 2: // Resta
                result = num1 - num2;
                printf(result_msg, result);
                break;
            case 3: // Multiplicación
                result = num1 * num2;
                printf(result_msg, result);
                break;
            case 4: // División
                if (num2 == 0) {
                    // Manejar división por cero
                    printf("%s", div_zero);
                } else {
                    result = num1 / num2;
                    remainder = num1 % num2;
                    printf(div_result, result, remainder);
                }
                break;
            default: // Caso no válido (no debería ocurrir)
                printf("%s", invalid_op);
                break;
        }
    }

    return 0; // Salir con éxito
}
*/



.data
    menu:           .string "\n=== Calculadora Simple ===\n"
    menu_ops:       .string "1. Suma\n2. Resta\n3. Multiplicacion\n4. Division\n5. Salir\nElija una opcion: "
    prompt_num1:    .string "Ingrese primer numero: "
    prompt_num2:    .string "Ingrese segundo numero: "
    result_msg:     .string "Resultado: %ld\n"
    div_result:     .string "Resultado: %ld (Cociente), %ld (Residuo)\n"
    div_zero:       .string "Error: Division por cero!\n"
    format_input:   .string "%ld"
    invalid_op:     .string "Opcion invalida!\n"

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Espacio para variables locales (opción y números)
    sub     sp, sp, #32

menu_loop:
    // Mostrar menú
    adr     x0, menu
    bl      printf
    adr     x0, menu_ops
    bl      printf
    
    // Leer opción
    adr     x0, format_input
    mov     x1, sp          // Guardar opción en [sp]
    bl      scanf
    
    // Cargar opción
    ldr     x19, [sp]
    
    // Verificar si es salir (opción 5)
    cmp     x19, #5
    b.eq    end_program
    
    // Verificar opción válida (1-4)
    cmp     x19, #1
    b.lt    invalid_option
    cmp     x19, #4
    b.gt    invalid_option
    
    // Leer primer número
    adr     x0, prompt_num1
    bl      printf
    adr     x0, format_input
    add     x1, sp, #8      // Guardar num1 en [sp + 8]
    bl      scanf
    
    // Leer segundo número
    adr     x0, prompt_num2
    bl      printf
    adr     x0, format_input
    add     x1, sp, #16     // Guardar num2 en [sp + 16]
    bl      scanf
    
    // Cargar números en registros
    ldr     x20, [sp, #8]   // num1
    ldr     x21, [sp, #16]  // num2
    
    // Saltar a la operación correspondiente
    cmp     x19, #1
    b.eq    do_suma
    cmp     x19, #2
    b.eq    do_resta
    cmp     x19, #3
    b.eq    do_multiplicacion
    b       do_division

do_suma:
    add     x22, x20, x21
    adr     x0, result_msg
    mov     x1, x22
    bl      printf
    b       menu_loop

do_resta:
    sub     x22, x20, x21
    adr     x0, result_msg
    mov     x1, x22
    bl      printf
    b       menu_loop

do_multiplicacion:
    mul     x22, x20, x21
    adr     x0, result_msg
    mov     x1, x22
    bl      printf
    b       menu_loop

do_division:
    // Verificar división por cero
    cmp     x21, #0
    b.eq    division_zero
    
    // Realizar división
    sdiv    x22, x20, x21   // Cociente
    msub    x23, x22, x21, x20  // Residuo = num1 - (cociente * num2)
    
    // Mostrar resultado
    adr     x0, div_result
    mov     x1, x22
    mov     x2, x23
    bl      printf
    b       menu_loop

division_zero:
    adr     x0, div_zero
    bl      printf
    b       menu_loop

invalid_option:
    adr     x0, invalid_op
    bl      printf
    b       menu_loop

end_program:
    // Epílogo
    mov     w0, #0
    add     sp, sp, #32
    ldp     x29, x30, [sp], #16
    ret
