; Julian Solorzano & Abril Gonzalez

section .data
    prompt:     db "Insert your message: "
    prompt_len: equ $ - prompt

section .bss
    buffer:     resb 101      ; up to 100 chars + '\n'

section .text
    global _start

_start:
    ; print prompt
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, prompt
    mov     rdx, prompt_len
    syscall

    ; read input
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 101
    syscall              ; rax = bytes actually read (incl. '\n')

    mov     r12, rax     ; save length for the final write

    ; convert ONLY buffer[0]
    movzx   eax, byte [buffer]

    cmp     al, 0x41
    jl      .skip
    cmp     al, 0x5A
    jg      .try_lower
    add     al, 0x20
    jmp     .store

.try_lower:
    cmp     al, 0x61
    jl      .skip
    cmp     al, 0x7A
    jg      .skip
    sub     al, 0x20

.store:
    mov     [buffer], al

.skip:
    ; write the buffer back out
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buffer
    mov     rdx, r12
    syscall

    ; exit(0)
    mov     rax, 60
    xor     rdi, rdi
    syscall