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

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * int Sumar(int a, int b) {
 *     return a + b;
 * }
 * 
 * int Restar(int a, int b) {
 *     return a - b;
 * }
 * 
 * int Multiplicar(int a, int b) {
 *     return a * b;
 * }
 * 
 * int Dividir(int a, int b) {
 *     if (b == 0) {
 *         return 0;  // División por cero
 *     }
 *     return a / b;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.global Sumar
.global Restar
.global Multiplicar
.global Dividir

// Suma: retorna a + b
Sumar:
    add w0, w0, w1       // Sumar el primer y segundo argumento en w0
    ret

// Resta: retorna a - b
Restar:
    sub w0, w0, w1       // Restar el segundo argumento de w0
    ret

// Multiplicación: retorna a * b
Multiplicar:
    mul w0, w0, w1       // Multiplicar w0 * w1 y almacenar en w0
    ret

// División: retorna a / b (b debe ser distinto de 0)
Dividir:
    cbz w1, div_by_zero  // Comprobar si el divisor es 0
    sdiv w0, w0, w1      // Dividir w0 / w1 y almacenar en w0
    ret

div_by_zero:
    mov w0, 0            // Si el divisor es 0, retornar 0
    ret
