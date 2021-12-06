section .data
codes:
    db '0123456789ABCDEF'

section .text
global _start
_start:
    mov rax, 0x112233445566778A

    mov rdi, 1
    mov rdx, 1
    mov rcx, 64
.loop:
    push rax

    sub rcx, 4
    sar rax, cl
    and rax, 0xf

    lea rsi, [codes + rax]
    mov rax, 1

    ; save rcx
    ; (syscall changes rcx and r11)
    push rcx
    syscall
    pop rcx

    pop rax

    ; test if zero or not
    test rcx, rcx
    jnz .loop

    ; exit syscall
    mov rax, 60
    xor rdi, rdi
    syscall
