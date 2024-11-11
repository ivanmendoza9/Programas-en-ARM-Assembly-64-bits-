/*=========================================================
 * Programa:     LongestCommonPrefix.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Función que encuentra el prefijo común más largo
 *               entre dos cadenas de caracteres.
 * Compilación:  gcc -o LongestCommonPrefix LongestCommonPrefix.c
 * Ejecución:    ./LongestCommonPrefix <cadena1> <cadena2>
 =========================================================*/

/* Código en C:
* #include <stdio.h>
* 
* // Función para encontrar el prefijo común más largo
* int LongestCommonPrefix(char* str1, char* str2) {
*     int i = 0;
*     // Comparar los caracteres hasta encontrar una diferencia o el final de una cadena
*     while (str1[i] != '\0' && str2[i] != '\0' && str1[i] == str2[i]) {
*         i++;
*     }
*     return i;  // Devolver la longitud del prefijo común
* }
* 
* int main() {
*     char str1[] = "programming";
*     char str2[] = "programmer";
*     
*     int result = LongestCommonPrefix(str1, str2);
*     printf("El prefijo común más largo tiene %d caracteres.\n", result);
*     return 0;
* }
*/

.global LongestCommonPrefix

LongestCommonPrefix:
    stp x29, x30, [sp, -16]!   // Guardar el frame anterior y el link register
    mov x29, sp                 // Crear un nuevo frame
    mov x3, x0                  // Dirección de la primera cadena
    mov x4, x1                  // Dirección de la segunda cadena
    mov w5, 0                   // Contador de caracteres en común

compara_caracteres:
    uxtw x6, w5                 // Expandir w5 a 64 bits en x6
    ldrb w7, [x3, x6]           // Leer el carácter de la primera cadena
    ldrb w8, [x4, x6]           // Leer el carácter de la segunda cadena
    cmp w7, w8                  // Comparar los caracteres
    b.ne fin                    // Si no son iguales, fin del prefijo común
    cmp w7, 0                   // Si encontramos un nulo, también terminar
    b.eq fin
    add w5, w5, 1               // Incrementar el contador de caracteres en común
    b compara_caracteres

fin:
    mov w0, w5                  // El resultado es el número de caracteres en común
    ldp x29, x30, [sp], 16      // Restaurar el frame y el link register
    ret
