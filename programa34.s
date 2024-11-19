/*=========================================================
 * Programa:     invertir.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Invierte los elementos de un arreglo de enteros
 *               de 64 bits. El puntero al arreglo se pasa en x0
 *               y el tamaño del arreglo se pasa en x1. El
 *               resultado se almacena en el mismo arreglo.
 * Compilación:  as -o invertir.o invertir.s
 *               gcc -o invertir invertir.o
 * Ejecución:    ./invertir
 =========================================================*/

 /*
 #include <stdio.h> // Biblioteca estándar para funciones de entrada y salida

      //int main() { // Función principal

        // Declaración del arreglo y su tamaño
         //  int arreglo[] = {1, 2, 3, 4, 5, 6, 7, 8}; // Arreglo con 8 elementos enteros
        //int tamano_arreglo = 8; // Tamaño del arreglo

        // Imprimir mensaje inicial antes de invertir el arreglo
        //printf("\nArreglo original:\n");

        // Bucle para recorrer e imprimir cada elemento del arreglo original
        //for (int i = 0; i < tamano_arreglo; i++) {
        // Imprimir el índice y el valor del elemento en esa posición
        //  printf("Elemento[%d] = %d\n", i, arreglo[i]);
        //}

        // Inicialización de índices para el proceso de inversión
        //int inicio = 0; // Índice de inicio (primer elemento del arreglo)
        //int fin = tamano_arreglo - 1; // Índice de fin (último elemento del arreglo)

        // Bucle para invertir el arreglo
        //while (inicio < fin) {
        // Intercambio de elementos en las posiciones inicio y fin
        //  int temp = arreglo[inicio]; // Guardar temporalmente el valor en la posición inicio
        //arreglo[inicio] = arreglo[fin]; // Mover el valor de la posición fin a la posición inicio
        //arreglo[fin] = temp; // Colocar el valor guardado en temp en la posición fin

        // Actualizar los índices para acercarse al centro del arreglo
        //inicio++; // Avanzar el índice de inicio
        //fin--; // Retroceder el índice de fin
        //}

      // Imprimir mensaje después de invertir el arreglo
      //printf("\nArreglo invertido:\n");

      // Bucle para recorrer e imprimir cada elemento del arreglo invertido
      //for (int i = 0; i < tamano_arreglo; i++) {
        // Imprimir el índice y el valor del elemento en esa posición
      //  printf("Elemento[%d] = %d\n", i, arreglo[i]);
      //}

    //return 0; // Finalización exitosa del programa
    //}
*/

.section .rodata
format_antes: .asciz "\nArreglo original:\n"
format_despues: .asciz "\nArreglo invertido:\n"
format_elemento: .asciz "Elemento[%d] = %d\n"

.section .data
array: .word 1, 2, 3, 4, 5, 6, 7, 8    // Arreglo de 8 elementos
array_size: .word 8                     // Tamaño del arreglo

.text
.global main
.type main, %function

main:
    // Prólogo de la función
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp                 // Establecer frame pointer

    // Guardar registros callee-saved
    stp     x19, x20, [sp, -16]!   // x19 = inicio, x20 = fin
    stp     x21, x22, [sp, -16]!   // x21 = dirección base, x22 = tamaño

    // Cargar dirección del arreglo y su tamaño
    adrp    x21, array
    add     x21, x21, :lo12:array   // x21 = dirección base del arreglo
    adrp    x22, array_size
    add     x22, x22, :lo12:array_size
    ldr     w22, [x22]             // w22 = tamaño del arreglo

    // Imprimir mensaje "Arreglo original"
    adrp    x0, format_antes
    add     x0, x0, :lo12:format_antes
    bl      printf

    // Mostrar arreglo original
    mov     x20, #0                // contador = 0
print_original:
    cmp     x20, x22
    b.ge    start_inversion

    // Imprimir elemento actual
    adrp    x0, format_elemento
    add     x0, x0, :lo12:format_elemento
    mov     x1, x20                // índice
    ldr     w2, [x21, x20, lsl #2] // valor
    bl      printf

    add     x20, x20, #1          // contador++
    b       print_original

start_inversion:
    // Inicializar índices para inversión
    mov     x19, #0               // inicio = 0
    sub     x20, x22, #1          // fin = tamaño - 1

loop_inversion:
    // Verificar si hemos terminado
    cmp     x19, x20
    b.ge    print_invertido

    // Cargar elementos a intercambiar
    ldr     w23, [x21, x19, lsl #2]  // temp1 = array[inicio]
    ldr     w24, [x21, x20, lsl #2]  // temp2 = array[fin]

    // Intercambiar elementos
    str     w24, [x21, x19, lsl #2]  // array[inicio] = temp2
    str     w23, [x21, x20, lsl #2]  // array[fin] = temp1

    // Actualizar índices
    add     x19, x19, #1          // inicio++
    sub     x20, x20, #1          // fin--
    b       loop_inversion

print_invertido:
    // Imprimir mensaje "Arreglo invertido"
    adrp    x0, format_despues
    add     x0, x0, :lo12:format_despues
    bl      printf

    // Mostrar arreglo invertido
    mov     x20, #0               // contador = 0
print_final:
  cmp     x20, x22
    b.ge    end

    // Imprimir elemento actual
    adrp    x0, format_elemento
    add     x0, x0, :lo12:format_elemento
    mov     x1, x20               // índice
    ldr     w2, [x21, x20, lsl #2] // valor
    bl      printf

    add     x20, x20, #1         // contador++
    b       print_final

end:
    // Restaurar registros
    ldp     x21, x22, [sp], 16
    ldp     x19, x20, [sp], 16

    // Epílogo de la función
    mov     w0, #0               // Valor de retorno
    ldp     x29, x30, [sp], 16
    ret

.size main, .-main
