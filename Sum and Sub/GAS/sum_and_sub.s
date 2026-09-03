@ Integrantes: José Julián Solórzano Hernández & Abril Guadalupe Morales Gonzales Morales

.section .data
    msg_num1:      .asciz "Ingrese primer numero: "
    msg_num2:      .asciz "Ingrese segundo numero: "
    msg_sum:       .asciz "La suma es: "
    msg_sub:       .asciz "La resta es: "
    msg_error:     .asciz "Error: Ingrese solo numeros.\n"
    newline:       .asciz "\n"
    
    .equ MAX_INPUT,  22
    .equ MAX_OUTPUT, 12
    .equ STDIN,      0
    .equ STDOUT,     1
    .equ SYS_READ,   3
    .equ SYS_WRITE,  4
    .equ SYS_EXIT,   1

.section .bss
    .lcomm buffer1,  MAX_INPUT
    .lcomm buffer2,  MAX_INPUT
    .lcomm output_buf, MAX_OUTPUT

.section .text
    .global _start

print_string:
    push {r0-r3, lr}
    
    mov r1, r0
    mov r2, #0
    
1:
    ldrb r3, [r1, r2]
    cmp r3, #0
    beq 2f
    add r2, r2, #1
    b 1b
    
2:
    mov r7, #SYS_WRITE
    mov r0, #STDOUT
    mov r1, r1
    swi #0
    
    pop {r0-r3, pc}

read_number:
    push {r4-r7, lr}
    
    mov r4, r0
    mov r5, r1
    
    bl print_string
    
    mov r7, #SYS_READ
    mov r0, #STDIN
    mov r1, r5
    mov r2, #MAX_INPUT - 1
    swi #0
    
    subs r6, r0, #1
    ble .error
    
    mov r0, #0
    mov r1, #0
    mov r4, #0
    
.parse_loop:
    cmp r1, r6
    bge .done_parsing
    
    ldrb r2, [r5, r1]
    
    cmp r2, #'0'
    blt .error
    cmp r2, #'9'
    bgt .error
    
    mov r4, #1
    mov r3, #10
    mul r0, r0, r3
    sub r2, r2, #'0'
    add r0, r0, r2
    
    add r1, r1, #1
    b .parse_loop
    
.done_parsing:
    cmp r4, #0
    beq .error
    
    mov r7, #0
    pop {r4-r7, pc}

.error:
    mov r7, #1
    pop {r4-r7, pc}

divide:
    push {r2-r4, lr}
    
    cmp r1, #0
    beq 1f
    
    mov r2, r0
    mov r3, r1
    mov r0, #0
    mov r4, #0
    
2:
    cmp r3, r2
    bgt 3f
    lsl r3, r3, #1
    add r4, r4, #1
    b 2b
    
3:
4:
    cmp r4, #0
    blt 5f
    cmp r2, r3
    blt 6f
    sub r2, r2, r3
    add r0, r0, #1
    
6:
    lsl r0, r0, #1
    lsr r3, r3, #1
    sub r4, r4, #1
    b 4b
    
5:
    lsr r0, r0, #1
    mov r1, r2
    
    pop {r2-r4, pc}

1:
    mov r0, #0
    mov r1, #0
    pop {r2-r4, pc}

print_number:
    push {r0-r7, lr}
    
    mov r1, r0
    mov r0, r1
    bl print_string
    
    ldr r1, =output_buf
    add r1, r1, #MAX_OUTPUT - 1
    mov r2, #0
    strb r2, [r1]
    sub r1, r1, #1
    
    cmp r0, #0
    bne .convert_loop
    
    mov r2, #'0'
    strb r2, [r1]
    sub r1, r1, #1
    b .finish_output
    
.convert_loop:
    cmp r0, #0
    beq .finish_output
    
    mov r2, #10
    bl divide
    add r1, r1, #'0'
    strb r1, [r2]
    sub r2, r2, #1
    mov r0, r3
    b .convert_loop
    
.finish_output:
    add r1, r2, #1
    
    ldr r2, =output_buf
    add r2, r2, #MAX_OUTPUT - 1
    sub r2, r2, r1
    
    mov r7, #SYS_WRITE
    mov r0, #STDOUT
    swi #0
    
    ldr r0, =newline
    bl print_string
    
    pop {r0-r7, pc}

print_error:
    ldr r0, =msg_error
    bl print_string
    mov pc, lr

_start:
    ldr r0, =msg_num1
    ldr r1, =buffer1
    bl read_number
    
    cmp r7, #1
    beq .error_exit
    mov r4, r0
    
    ldr r0, =msg_num2
    ldr r1, =buffer2
    bl read_number
    
    cmp r7, #1
    beq .error_exit
    mov r5, r0
    
    ldr r1, =msg_sum
    add r0, r4, r5
    bl print_number
    
    ldr r1, =msg_sub
    sub r0, r4, r5
    bl print_number
    
    mov r7, #SYS_EXIT
    mov r0, #0
    swi #0
    
.error_exit:
    bl print_error
    mov r7, #SYS_EXIT
    mov r0, #1
    swi #0