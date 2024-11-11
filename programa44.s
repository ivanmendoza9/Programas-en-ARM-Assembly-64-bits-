/*=========================================================
 * Programa:     GenerarAleatorio.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementa un generador de números pseudoaleatorios
 *               usando la fórmula (semilla * 1103515245 + 12345) & 0x7FFFFFFF
 * Compilación:  gcc -o GenerarAleatorio GenerarAleatorio.c
 * Ejecución:    ./GenerarAleatorio <semilla>
 =========================================================*/

/* Código en C:
* #include <stdio.h>
* 
* // Función para generar un número pseudoaleatorio
* unsigned int GenerarAleatorio(unsigned int semilla) {
*     return (semilla * 1103515245 + 12345) & 0x7FFFFFFF;
* }
* 
* int main() {
*     unsigned int semilla;
* 
*     // Leer la semilla desde la entrada
*     printf("Ingrese la semilla: ");
*     scanf("%u", &semilla);
* 
*     // Generar el número aleatorio
*     unsigned int aleatorio = GenerarAleatorio(semilla);
* 
*     // Mostrar el resultado
*     printf("Número aleatorio generado: %u\n", aleatorio);
* 
*     return 0;
* }
*/

.global GenerarAleatorio

GenerarAleatorio:
    // w0 contiene la semilla de entrada

    // Cargar el valor 1103515245 en w1 usando instrucciones separadas
    movz w1, 0x49E3        // Parte inferior del número (16 bits)
    movk w1, 0x4E35, lsl #16  // Parte superior del número (añadir a los bits altos)

    mov w2, 12345          // Incremento

    // Realizar el cálculo: semilla = (semilla * 1103515245 + 12345) & 0x7FFFFFFF
    mul w0, w0, w1         // Multiplica semilla por 1103515245
    add w0, w0, w2         // Suma 12345
    and w0, w0, 0x7FFFFFFF // Asegurarse de que esté en el rango de 0 a 2^31-1
    ret
