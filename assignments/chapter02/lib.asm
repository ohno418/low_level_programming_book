section .text
global exit
global string_length
global print_string
global print_char
global print_newline
global print_uint
global print_int

; rdi: exit status code
exit:
    mov rax, 60
    syscall

; rdi: pointer to a null-terminated string
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

; rdi: pointer to a null-terminated string
print_string:
    push rdi
    call string_length
    pop rsi
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    ret

; rdi: a character code
print_char:
    push rdi
    mov rdi, rsp
    call print_string
    pop rdi
    ret

print_newline:
    mov rdi, 10
    jmp print_char

; rdi: number
print_uint:
    mov rax, rdi
    mov rdi, rsp  ; buffer on stack
    push 0
    sub rsp, 16
    dec rdi
    mov r8, 10
.loop:
    xor rdx, rdx
    div r8
    or dl, 0x30
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .loop
    call print_string
    add rsp, 24
    ret

; rdi: number
print_int:
    test rdi, rdi
    jns print_uint  ; if not sign
    push rdi
    mov rdi, '-'
    call print_char
    pop rdi
    neg rdi
    jmp print_uint

; TODO
string_equals:
    xor rax, rax
    ret

read_char:
    xor rax, rax
    ret

read_word:
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    xor rax, rax
    ret

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    xor rax, rax
    ret


string_copy:
    ret

;---
global _start
_start:
    mov rdi, 0xfffffffffffffffd
    call print_int
    call print_newline
    xor rdi, rdi
    call exit
