/*=======================================================
 * Programa:     EscribirArchivo.s
 * Autor:        IVAN MENDOZA
 * Fecha:        19 de Noviembre 2024
 * Descripción:  Función que escribe un número en un archivo de texto. El número se convierte
 *               de entero a string antes de ser escrito. Si el archivo no existe, se crea.
 * Compilación:  as -o EscribirArchivo.o EscribirArchivo.s
 *               gcc -o EscribirArchivo EscribirArchivo.o
 * Ejecución:    ./EscribirArchivo
 =========================================================*/

/*
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Declarar variables
    FILE *fileptr;               // Puntero para el archivo
    char input[100];             // Buffer para la entrada del usuario

    // Mensajes del sistema
    const char *filename = "salida.txt";  // Nombre del archivo
    const char *mode = "w";              // Modo de apertura del archivo

    // Crear archivo
    printf("Creando Archivo\n");
    fileptr = fopen(filename, mode);
    if (fileptr == NULL) {
        printf("Error en creación de archivo\n");
        return 1;
    }
    printf("Archivo creado con éxito\n");

    // Pedir mensaje al usuario
    printf("Introduce mensaje para escribir en el archivo: ");
    if (scanf("%[^\n]", input) != 1) {
        printf("Error en introducción de mensaje\n");
        fclose(fileptr);  // Cerrar el archivo antes de salir
        return 1;
    }

    // Escribir en archivo
    if (fprintf(fileptr, "%s", input) < 0) {
        printf("Error en introducción de mensaje\n");
        fclose(fileptr);  // Cerrar el archivo antes de salir
        return 1;
    }
    fclose(fileptr);
    printf("Mensaje introducido con éxito\n");

    return 0;  // Salida exitosa
}
*/

.data
    // Mensajes del sistema
    msg_creando: .asciz "Creando Archivo\n"
    msg_exito_crear: .asciz "Archivo creado con éxito\n"
    msg_error_crear: .asciz "Error en creación de archivo\n"
    msg_pedir: .asciz "Introduce mensaje para escribir en el archivo: "
    msg_exito_escribir: .asciz "Mensaje introducido con éxito\n"
    msg_error_escribir: .asciz "Error en introducción de mensaje\n"
    
    // Archivo y buffer
    filename: .asciz "salida.txt"
    mode: .asciz "w"
    input: .space 100
    formato: .asciz "%[^\n]"
    
    // Descriptor de archivo
    .align 8
    fileptr: .skip 8

.text
.global main
.extern fopen
.extern fprintf
.extern printf
.extern scanf
.extern fclose

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar "Creando Archivo"
    adrp x0, msg_creando
    add x0, x0, :lo12:msg_creando
    bl printf
    
    // Abrir archivo
    adrp x0, filename
    add x0, x0, :lo12:filename
    adrp x1, mode
    add x1, x1, :lo12:mode
    bl fopen
    
    // Guardar file pointer
    adrp x1, fileptr
    add x1, x1, :lo12:fileptr
    str x0, [x1]
    
    // Verificar si se abrió correctamente
    cmp x0, #0
    beq error_crear
    
    // Mostrar éxito en creación
    adrp x0, msg_exito_crear
    add x0, x0, :lo12:msg_exito_crear
    bl printf
    
    // Pedir mensaje al usuario
    adrp x0, msg_pedir
    add x0, x0, :lo12:msg_pedir
    bl printf
    
    // Leer mensaje del usuario
    adrp x0, formato
    add x0, x0, :lo12:formato
    adrp x1, input
    add x1, x1, :lo12:input
    bl scanf
    
    // Verificar lectura exitosa
    cmp x0, #1
    bne error_escribir
    
    // Escribir en archivo
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    adrp x1, input
    add x1, x1, :lo12:input
    bl fprintf
    
    // Cerrar archivo
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    bl fclose
    
    // Mostrar éxito en escritura
    adrp x0, msg_exito_escribir
    add x0, x0, :lo12:msg_exito_escribir
    bl printf
    
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret

error_crear:
    // Mostrar error en creación
    adrp x0, msg_error_crear
    add x0, x0, :lo12:msg_error_crear
    bl printf
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret

error_escribir:
    // Mostrar error en escritura
    adrp x0, msg_error_escribir
    add x0, x0, :lo12:msg_error_escribir
    bl printf
    // Cerrar archivo antes de salir
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    bl fclose
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret
