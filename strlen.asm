global _start

section .data

test_string: db "abcdef", 0

section .text

; Take one argument on rdi.
; Return string length on rax.
strlen:
    xor rax, rax  ; Clear rax.
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

_start:
    mov rdi, test_string
    call strlen

    ; exit syscall
    mov rdi, rax  ; Use string length as exit status.
    mov rax, 60
    syscall
