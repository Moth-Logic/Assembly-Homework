; Integrantes: José Julián Solórzano Hernández & Abril Guadalupe Morales Gonzales Morales

section .data
    msg_num1:      db "Ingrese primer numero: ", 0
    msg_num2:      db "Ingrese segundo numero: ", 0
    msg_sum:       db "La suma es: ", 0
    msg_sub:       db "La resta es: ", 0
    msg_error:     db "Error: Ingrese solo numeros.", 10, 0
    newline:       db 10, 0
    
    SYS_READ:      equ 0
    SYS_WRITE:     equ 1
    SYS_EXIT:      equ 60
    STDIN:         equ 0
    STDOUT:        equ 1
    MAX_INPUT:     equ 22
    MAX_OUTPUT:    equ 24

section .bss
    buffer1:       resb MAX_INPUT
    buffer2:       resb MAX_INPUT
    output_buf:    resb MAX_OUTPUT
    num_str:       resb MAX_INPUT

section .text
    global _start

print_string:
    push rbx
    push rcx
    push rdx
    
    xor rcx, rcx
    
.count_loop:
    cmp byte [rdi + rcx], 0
    je .print_it
    inc rcx
    jmp .count_loop
    
.print_it:
    mov rax, SYS_WRITE
    mov rsi, rdi
    mov rdi, STDOUT
    mov rdx, rcx
    syscall
    
    pop rdx
    pop rcx
    pop rbx
    ret

read_number:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    call print_string
    
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, rsi
    mov rdx, MAX_INPUT - 1
    syscall
    
    dec rax
    mov rcx, rax
    
    cmp rcx, 0
    jle .error
    
    xor rax, rax
    xor rbx, rbx
    xor r9, r9
    
.parse_loop:
    cmp rbx, rcx
    jge .done_parsing
    
    movzx r8, byte [rsi + rbx]
    
    cmp r8, '0'
    jl .error
    cmp r8, '9'
    jg .error
    
    mov r9, 1
    imul rax, rax, 10
    sub r8, '0'
    add rax, r8
    
    inc rbx
    jmp .parse_loop
    
.done_parsing:
    cmp r9, 0
    je .error
    
    mov r15, 0
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

.error:
    mov r15, 1
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    ret

print_number:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    
    call print_string
    
    lea rsi, [output_buf + MAX_OUTPUT - 1]
    mov byte [rsi], 0
    dec rsi
    
    cmp rax, 0
    jne .convert_loop
    
    mov byte [rsi], '0'
    dec rsi
    jmp .finish_output
    
.convert_loop:
    cmp rax, 0
    je .finish_output
    
    xor rdx, rdx
    mov rbx, 10
    div rbx
    
    add dl, '0'
    mov [rsi], dl
    dec rsi
    
    jmp .convert_loop
    
.finish_output:
    inc rsi
    
    mov rcx, output_buf
    add rcx, MAX_OUTPUT - 1
    sub rcx, rsi
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rcx
    syscall
    
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, 1
    syscall
    
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

print_error:
    mov rdi, msg_error
    call print_string
    ret

_start:
    mov rdi, msg_num1
    mov rsi, buffer1
    call read_number
    
    cmp r15, 1
    je .error_exit
    mov r12, rax
    
    mov rdi, msg_num2
    mov rsi, buffer2
    call read_number
    
    cmp r15, 1
    je .error_exit
    mov r13, rax
    
    mov rax, r12
    add rax, r13
    mov rdi, msg_sum
    call print_number
    
    mov rax, r12
    sub rax, r13
    mov rdi, msg_sub
    call print_number
    
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
    
.error_exit:
    call print_error
    mov rax, SYS_EXIT
    mov rdi, 1
    syscall