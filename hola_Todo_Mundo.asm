;  Programa de menu de saludos en NASM para x86-64
;      nasm -f elf64 hola_Todo_Mundo.asm -o hola_Todo_Mundo.o
;      ld hola_Todo_Mundo.o -o hola_Todo_Mundo
;      ./hola_Todo_Mundo

DEFAULT ABS

section .data
    ; menu
    menu:           db 10, "Seleccione un mensaje:", 10
                     db "  a. Hola Mundo!!!", 10
                     db "  b. Feliz Dia del Amor y la Amistad!!!", 10
                     db "  c. Feliz Navidad!!!", 10
                     db "  d. Feliz Dia de la Independencia!!!", 10
                     db "  e. Otro (ingrese su propio mensaje)", 10
                     db "  f. Finalizar el programa", 10
                     db "Opcion: "
    len_menu:       equ $ - menu        ; longitud total del menu (bytes)

    ; mensajes
    msg_a:          db "Hola Mundo!!!", 10
    len_a:          equ $ - msg_a
    msg_b:          db "Feliz Dia del Amor y la Amistad!!!", 10
    len_b:          equ $ - msg_b
    msg_c:          db "Feliz Navidad!!!", 10
    len_c:          equ $ - msg_c
    msg_d:          db "Feliz Dia de la Independencia!!!", 10
    len_d:          equ $ - msg_d

    ; textos para el mensaje propio
    prompt_propio:  db "Ingrese su propio mensaje: "
    len_propio:     equ $ - prompt_propio

    ;"ver otro mensaje?"
    prompt_continuar: db 10, "Quieres ver otro mensaje?", 10
                       db "  1. Si", 10
                       db "  2. No, finalizar", 10
                       db "Opcion: "
    len_continuar:  equ $ - prompt_continuar

    ; mensaje de error
    msg_invalida:   db "Opcion invalida, intente de nuevo.", 10
    len_invalida:   equ $ - msg_invalida

    ; decir chau!!
    msg_despedida:  db 10, "Chauuu!", 10
    len_despedida:  equ $ - msg_despedida

section .bss
    buf_opcion:     resb 2      ; guarda la opcion del menu (1 caracter + enter)
    buf_mensaje:    resb 256    ; guarda el mensaje personalizado (opcion e)
    buf_continuar:  resb 2      ; guarda la respuesta de "otro mensaje"

section .text
    global _start

; _start: el main()

_start:
mostrar_menu:
    ; entregar menu
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, menu
    mov     rdx, len_menu
    syscall

    ; leer la opcion
    mov     rax, 0              ; syscall read
    mov     rdi, 0              ; fd = STDIN
    mov     rsi, buf_opcion
    mov     rdx, 8
    syscall

    movzx   rbx, byte [buf_opcion]   ; rbx = primer caracter tecleado

    ; compara con todas las opciones
    cmp     bl, 'a'
    je      opcion_a
    cmp     bl, 'b'
    je      opcion_b
    cmp     bl, 'c'
    je      opcion_c
    cmp     bl, 'd'
    je      opcion_d
    cmp     bl, 'e'
    je      opcion_e
    cmp     bl, 'f'
    je      opcion_f

    ; ninguna opcion coincidio: error y vuelve a mostrar el menu
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_invalida
    mov     rdx, len_invalida
    syscall
    jmp     mostrar_menu

opcion_a:
    ; dar el mensaje
    mov     rsi, msg_a
    mov     rdx, len_a
    jmp     escribir_y_preguntar

opcion_b:
    mov     rsi, msg_b
    mov     rdx, len_b
    jmp     escribir_y_preguntar

opcion_c:
    mov     rsi, msg_c
    mov     rdx, len_c
    jmp     escribir_y_preguntar

opcion_d:
    mov     rsi, msg_d
    mov     rdx, len_d
    jmp     escribir_y_preguntar

opcion_e:
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
    mov     rdx, 256
    syscall                     ; rax = cantidad de bytes leidos (incluye el '\n')

    ; prepara el mensaje leido para imprimirlo
    mov     rsi, buf_mensaje
    mov     rdx, rax            ; longitud = lo que devolvio read
    jmp     escribir_y_preguntar

opcion_f:
    ; imprime despedida y termina el programa de una vez
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_despedida
    mov     rdx, len_despedida
    syscall
    jmp     terminar

; imprimir y preguntar si quiere volver

escribir_y_preguntar:
    ; imprime el mensaje propio
    mov     rax, 1
    mov     rdi, 1
    syscall

    ; quieres ver otra cosa
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, prompt_continuar
    mov     rdx, len_continuar
    syscall

    ; lee la respuesta
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf_continuar
    mov     rdx, 8
    syscall

    cmp     byte [buf_continuar], '1'
    je      mostrar_menu        ; si respondio '1', vuelve a mostrar el menu

    ; cualquier otra respuesta: se despide y termina
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_despedida
    mov     rdx, len_despedida
    syscall

terminar:
    ; --- syscall exit(0) ---
    mov     rax, 60             ; syscall exit
    xor     rdi, rdi
    syscall
