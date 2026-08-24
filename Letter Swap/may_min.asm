; Julian Solorzano & Abril Gonzalez

section .data
    prompt:     db "Insert your message: "
    prompt_len: equ $ - prompt
 
section .bss
    buffer:     resb 101
 
section .text
    global _start
 
_start:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, prompt
    mov     rdx, prompt_len
    syscall
 
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 101
    syscall
 
    mov     r12, rax
    mov     rcx, rax
    xor     rbx, rbx
 
.convert_loop:
    cmp     rbx, rcx
    jge     .done_convert
 
    movzx   eax, byte [buffer + rbx]
 
    cmp     al, 0x41
    jl      .try_lower
    cmp     al, 0x5A
    jg      .try_lower
    sub     al, 0x20        
    mov     [buffer + rbx], al
    jmp     .next
 
.try_lower:
    cmp     al, 0x61
    jl      .next
    cmp     al, 0x7A
    jg      .next
    add     al, 0x20        
    mov     [buffer + rbx], al
 
.next:
    inc     rbx
    jmp     .convert_loop
 
.done_convert:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buffer
    mov     rdx, r12
    syscall
 
    mov     rax, 60
    xor     rdi, rdi
    syscall