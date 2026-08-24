; Julian Solorzano & Abril Gonzalez

CASE_BIT   equ 0x20
 
section .data
    prompt:      db "Insert your message: "
    prompt_len:  equ $ - prompt
 
section .bss
    buffer:      resb 101
 
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
 
    mov     rcx, rax
    xor     rbx, rbx
 
.convert_loop:
    cmp     rbx, rcx
    jge     .done_convert
 
    movzx   eax, byte [buffer + rbx]
 
    ; is it uppercase?
    cmp     al, 0x41
    jl      .check_lower
    cmp     al, 0x5A
    jg      .check_lower
    xor     al, CASE_BIT        ; toggle case in one shot
    mov     [buffer + rbx], al
    jmp     .next_char
 
.check_lower:
    cmp     al, 0x61
    jl      .next_char
    cmp     al, 0x7A
    jg      .next_char
    xor     al, CASE_BIT        ; same trick, other direction
    mov     [buffer + rbx], al
 
.next_char:
    inc     rbx
    jmp     .convert_loop
 
.done_convert:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buffer
    mov     rdx, rcx
    syscall
 
    mov     rax, 60
    xor     rdi, rdi
    syscall