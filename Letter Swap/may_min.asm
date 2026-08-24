
DEFAULT ABS

section .data
    ; textos para el mensaje propio
    prompt_propio:  db "Ingrese su propio mensaje: "
    len_propio:     equ $ - prompt_propio

    prompt_continuar: db 10, "Quiere escribir otro mensaje?", 10
    db "  1. Si", 10
    db "  2. No, finalizar", 10
    db "Opcion: "
    len_continuar:  equ $ - prompt_continuar

    ; decir chau!!
    msg_despedida:  db 10, "Chauuu!", 10a
    len_despedida:  equ $ - msg_despedida



section .bss
    buf_opcion:     resb 2      ; guarda la opcion del menu (1 caracter + enter)
    buf_mensaje:    resb 100    ; guarda el mensaje personalizado (opcion e)
    buf_continuar:  resb 2      ; guarda la respuesta de "otro mensaje"

section .text
    global _start                        ; punto de entrada visible para el linker

_start:
    ; imprime el mensaje. Funciona como un main() en python
    mov     rax, 1              ; syscall write
    mov     rdi, 1              ; 1 = STDOUT (pantalla)
    mov     rsi, prompt_propio  ; direccion del mensaje propio
    mov     rdx, len_propio     ; cuantos bytes imprimir, el equ ya sabe cuanto vale
    syscall                     ; le pide al kernel que ejecute el write

    mensaje_propio:
    ; pedir que escribas el mensaje propio
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, prompt_propio
    mov     rdx, len_propio
    syscall

    ; lee el mensaje que escribio
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf_mensaje
    mov     rdx, 100
    syscall                     ; rax = cantidad de bytes leidos (incluye el '\n')

    ; prepara el mensaje leido para imprimirlo
    mov     rsi, buf_mensaje
    mov     rdx, rax            ; longitud = lo que devolvio read
    jmp     escribir_y_preguntar


    ; --- syscall exit(0)
    mov     rax, 60             ; 60 = exit
    xor     rdi, rdi            ; codigo de salida = 0 (no sabia que se podia hacer xor con el mismo!)
    syscall                     ; le pide al kernel que termine el proceso