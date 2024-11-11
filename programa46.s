/*=========================================================
 * Programa:     EsArmstrong.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Determina si un número es un número Armstrong
 *               (la suma de los dígitos elevados a la potencia del número
 *               de dígitos es igual al número original).
 * Compilación:  gcc -o EsArmstrong EsArmstrong.c
 * Ejecución:    ./EsArmstrong <numero>
 =========================================================*/

/* Código en C:
#include <stdio.h>
#include <math.h>

// Función para determinar si un número es Armstrong
int EsArmstrong(int num) {
    int original = num;
    int suma = 0;
    int digitos = 0;

    // Contar el número de dígitos
    while (num > 0) {
        num /= 10;
        digitos++;
    }

    num = original;

    // Calcular la suma de las potencias
    while (num > 0) {
        int digito = num % 10;
        suma += pow(digito, digitos);
        num /= 10;
    }

    // Verificar si la suma es igual al número original
    return suma == original;
}

int main() {
    int num;

    // Leer el número
    printf("Ingrese un número: ");
    scanf("%d", &num);

    // Verificar si es un número Armstrong
    if (EsArmstrong(num)) {
        printf("%d es un número Armstrong.\n", num);
    } else {
        printf("%d no es un número Armstrong.\n", num);
    }

    return 0;
}
*/

.global EsArmstrong

EsArmstrong:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0                  // Guardar número original
    mov x1, x0                   // Copiar número para contar dígitos
    mov x3, 0                    // Inicializar contador de dígitos

contar_digitos:
    cbz x1, preparar_calculo     // Si x1 es 0, terminar conteo
    udiv x1, x1, #10            // Dividir por 10
    add x3, x3, #1              // Incrementar contador
    b contar_digitos

preparar_calculo:
    mov x1, x19                 // Restaurar número original
    mov x2, #0                  // Inicializar suma de potencias

procesar_digitos:
    cbz x1, verificar           // Si no hay más dígitos, verificar resultado
    
    // Obtener último dígito
    mov x4, x1                  // Copiar número actual
    udiv x4, x4, #10           // Dividir por 10
    msub x4, x4, #10, x1       // x4 = x1 - (x4 * 10) -> último dígito
    udiv x1, x1, #10           // Actualizar número removiendo último dígito
    
    // Calcular potencia
    mov x5, x4                  // Base = dígito
    mov x6, #1                  // Resultado inicial = 1
    mov x7, x3                  // Contador = número de dígitos

calcular_potencia:
    cbz x7, sumar_potencia     // Si contador es 0, sumar resultado
    mul x6, x6, x5             // Multiplicar por base
    sub x7, x7, #1             // Decrementar contador
    b calcular_potencia

sumar_potencia:
    add x2, x2, x6             // Sumar potencia al total
    b procesar_digitos

verificar:
    cmp x2, x19                // Comparar suma con número original
    cset w0, eq                // Establecer resultado (1 si igual, 0 si no)
    
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
