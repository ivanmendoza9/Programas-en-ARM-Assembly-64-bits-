/*=======================================================
 * Programa:     FuncionDePrueba.s
 * Autor:        IVAN MENDOZA
 * Fecha:        10 de Noviembre 2024
 * Descripción:  Función de prueba que realiza operaciones matemáticas en un bucle.
 *               Realiza un conjunto de operaciones de suma, desplazamiento, multiplicación
 *               y división durante un número determinado de iteraciones.
 * Compilación:  as -o FuncionDePrueba.o FuncionDePrueba.s
 *               ld -o FuncionDePrueba FuncionDePrueba.o
 * Ejecución:    ./FuncionDePrueba
 =========================================================*/

/* Código en C equivalente:

#include <stdio.h>

int FuncionDePrueba(int iteraciones) {
    int x1 = 1; // Acumulador
    int x3 = 7; // Constante para multiplicación
    int x4 = 3; // Constante para división
    
    for (int i = 0; i < iteraciones; i++) {
        // Realizar algunas operaciones matemáticas
        x1 = x1 + x1;    // x1 = x1 + x1
        int x2 = x1 >> 1; // x2 = x1 >> 1
        x1 = x1 + x2;    // x1 = x1 + x2
        x1 = x1 * x3;    // x1 = x1 * 7
        x1 = x1 / x4;    // x1 = x1 / 3
    }
    
    return x1; // Retornar el resultado
}

int main() {
    int iteraciones = 5;
    int resultado = FuncionDePrueba(iteraciones);
    printf("Resultado: %d\n", resultado);
    return 0;
}
*/

.global FuncionDePrueba

// Función de prueba que realiza operaciones matemáticas en un bucle
// Parámetro x0: número de iteraciones
// Retorna: resultado de las operaciones
FuncionDePrueba:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    // Guardar el número de iteraciones
    mov x19, x0
    
    // Inicializar acumulador y constantes
    mov x1, #1          // Acumulador
    mov x3, #7          // Constante para multiplicación
    mov x4, #3          // Constante para división
    
bucle:
    // Verificar si quedan iteraciones
    cbz x19, fin
    
    // Realizar algunas operaciones matemáticas
    add x1, x1, x1      // x1 = x1 + x1
    lsr x2, x1, #1      // x2 = x1 >> 1
    add x1, x1, x2      // x1 = x1 + x2
    mul x1, x1, x3      // x1 = x1 * 7
    udiv x1, x1, x4     // x1 = x1 / 3
    
    // Decrementar contador
    sub x19, x19, #1
    
    // Continuar bucle
    b bucle
    
fin:
    // Mover resultado a x0 para retorno
    mov x0, x1
    
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
