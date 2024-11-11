/*=========================================================
 * Programa:     rotacion.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Rota los elementos de un arreglo a la izquierda
 *               o a la derecha. Los parámetros de entrada son:
 *               x0 = puntero al arreglo, x1 = tamaño del arreglo
 *               x2 = número de posiciones a rotar, x3 = dirección
 *               (0 = izquierda, 1 = derecha).
 * Compilación:  as -o rotacion.o rotacion.s
 *               gcc -o rotacion rotacion.o
 * Ejecución:    ./rotacion
 =========================================================*/

/*=========================================================
 * Código equivalente en C:
 * ---------------------------------------------------------
 * #include <stdio.h>
 * 
 * // Función que rota un arreglo
 * void rotar_arreglo(int *arr, int tam, int posiciones, int direccion) {
 *     if (tam == 0 || posiciones == 0) return;
 *     posiciones %= tam;  // Ajustar el número de rotaciones
 *     if (direccion == 0) {  // Rotación a la izquierda
 *         for (int i = 0; i < posiciones; i++) {
 *             int temp = arr[0];
 *             for (int j = 0; j < tam - 1; j++) {
 *                 arr[j] = arr[j + 1];
 *             }
 *             arr[tam - 1] = temp;
 *         }
 *     } else {  // Rotación a la derecha
 *         for (int i = 0; i < posiciones; i++) {
 *             int temp = arr[tam - 1];
 *             for (int j = tam - 1; j > 0; j--) {
 *                 arr[j] = arr[j - 1];
 *             }
 *             arr[0] = temp;
 *         }
 *     }
 * }
 * 
 * int main() {
 *     int arreglo[] = {1, 2, 3, 4, 5};  // Ejemplo de arreglo
 *     int tam = 5;                      // Tamaño del arreglo
 *     rotar_arreglo(arreglo, tam, 2, 0); // Rotar 2 posiciones a la izquierda
 *     for (int i = 0; i < tam; i++) {
 *         printf("%d ", arreglo[i]);
 *     }
 *     printf("\n");
 *     return 0;
 * }
 * ---------------------------------------------------------
 =========================================================*/

.section .text
.global rotar_arreglo
.global _start

// Función principal (main)
_start:
    // Arreglo de ejemplo
    adr x0, arreglo       // Dirección del arreglo
    mov x1, 5             // Tamaño del arreglo (5 elementos)
    mov x2, 2             // Número de posiciones a rotar
    mov x3, 0             // Dirección (0 = izquierda)

    // Llamada a rotar_arreglo
    bl rotar_arreglo

    // Aquí el arreglo está rotado
    // Para fines de prueba, podemos dejar el arreglo en x0
    // y terminar el programa

    // Salir del programa
    mov x8, #93           // syscall número 93 (exit)
    mov x0, #0            // código de salida 0
    svc #0                // Hacer la llamada al sistema para salir

// Arreglo de ejemplo
arreglo:
    .quad 1, 2, 3, 4, 5

// Función que rota un arreglo
// Entrada: x0 = puntero al arreglo, x1 = tamaño del arreglo
//          x2 = número de posiciones, x3 = dirección (0 = izquierda, 1 = derecha)
rotar_arreglo:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Ajustar el número de posiciones para que esté dentro del tamaño del arreglo
    udiv x2, x2, x1      // x2 %= x1 (número de rotaciones efectivas)

    // Si el tamaño es 0 o la rotación es nula, regresar
    cbz x1, rotacion_done
    cbz x2, rotacion_done

    // Seleccionar dirección de rotación
    cmp x3, 0
    beq rotacion_izquierda
    b rotacion_derecha

rotacion_izquierda:
    // Guardar el primer elemento temporalmente y hacer un shift a la izquierda
    ldr x4, [x0]         // Guardar el primer elemento en x4
    add x5, x0, 8        // Puntero al siguiente elemento

rotacion_izq_loop:
    // Desplazar elementos
    cmp x1, 1
    b.le rotacion_izq_store  // Si sólo queda un elemento, almacenar x4
    ldr x6, [x5]         // Cargar el siguiente elemento
    str x6, [x0], 8      // Desplazar a la izquierda
    mov x5, x0           // Mover puntero
    sub x1, x1, 1
    b rotacion_izq_loop

rotacion_izq_store:
    str x4, [x0]
    b rotacion_done

rotacion_derecha:
    // Guardar el último elemento temporalmente y hacer un shift a la derecha
    add x5, x0, x1, lsl #3 // Puntero al último elemento
    sub x5, x5, 8        // Ajustar para último índice
    ldr x4, [x5]         // Guardar último elemento en x4

rotacion_der_loop:
    // Desplazar elementos
    cmp x1, 1
    b.le rotacion_der_store  // Si sólo queda un elemento, almacenar x4
    ldr x6, [x5, -8]     // Cargar el elemento anterior
    str x6, [x5]         // Desplazar a la derecha
    mov x5, x5           // Ajustar puntero
    sub x1, x1, 1
    b rotacion_der_loop

rotacion_der_store:
    str x4, [x5]
    b rotacion_done

rotacion_done:
    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret
