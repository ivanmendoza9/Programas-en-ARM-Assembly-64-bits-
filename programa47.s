/*=======================================================
 * Programa:     DetectOverflow.s
 * Autor:        IVAN MENDOZA
 * Fecha:        10 de Noviembre 2024
 * Descripción:  Función que detecta desbordamiento en la suma de dos números enteros.
 *               Si el resultado de la suma excede los límites de un entero de 32 bits,
 *               retorna 1, de lo contrario, retorna 0.
 * Compilación:  as -o DetectOverflow.o DetectOverflow.s
 *               ld -o DetectOverflow DetectOverflow.o
 * Ejecución:    ./DetectOverflow
 =========================================================*/

/* Código en C equivalente 

* #include <stdio.h>
* 
* int DetectOverflow(int a, int b) {
*     int sum = a + b;
*     
*     // Verificar desbordamiento positivo
*     if ((a > 0 && b > 0 && sum < 0)) {
*         return 1;  // Overflow
*     }
*     
*     // Verificar desbordamiento negativo
*     if ((a < 0 && b < 0 && sum >= 0)) {
*         return 1;  // Overflow
*     }
*     
*     return 0;  // No overflow
* }
* 
* int main() {
*     int a = 2147483647; // Maximo valor de int (2^31 - 1)
*     int b = 1;
*     
*     int result = DetectOverflow(a, b);
*     if (result) {
*         printf("Overflow detected!\n");
*     } else {
*         printf("No overflow.\n");
*     }
* 
*     return 0;
* }
*/

.global DetectOverflow

DetectOverflow:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    
    // Guardar los números originales
    mov w2, w0  // Primer número en w2
    mov w3, w1  // Segundo número en w3
    
    // Realizar la suma con detección de desbordamiento
    adds w4, w2, w3
    
    // Verificar desbordamiento positivo
    // Si a > 0 y b > 0 pero suma < 0, hay desbordamiento
    cmp w2, #0
    b.le check_negative
    cmp w3, #0
    b.le no_overflow
    cmp w4, #0
    b.lt overflow
    b no_overflow

check_negative:
    // Verificar desbordamiento negativo
    // Si a < 0 y b < 0 pero suma >= 0, hay desbordamiento
    cmp w2, #0
    b.ge no_overflow
    cmp w3, #0
    b.ge no_overflow
    cmp w4, #0
    b.ge overflow
    b no_overflow

overflow:
    mov w0, #1      // Retornar 1 si hay desbordamiento
    b end

no_overflow:
    mov w0, #0      // Retornar 0 si no hay desbordamiento

end:
    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
