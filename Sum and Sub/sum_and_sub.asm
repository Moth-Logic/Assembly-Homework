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

lee_numero:
    mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, r9
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, r10
    mov rdx, 22
    syscall

    mov rcx, rax
    dec rcx

    xor rbx, rcx
    xor rax, rax

.parse_loop:
    cmp rbx, rcx
    jge .parse_valido

    movzx r13d, byte [r10 + rbx]

    cmp r13b, '0'
    jl .parse_invalido
    cmp r13b, '9'
    jg .parse_invalido

    imul rax, rax, 10
    sub r13b, '0'
    add rax, r13

    inc rbx
    jmp .parse_loop

.parse_valido:
    mov r15b, 0
    ret

.parse_invalido:
    mov r15b, 1
    ret

imprime_numero:
    xor r14, r14
    cmp rax 0
    jge .es_positivo
    mov r14, 1
    neg rax
.es_positivo:
    lea rdi, [r10 + 24]
    xor rcx, rcx

    cmp rax, 0
    jne .conv_loop
    dec rdi
    mov byte [rdi], '0'
    inc rcx
    jmp .conv_fin

.conv_loop:
    cmp rax , 0
    je .conv_fin
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    inc rcx
    jmp .conv_loop

.conv_fin:
    cmp r14, 0
    jne .sin_signo
    dec rdi
    mov byte [rdi], '-'
    inc rcx

.sin_signo:
    mov rsi, rdi
    mov rdx, rcx
    ret

_start:

