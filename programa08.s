# Serie de Fibonacci

/*==========================================================
 * Programa:     fibonacci.s
 * Autor:        Mendoza Suarez Ivan Gustavo
 * Fecha:        06 de noviembre de 2024
 * Descripción:  Calcula y muestra los primeros 10 términos
 *               de la secuencia de Fibonacci en ensamblador ARM64.
 * Compilación:  as -o fibonacci.o fibonacci.s
 *               gcc -o fibonacci fibonacci.o
 * Ejecución:    ./fibonacci
 * LINK DE ASCIINEMA Y DEBUG: https://asciinema.org/a/80jw6xZVc1AMYzC0LPgfzWJC2
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     long n1 = 0, n2 = 1, nextTerm;
 *     printf("Serie de Fibonacci:\n");
 *     printf("%ld %ld ", n1, n2);
 *     for (int i = 2; i < 10; i++) {
 *         nextTerm = n1 + n2;
 *         printf("%ld ", nextTerm);
 *         n1 = n2;
 *         n2 = nextTerm;
 *     }
 *     printf("\n");
 *     return 0;
 * }
 * -----------------------------------------------------
 ===========================================================*/

    .data
msg1:   .string "Serie de Fibonacci: \n"    // Mensaje inicial
newline:.string "\n"                        // Carácter de nueva línea
format: .string "%ld "                      // Formato para imprimir números

    .text
    .global main
    .extern printf

main:
    // Guardar registros
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp                // Actualizar frame pointer

    // Imprimir mensaje inicial
    adr     x0, msg1
    bl      printf

    // Inicializar variables
    mov     x19, #0                // Primer número (n-2)
    mov     x20, #1                // Segundo número (n-1)
    mov     x21, #0                // Resultado actual
    mov     x22, #10               // Contador (calcularemos 10 números)

print_first:
    // Imprimir primer número (0)
    adr     x0, format
    mov     x1, x19
    bl      printf

    // Imprimir segundo número (1)
    adr     x0, format
    mov     x1, x20
    bl      printf

    // Decrementar contador por los dos números ya impresos
    sub     x22, x22, #2

fibonacci_loop:
    // Verificar si hemos terminado
    cmp     x22, #0
    ble     end

    // Calcular siguiente número
    add     x21, x19, x20          // x21 = x19 + x20
    mov     x19, x20               // x19 = x20
    mov     x20, x21               // x20 = x21

    // Imprimir número actual
    adr     x0, format
    mov     x1, x21
    bl      printf

    // Decrementar contador
    sub     x22, x22, #1
    b       fibonacci_loop

end:
    // Imprimir nueva línea
    adr     x0, newline
    bl      printf

    // Restaurar registros y retornar
    mov     x0, #0                 // Código de retorno 0
    ldp     x29, x30, [sp], #16    // Restaurar frame pointer y link register
    ret                            // Regresar del programa
