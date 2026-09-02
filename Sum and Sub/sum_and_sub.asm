section .data
    num1: db "Ingrese primer numero: ", 10
    len_1: equ $ - num1
    num2: db "Ingrese segundo numero: ", 10 
    len_2: equ $ - num2
    sum_msg: db "La suma es: ", 10
    len_sum: equ $ - sum_msg
    sub_msg: db "La resta es: ", 10
    len_sub: equ $ - sub_msg
    error_msg: db "Error: Ingrese solo numeros.", 10
    len_error: equ $ - error_msg

section .bss
    buf1: resb 22
    buf2: resb 22   
    outbuf: resb 24

section .text
    global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, r10
    mov rdx, 22
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 101
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall