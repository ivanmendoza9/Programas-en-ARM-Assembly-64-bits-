/*=========================================================
 * Programa:     cola.s
 * Autor:        IVAN MENDOZA
 * Fecha:        11 de noviembre de 2024
 * Descripción:  Implementación de una cola circular simple usando
 *               memoria estática, con funciones para 
 *               inicializarla, encolar, desencolar, y verificar
 *               si está vacía o llena.
 * Compilación:  as -o cola.o cola.s
 *               gcc -o cola cola.o
 * Ejecución:    ./cola
 =========================================================*/

/*
#include <stdio.h>
#define MAX_SIZE 50

// Definición de la cola
int queue[MAX_SIZE];
int front = 0;
int rear = 0;

// Función para convertir entero a cadena y devolver el puntero al buffer
char* int_to_string(int num, char* buffer) {
    sprintf(buffer, "%d", num);
    return buffer;
}

// Función para imprimir un mensaje
void print_string(const char* msg) {
    printf("%s", msg);
}

// Función enqueue: inserta un elemento en la cola si no está llena
void enqueue(int value) {
    char buffer[20];
    
    if (rear >= MAX_SIZE) {
        print_string("Error: Cola llena\n");
        return;
    }

    print_string("Insertando valor en la cola: ");
    print_string(int_to_string(value, buffer));
    print_string("\n");

    queue[rear++] = value;
}

// Función dequeue: extrae un elemento de la cola si no está vacía
void dequeue() {
    char buffer[20];

    if (front == rear) {
        print_string("Error: Cola vacia\n");
        return;
    }

    print_string("Extrayendo valor de la cola: ");
    print_string(int_to_string(queue[front++], buffer));
    print_string("\n");
}

// Función principal
int main() {
    print_string("Creando cola...\n");

    // Pruebas de inserción
    enqueue(42);
    enqueue(73);
    enqueue(100);

    // Pruebas de extracción
    dequeue();
    dequeue();
    dequeue();
    dequeue();  // Intentar dequeue en cola vacía

    // Probar inserción después de vaciar
    enqueue(55);
    dequeue();

    return 0;
}
*/


.data
    queue:          .skip 400        // Espacio para 50 elementos de 8 bytes
    front:          .quad 0          // Índice del frente de la cola
    rear:           .quad 0          // Índice del final de la cola
    max_size:       .quad 50         // Tamaño máximo de la cola
    err_full:       .string "Error: Cola llena\n"
    err_empty:      .string "Error: Cola vacia\n"
    msg_enqueue:    .string "Insertando valor en la cola: "
    msg_dequeue:    .string "Extrayendo valor de la cola: "
    msg_create:     .string "Creando cola...\n"
    newline:        .string "\n"
    buffer:         .skip 20         // Buffer para convertir números a string

.text
.global main

// Función para convertir un número a string
// X0 contiene el número a convertir
// X1 contiene la dirección del buffer
int_to_string:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    add x1, x1, #19            // Comenzar desde el final del buffer
    mov x2, #0                 // Terminador nulo
    strb w2, [x1]
    mov x2, #10               // Divisor
    
1:  sub x1, x1, #1            // Mover el puntero hacia atrás
    udiv x3, x0, x2           // Dividir por 10
    msub x4, x3, x2, x0       // Obtener el residuo
    add x4, x4, #'0'          // Convertir a ASCII
    strb w4, [x1]             // Almacenar el dígito
    mov x0, x3                // Preparar para la siguiente iteración
    cbnz x0, 1b              // Si el cociente no es 0, continuar
    
    mov x0, x1                // Retornar la dirección del primer dígito
    ldp x29, x30, [sp], #16
    ret

// Función para imprimir una cadena
print_string:
    mov x0, #1                // fd = 1 (stdout)
    mov x8, #64               // syscall write
    svc #0
    ret

// Función enqueue (corregida)
enqueue:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Preservar x0
    str x0, [sp, #-16]!
    
    // Imprimir mensaje enqueue
    adr x1, msg_enqueue
    mov x2, #0
1:  ldrb w3, [x1, x2]        // Leer cada byte de msg_enqueue
    cbz w3, 2f               // Terminar al encontrar el terminador nulo
    add x2, x2, #1           // Incrementa el contador de longitud
    b 1b
2:  bl print_string           // Imprimir el mensaje con la longitud calculada en x2
    
    // Convertir e imprimir número
    ldr x0, [sp]
    adr x1, buffer
    bl int_to_string
    mov x1, x0
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string
    
    // Nueva línea
    adr x1, newline
    mov x2, #1
    bl print_string
    
    // Recuperar x0 y hacer enqueue
    ldr x0, [sp], #16
    
    // Verificar si la cola está llena
    adr x1, rear
    ldr x2, [x1]
    adr x3, max_size
    ldr x3, [x3]
    cmp x2, x3
    b.ge queue_full
    
    // Insertar elemento
    adr x3, queue
    str x0, [x3, x2, lsl #3]
    add x2, x2, #1
    str x2, [x1]
    
    ldp x29, x30, [sp], #16
    ret

// Función dequeue (corregida)
dequeue:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Verificar si la cola está vacía
    adr x1, front
    ldr x2, [x1]
    adr x3, rear
    ldr x3, [x3]
    cmp x2, x3
    b.ge queue_empty
    
    // Obtener elemento
    adr x3, queue
    ldr x0, [x3, x2, lsl #3]
    
    // Preservar x0
    str x0, [sp, #-16]!
    
    // Imprimir mensaje dequeue
    adr x1, msg_dequeue
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string           // Imprimir el mensaje con la longitud calculada en x2
    
    // Convertir e imprimir número
    ldr x0, [sp]
    adr x1, buffer
    bl int_to_string
    mov x1, x0
    mov x2, #0
1:  ldrb w3, [x1, x2]
    cbz w3, 2f
    add x2, x2, #1
    b 1b
2:  bl print_string
    
    // Nueva línea
    adr x1, newline
    mov x2, #1
    bl print_string
    
    // Recuperar valor y actualizar front
    ldr x0, [sp], #16
    adr x1, front
    ldr x2, [x1]
    add x2, x2, #1
    str x2, [x1]
    
    ldp x29, x30, [sp], #16
    ret

queue_full:
    adr x1, err_full
    mov x2, #17
    bl print_string
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret

queue_empty:
    adr x1, err_empty
    mov x2, #18
    bl print_string
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret

main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Imprimir mensaje de creación
    adr x1, msg_create
    mov x2, #15
    bl print_string
    
    // Pruebas de inserción
    mov x0, #42
    bl enqueue
    
    mov x0, #73
    bl enqueue
    
    mov x0, #100
    bl enqueue
    
    // Pruebas de extracción
    bl dequeue
    bl dequeue
    bl dequeue
    bl dequeue    // Intentar dequeue en cola vacía
    
    // Probar inserción después de vaciar
    mov x0, #55
    bl enqueue
    bl dequeue
    
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
