/*=========================================================
 * Programa:     LongestCommonPrefix.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Función que encuentra el prefijo común más largo
 *               entre dos cadenas de caracteres.
 * Compilación:  gcc -o LongestCommonPrefix LongestCommonPrefix.c
 * Ejecución:    ./LongestCommonPrefix <cadena1> <cadena2>
 =========================================================*/

/*
#include <stdio.h>
#include <string.h> // Para funciones como strlen

#define MAX_LEN 100

int main() {
    // Buffers para cadenas
    char str1[MAX_LEN], str2[MAX_LEN], str3[MAX_LEN];
    char suffix[MAX_LEN];

    // Solicitar al usuario las cadenas
    printf("Ingresa 3 cadenas\n");

    printf("Ingresa la cadena 1: ");
    scanf(" %99s", str1);

    printf("Ingresa la cadena 2: ");
    scanf(" %99s", str2);

    printf("Ingresa la cadena 3: ");
    scanf(" %99s", str3);

    // Calcular las longitudes de las cadenas
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    int len3 = strlen(str3);

    // Encontrar el sufijo común más largo
    int suffix_len = 0;
    while (suffix_len < len1 && suffix_len < len2 && suffix_len < len3) {
        // Comparar caracteres desde el final
        char c1 = str1[len1 - 1 - suffix_len];
        char c2 = str2[len2 - 1 - suffix_len];
        char c3 = str3[len3 - 1 - suffix_len];

        if (c1 != c2 || c1 != c3) {
            break; // Si no coinciden, terminar
        }

        // Guardar carácter en el sufijo
        suffix[suffix_len] = c1;
        suffix_len++;
    }

    if (suffix_len == 0) {
        // No hay sufijo común
        printf("No hay sufijo común\n");
    } else {
        // Revertir el sufijo (ya que fue guardado al revés)
        for (int i = 0; i < suffix_len / 2; i++) {
            char temp = suffix[i];
            suffix[i] = suffix[suffix_len - 1 - i];
            suffix[suffix_len - 1 - i] = temp;
        }

        // Agregar null terminator
        suffix[suffix_len] = '\0';

        // Imprimir resultado
        printf("El sufijo común más largo es: %s\n", suffix);
    }

    return 0;
}
*/



.data
    // Mensajes del programa
    prompt_count: .string "Ingresa 3 cadenas\n"
    prompt_str: .string "Ingresa la cadena %d: "
    result_msg: .string "El sufijo común más largo es: "
    no_prefix: .string "No hay sufijo común\n"
    error_msg: .string "Error al leer la cadena\n"
    newline: .string "\n"
    read_str: .string " %99[^\n]"
    
    // Buffers para almacenar las cadenas
    str1: .skip 100
    str2: .skip 100
    str3: .skip 100
    suffix: .skip 100

.text
.global main

strlen:
    mov x2, #0 // Contador
1:  ldrb w1, [x0, x2] // Cargar byte
    cbz w1, 2f // Si es 0, terminar
    add x2, x2, #1 // Incrementar contador
    b 1b
2:  mov x0, x2 // Retornar longitud
    ret

main:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Mostrar mensaje inicial
    adr x0, prompt_count
    bl printf

    // Leer las 3 cadenas
    mov x20, #0 // Contador de cadenas
read_strings:
    // Seleccionar buffer de destino
    adr x21, str1
    cmp x20, #1
    b.eq use_str2
    cmp x20, #2
    b.eq use_str3
    b continue_read
use_str2:
    adr x21, str2
    b continue_read
use_str3:
    adr x21, str3

continue_read:
    // Imprimir prompt
    adr x0, prompt_str
    add x1, x20, #1
    bl printf

    // Leer cadena
    adr x0, read_str
    mov x1, x21
    bl scanf

    // Verificar error de lectura
    cmp x0, #1
    bne read_error

    // Limpiar buffer de entrada
    bl __fpurge

    add x20, x20, #1
    cmp x20, #3
    b.lt read_strings

    // Obtener longitudes de las cadenas
    adr x0, str1
    bl strlen
    mov x21, x0 // x21 = longitud str1

    adr x0, str2
    bl strlen
    mov x22, x0 // x22 = longitud str2

    adr x0, str3
    bl strlen
    mov x23, x0 // x23 = longitud str3

find_suffix:
    mov x20, #0 // Contador de caracteres coincidentes
check_char:
    // Comparar caracteres desde el final
    adr x0, str1
    sub x1, x21, x20
    sub x1, x1, #1
    ldrb w24, [x0, x1] // Cargar carácter de str1

    adr x0, str2
    sub x1, x22, x20
    sub x1, x1, #1
    ldrb w25, [x0, x1] // Cargar carácter de str2
    cmp w24, w25
    b.ne print_result // Si son diferentes, terminar

    adr x0, str3
    sub x1, x23, x20
    sub x1, x1, #1
    ldrb w25, [x0, x1] // Cargar carácter de str3
    cmp w24, w25
    b.ne print_result // Si son diferentes, terminar

    // Guardar carácter en el sufijo (desde el final)
    adr x0, suffix
    strb w24, [x0, x20]
    add x20, x20, #1 // Incrementar contador

    // Verificar si hemos llegado al inicio de alguna cadena
    cmp x20, x21
    b.ge print_result
    cmp x20, x22
    b.ge print_result
    cmp x20, x23
    b.ge print_result
    b check_char

print_result:
    // Verificar si hay sufijo
    cmp x20, #0
    b.eq no_common_suffix

    // Imprimir mensaje de resultado
    adr x0, result_msg
    bl printf

    // Revertir el sufijo (ya que lo guardamos al revés)
    adr x0, suffix
    mov x1, #0 // índice inicio
    sub x2, x20, #1 // índice final
reverse_loop:
    cmp x1, x2
    b.ge end_reverse
    ldrb w3, [x0, x1] // temp = str[i]
    ldrb w4, [x0, x2] // temp2 = str[j]
    strb w4, [x0, x1] // str[i] = temp2
    strb w3, [x0, x2] // str[j] = temp
    add x1, x1, #1
    sub x2, x2, #1
    b reverse_loop
end_reverse:
    // Agregar null terminator
    adr x0, suffix
    strb wzr, [x0, x20]

    // Imprimir sufijo
    adr x0, suffix
    bl printf

    // Imprimir nueva línea
    adr x0, newline
    bl printf
    b exit

no_common_suffix:
    adr x0, no_prefix
    bl printf
    b exit

read_error:
    adr x0, error_msg
    bl printf

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
