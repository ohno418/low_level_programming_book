section .text
%include "colon.inc"

extern read_word
extern find_word
extern string_length
extern print_string
extern print_error
extern exit

global _start

section .rodata
msg_noword: db "No such word", 0

%include "words.inc"

section .text
_start:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    mov rdi, rsp
    call read_word

    mov rdi, rax
    mov rsi, lw
    call find_word
    test rax, rax
    jz .not_found

    add rax, 8
    push rax
    mov rax, [rsp]
    mov rdi, rax
    call string_length
    pop rdi
    add rdi, rax
    inc rdi
    call print_string
    mov rsp, rbp
    pop rbp
    mov rdi, 0
    call exit

.not_found:
    mov rdi, msg_noword
    call print_error

    mov rsp, rbp
    pop rbp
    mov rdi, 0
    call exit
