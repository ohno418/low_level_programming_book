section .text
global exit
global string_length
global print_string
global print_char
global print_newline
global print_uint
global print_int
global read_char
global read_word

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

; Read 1 character from stdin.
read_char:
    push 0
    xor rax, rax
    xor rdi, rdi
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax
    ret

; Read a word from stdin into a buffer,
; then return buffer address on rax and word length rdx.
; (A word is constructed without white spaces.)
; If the word is over the size, return 0.
;
; rdi: buffer address
; rsi: buffer size
read_word:
    push r14
    ; Use r14 as length counter.
    xor r14, r14
.skip_first_spaces:
    push rdi
    call read_char
    pop rdi
    ; Skip first white spaces.
    cmp al, ' '
    je .skip_first_spaces
    cmp al, 0x09
    je .skip_first_spaces
    cmp al, 0x0a
    je .skip_first_spaces
    cmp al, 0x0d
    je .skip_first_spaces
.loop:
    mov byte [rdi + r14], al
    inc r14

    push rdi
    call read_char
    pop rdi
    cmp al, ' '
    je .end
    cmp al, 0x09
    je .end
    cmp al, 0x0a
    je .end
    cmp al, 0x0d
    je .end
    test al, al
    jz .end
    jmp .loop
.end:
    ; Terminate with null.
    mov byte [rdi + r14], 0
    mov rax, rdi
    pop r14
    ret

; TODO
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

; rdi: string 1
; rsi: string 2
string_equals:
    xor rax, rax
    ret

string_copy:
    ret

;---
global _start
_start:
    push 0
    mov rdi, rsp
    mov rsi, 8
    call read_word

    mov rdi, rax
    call print_string

    call print_newline
    pop rsi
    xor rdi, rdi
    call exit
