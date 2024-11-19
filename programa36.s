/*=========================================================
 * Programa:     grande.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Encuentra el segundo elemento más grande
 *               en un arreglo de enteros. Los parámetros de
 *               entrada son: x0 = puntero al arreglo, 
 *               x1 = tamaño del arreglo.
 * Compilación:  as -o grande.o grande.s
 *               gcc -o grande grande.o
 * Ejecución:    ./grande
 =========================================================*/

// #include <stdio.h> // Biblioteca estándar para funciones de entrada y salida

// int main() { // Función principal

//     // Mensajes del programa
//     char *msg_titulo = " Buscador del Segundo Número Mayor\n"; // Mensaje de título
//     char *msg_array = " Arreglo actual: ";                    // Mensaje de arreglo
//     char *msg_result = " El segundo número más grande es: %d\n"; // Mensaje de resultado
//     char *msg_error = " Error: El arreglo debe tener al menos 2 elementos\n"; // Mensaje de error
//     char *format_int = "%d "; // Formato para imprimir enteros
//     char *newline = "\n";     // Nueva línea

//     // Arreglo de ejemplo y su tamaño
//     int array[] = {15, 8, 23, 42, 4, 16, 55, 37, 11, 22}; // Ejemplo de arreglo con 10 números
//     int array_size = 10; // Tamaño del arreglo

//     // Imprimir título
//     printf("%s", msg_titulo); // Mostrar título

//     // Verificar que el arreglo tenga al menos 2 elementos
//     if (array_size < 2) { // Si el tamaño es menor a 2, mostrar error
//         printf("%s", msg_error); // Imprimir mensaje de error
//         return 1; // Terminar programa con error
//     }

//     // Mostrar arreglo actual
//     printf("%s", msg_array); // Imprimir mensaje de arreglo

//     // Bucle para imprimir cada elemento del arreglo
//     for (int i = 0; i < array_size; i++) { // Recorrer todos los elementos
//         printf(format_int, array[i]); // Imprimir cada elemento
//     }
//     printf("%s", newline); // Imprimir nueva línea después del arreglo

//     // Inicializar variables para encontrar los dos máximos
//     int max1 = array[0]; // Primer número máximo
//     int max2 = array[0]; // Segundo número máximo
//     for (int i = 1; i < array_size; i++) { // Recorrer el arreglo desde el segundo elemento

//         // Si el elemento actual es mayor que max1
//         if (array[i] > max1) {
//             max2 = max1; // El antiguo máximo pasa a ser segundo máximo
//             max1 = array[i]; // Actualizar el máximo actual
//         } else if (array[i] > max2 && array[i] != max1) {
//             // Si el elemento es mayor que max2 y no es igual a max1, actualizar max2
//             max2 = array[i];
//         }
//     }

//     // Imprimir el segundo máximo
//     printf(msg_result, max2); // Mostrar el segundo número más grande

//     return 0; // Finalización exitosa del programa
// }


.data
    // Mensajes del programa
    msg_titulo:  .asciz " Buscador del Segundo Número Mayor\n"
    msg_array:   .asciz " Arreglo actual: "
    msg_result:  .asciz " El segundo número más grande es: %d\n"
    msg_error:   .asciz " Error: El arreglo debe tener al menos 2 elementos\n"
    format_int:  .asciz "%d "    // Formato para imprimir enteros
    newline:     .asciz "\n"
    
    // Arreglo de ejemplo y su tamaño
    .align 4
    array:      .word  15, 8, 23, 42, 4, 16, 55, 37, 11, 22  // Ejemplo: 10 números
    array_size: .word  10
    
.text
.global main
.extern printf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Imprimir título
    adrp x0, msg_titulo
    add x0, x0, :lo12:msg_titulo
    bl printf
    
    // Cargar dirección y tamaño del array
    adrp x19, array
    add x19, x19, :lo12:array    // x19 = dirección base del array
    adrp x20, array_size
    add x20, x20, :lo12:array_size
    ldr w20, [x20]               // w20 = tamaño del array
    
    // Verificar que el array tenga al menos 2 elementos
    cmp w20, #2
    blt error
    
    // Mostrar arreglo actual
    adrp x0, msg_array
    add x0, x0, :lo12:msg_array
    bl printf
    
    // Imprimir elementos del array
    mov w21, #0                  // w21 = contador
print_loop:
    cmp w21, w20
    beq end_print
    
    adrp x0, format_int
    add x0, x0, :lo12:format_int
    ldr w1, [x19, w21, SXTW #2]  // Cargar elemento actual
    bl printf
    
    add w21, w21, #1
    b print_loop
    
end_print:
    // Nueva línea después de imprimir array
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    
    // Inicializar variables para búsqueda
    ldr w22, [x19]              // w22 = primer máximo
    mov w23, w22                // w23 = segundo máximo
    mov w21, #1                 // w21 = índice para recorrer
    
find_loop:
    cmp w21, w20                // Comparar con tamaño del array
    beq show_result
    
    ldr w24, [x19, w21, SXTW #2]  // w24 = elemento actual
    
    // Comparar con máximo actual
    cmp w24, w22
    blt check_second            // Si es menor, ver si es segundo máximo
    
    // Actualizar máximos
    mov w23, w22               // Anterior máximo pasa a ser segundo
    mov w22, w24              // Nuevo máximo encontrado
    b next_iter
    
check_second:
    cmp w24, w23              // Comparar con segundo máximo
    ble next_iter            // Si es menor o igual, siguiente iteración
    mov w23, w24            // Actualizar segundo máximo
    
next_iter:
    add w21, w21, #1
    b find_loop
    
error:
    adrp x0, msg_error
    add x0, x0, :lo12:msg_error
    bl printf
    mov w0, #1
    b exit
    
show_result:
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    mov w1, w23                // Pasar segundo máximo como argumento
    bl printf
    mov w0, #0
    
exit:
    // Epílogo
    ldp x29, x30, [sp], #16
    ret
