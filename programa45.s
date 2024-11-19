/*=========================================================
 * Programa:     EsArmstrong.s
 * Autor:        IVAN MENDOZA
 * Fecha:        19 de noviembre de 2024
 * Descripción:  Determina si un número es un número Armstrong
 *               (la suma de los dígitos elevados a la potencia del número
 *               de dígitos es igual al número original).
 * Compilación:  gcc -o EsArmstrong EsArmstrong.c
 * Ejecución:    ./EsArmstrong <numero>
 =========================================================*/

/*
#include <stdio.h>
#include <math.h> // Biblioteca para calcular potencias

// Mensajes para interacción con el usuario
const char *prompt = "Ingrese un numero para verificar si es Armstrong: ";
const char *is_armstrong = "El numero %ld ES un numero Armstrong!\n";
const char *not_armstrong = "El numero %ld NO es un numero Armstrong.\n";
const char *explain_fmt = "Explicacion: %ld = ";
const char *plus_fmt = " + ";
const char *power_fmt = "%ld^%ld";
const char *newline = "\n";
const char *input_fmt = "%ld"; // Formato para leer enteros largos
const char *error_msg = "Error: Ingrese un numero valido\n";

int main() {
    long num;     // Almacena el número ingresado por el usuario
    long temp;    // Copia temporal del número para cálculos
    long digits;  // Contador de dígitos
    long sum;     // Suma de las potencias de los dígitos

    // Solicitar al usuario el número a verificar
    printf("%s", prompt);
    if (scanf(input_fmt, &num) != 1) {
        // Mostrar error si la entrada es inválida
        printf("%s", error_msg);
        return 1;
    }

    // Contar el número de dígitos
    temp = num;
    digits = 0;
    while (temp > 0) {
        temp /= 10; // Dividir entre 10 para reducir el número
        digits++;
    }

    // Calcular la suma de las potencias de los dígitos
    temp = num; // Restaurar número original
    sum = 0;
    while (temp > 0) {
        long digit = temp % 10;           // Obtener el último dígito
        long power = 1;
        for (long i = 0; i < digits; i++) // Calcular `digit^digits`
            power *= digit;
        sum += power; // Sumar al total
        temp /= 10;   // Remover el último dígito
    }

    // Verificar si el número es Armstrong
    if (sum == num) {
        printf(is_armstrong, num);

        // Explicación de la operación
        printf(explain_fmt, num);
        temp = num;
        while (temp > 0) {
            long digit = temp % 10;
            printf(power_fmt, digit, digits); // Imprimir dígito^potencia
            temp /= 10;
            if (temp > 0)
                printf("%s", plus_fmt); // Imprimir "+" entre términos
        }
        printf("%s", newline);
    } else {
        printf(not_armstrong, num);
    }

    return 0; // Finalizar programa exitosamente
}
*/


.data
    prompt:         .string "Ingrese un numero para verificar si es Armstrong: "
    is_armstrong:   .string "El numero %ld ES un numero Armstrong!\n"
    not_armstrong:  .string "El numero %ld NO es un numero Armstrong.\n"
    explain_fmt:    .string "Explicacion: %ld = "
    plus_fmt:      .string " + "
    power_fmt:     .string "%ld^%ld"
    newline:       .string "\n"
    input_fmt:     .string "%ld"
    error_msg:     .string "Error: Ingrese un numero valido\n"

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Reservar espacio para variables
    sub     sp, sp, #32
    
    // Mostrar prompt
    adr     x0, prompt
    bl      printf
    
    // Leer número
    adr     x0, input_fmt
    mov     x1, sp
    bl      scanf
    
    // Verificar lectura exitosa
    cmp     x0, #1
    b.ne    input_error
    
    // Cargar número en x19
    ldr     x19, [sp]
    
    // Contar dígitos (resultado en x20)
    mov     x20, #0          // Contador de dígitos
    mov     x21, x19         // Copia del número para contar
    mov     x24, #10         // Constante 10 para divisiones

count_digits:
    cbz     x21, count_done
    udiv    x21, x21, x24    // Dividir por 10 usando registro
    add     x20, x20, #1
    b       count_digits
count_done:

    // Calcular suma de potencias
    mov     x21, x19         // Copia del número para procesar
    mov     x22, #0          // Suma total
    mov     x23, x19         // Copia para mostrar explicación después

calc_powers:
    cbz     x21, calc_done
    
    // Obtener último dígito
    udiv    x25, x21, x24    // x25 = número / 10
    msub    x26, x25, x24, x21  // x26 = último dígito
    
    // Calcular potencia (dígito^n)
    mov     x27, #1          // Resultado de la potencia
    mov     x28, x20         // Contador para potencia
power_loop:
    cbz     x28, power_done
    mul     x27, x27, x26
    sub     x28, x28, #1
    b       power_loop
power_done:
    
    // Sumar al total
    add     x22, x22, x27
    
    // Siguiente dígito
    mov     x21, x25
    b       calc_powers
    
calc_done:
    // Verificar si es Armstrong
    cmp     x22, x19
    b.ne    print_not_armstrong
    
    // Es Armstrong - Imprimir resultado y explicación
    adr     x0, is_armstrong
    mov     x1, x19
    bl      printf
    
    // Imprimir explicación
    adr     x0, explain_fmt
    mov     x1, x19
    bl      printf
    
    // Mostrar cada dígito elevado a la potencia
    mov     x21, x23         // Restaurar número original
explain_loop:
    cbz     x21, explain_done
    
    // Obtener dígito
    udiv    x25, x21, x24
    msub    x26, x25, x24, x21  // x26 = dígito actual
    
    // Imprimir término
    adr     x0, power_fmt
    mov     x1, x26          // Dígito
    mov     x2, x20          // Potencia
    bl      printf
    
    // Si no es el último dígito, imprimir "+"
    cmp     x25, #0
    b.eq    explain_next
    adr     x0, plus_fmt
    bl      printf
    
explain_next:
    mov     x21, x25
    b       explain_loop
    
explain_done:
    adr     x0, newline
    bl      printf
    b       end_program

print_not_armstrong:
    adr     x0, not_armstrong
    mov     x1, x19
    bl      printf
    b       end_program

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
