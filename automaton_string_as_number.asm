;
; An automaton that determines
; if an input string can be interpreted as a number.
;

section .data
NUM0: db "123", 0
NUM1: db "-593225", 0
NUM2: db "+4369", 0
NOT_NUM0: db "abc", 0
NOT_NUM1: db "123b", 0
NOT_NUM2: db "--593225", 0

section .text

; Reads a symbol from r12 offseted with r13,
; then writes into al.
getsymbol:
    mov al, byte [r12 + r13]
    inc r13
    ret

_A:
    call getsymbol
    cmp al, '+'
    je _B
    cmp al, '-'
    je _B
    cmp al, '0'
    jb _E
    cmp al, '9'
    ja _E
    jmp _C

_B:
    call getsymbol
    cmp al, '0'
    jb _E
    cmp al, '9'
    ja _E
    jmp _C

_C:
    call getsymbol
    test al, al
    je _D
    cmp al, '0'
    jb _E
    cmp al, '9'
    ja _E
    jmp _C

_D:
    mov rax, 60
    mov rdi, 0
    syscall

_E:
    mov rax, 60
    mov rdi, 1
    syscall

global _start
_start:
    ; CHANGE HERE to change an input string.
    mov r12, NUM0
    ; index counter
    xor r13, r13
    jmp _A
