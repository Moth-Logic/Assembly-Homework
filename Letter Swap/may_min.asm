; La idea: 'A' es 0x41 y 'a' es 0x61. Si los ves en binario:
;   'A' = 0100 0001
;   'a' = 0110 0001
; Solo cambia UN bit, el bit 5 (0x20). Es literal el unico bit
; que diferencia mayuscula de minuscula en TODAS las letras.
; Entonces en vez de sumar 0x20 para un lado y restar 0x20 para
; el otro (dos instrucciones, dos casos), con un solo
; "xor al, 0x20" prendes/apagas ese bit y ya, te cambia el caso
; sin importar si venia de mayuscula o minuscula. Un XOR hace
; el trabajo de add Y sub al mismo tiempo.

CASE_BIT   equ 0x20        ; el bit que distingue mayus de minus

section .data
    prompt:      db "Insert your message: "
    prompt_len:  equ $ - prompt

section .bss
    buffer:      resb 101      ; 100 caracteres + el '\n' del enter

section .text
    global _start

_start:
    ;imprime el prompt
    mov     rax, 1              ; sys_write
    mov     rdi, 1              ; stdout
    mov     rsi, prompt
    mov     rdx, prompt_len
    syscall

    ;lee lo que el usuario escribio
    mov     rax, 0              ; sys_read
    mov     rdi, 0              ; stdin
    mov     rsi, buffer
    mov     rdx, 101
    syscall                     ; rax = cuantos bytes realmente llegaron

    mov     rcx, rax            ; guardo la longitud real, la necesito al final
    xor     rbx, rbx            ; rbx = indice del char actual, arranca en 0

.convert_loop:
    cmp     rbx, rcx            ; ya recorri todo el buffer?
    jge     .done_convert       ; si ya llegue al final, salgo del loop

    movzx   eax, byte [buffer + rbx]   ; agarro el char actual en al

    ;primero me fijo si es mayuscula (0x41 a 0x5A)
    cmp     al, 0x41
    jl      .check_lower        ; si es menor que 'A', no es mayuscula, brinco
    cmp     al, 0x5A
    jg      .check_lower        ; si es mayor que 'Z', tampoco es, brinco

    ; si llego aca es que SI es mayuscula. Aca esta la magia:
    xor     al, CASE_BIT        ; le apago el bit 0x20 -> se vuelve minuscula
    mov     [buffer + rbx], al  ; lo guardo de vuelta en el buffer
    jmp     .next_char          ; ya lo procese, sigo con el siguiente

.check_lower:
    ; si no era mayuscula, me fijo si es minuscula (0x61 a 0x7A)
    cmp     al, 0x61
    jl      .next_char          ; menor que 'a' -> no es letra, lo dejo igual
    cmp     al, 0x7A
    jg      .next_char          ; mayor que 'z' -> tampoco, lo dejo igual

    ; si llego aca SI es minuscula, mismo truco pero al reves:
    xor     al, CASE_BIT        ; le prendo el bit 0x20 -> se vuelve mayuscula
    mov     [buffer + rbx], al  ; el MISMO xor sirve para las dos direcciones

.next_char:
    inc     rbx                 ; paso al siguiente char
    jmp     .convert_loop       ; y repito

.done_convert:
    ;imprimo el buffer ya convertido
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, buffer
    mov     rdx, rcx            ; uso la longitud REAL que lei, no un valor fijo
    syscall

    ; syscall exit
    mov     rax, 60
    xor     rdi, rdi
    syscall