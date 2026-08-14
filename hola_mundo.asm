;  Programa "Hola Mundo" en NASM para x86-64 (Intel/AMD)
;
;      nasm -f elf64 hola_mundo.asm -o hola_mundo.o
;      ld hola_mundo.o -o hola_mundo
;      ./hola_mundo

section .data
    mensaje:    db "Hola Mundo", 10      ; el texto a imprimir + salto de linea
    long_msg:   equ $ - mensaje          ; calcula cuantos bytes ocupa 'mensaje'

section .text
    global _start                        ; punto de entrada visible para el linker

_start:
    ; imprime el mensaje. Funciona como un main() en python
    mov     rax, 1              ; syscall write
    mov     rdi, 1              ; 1 = STDOUT (pantalla)
    mov     rsi, mensaje        ; direccion del Hola Mundo
    mov     rdx, long_msg       ; cuantos bytes imprimir, el equ ya sabe cuanto vale
    syscall                     ; le pide al kernel que ejecute el write

    ; --- syscall exit(0)
    mov     rax, 60             ; 60 = exit
    xor     rdi, rdi            ; codigo de salida = 0 (no sabia que se podia hacer xor con el mismo!)
    syscall                     ; le pide al kernel que termine el proceso
