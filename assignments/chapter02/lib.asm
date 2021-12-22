; FIXME: for test
section .data
str0: db "abc", 0
str1: db 10
str2: db 2

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
global parse_uint
global parse_int
global string_equals
global string_copy

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

; Parses an unsigned number from beginning of a string,
; returns the number on rax, its length on rdx.
;
; rdi: pointer to a null-terminated string
parse_uint:
    mov r8, 10
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx r9, byte [rdi + rcx]

    ; not a number?
    cmp r9b, '0'
    jb .end
    cmp r9b, '9'
    ja .end

    ; Increment digit of the number on rax.
    xor rdx, rdx
    mul r8

    and r9b, 0x0f  ; ascii code to number (e.g. 0x31 to 0x01)
    add rax, r9
    inc rcx
    jmp .loop
.end:
    mov rdx, rcx
    ret

; Parses a signed number from beginning of a string,
; returns the number on rax, its length on rdx.
;
; rdi: pointer to a null-terminated string
parse_int:
    mov al, byte [rdi]
    cmp al, '-'
    je .signed
    jmp parse_uint
.signed:
    inc rdi
    call parse_uint
    neg rax
    inc rdx  ; increment length for '-'
    ret

; Returns 1 if equal, otherwise 0.
;
; rdi: string 1
; rsi: string 2
string_equals:
    mov al, byte [rdi]
    cmp al, byte [rsi]
    jne .no
    inc rdi
    inc rsi
    test al, al
    jnz string_equals
    mov rax, 1
    ret
.no:
    xor rax, rax
    ret

; Copies a string to buffer and returns buffer address,
; or returns 1 if buffer length over.
;
; rdi: pointer to a string
; rsi: pointer to a buffer
; rdx: length of the buffer
string_copy:
    xor rcx, rcx
    xor r8, r8
.loop:
    mov r8b, byte [rdi + rcx]
    mov byte [rsi + rcx], r8b
    inc rcx

    ; length over?
    cmp rcx, rdx
    je .over

    ; string end?
    test r8b, r8b
    jnz .loop

    mov rax, rsi
    ret
.over:
    xor rax, rax
    ret

; FIXME: for test
global _start
_start:
    mov rdi, str0
    mov rsi, str2
    mov rdx, 2
    call string_copy
    mov rdi, rax
    call print_uint
    call print_newline

    mov rdi, str0
    mov rsi, str1
    mov rdx, 10
    call string_copy
    mov rdi, rax
    call print_string
    call print_newline
    mov rdi, str1
    call print_string
    call print_newline

    xor rdi, rdi
    call exit
