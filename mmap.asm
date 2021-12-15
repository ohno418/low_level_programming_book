%define O_RDONLY 0
%define PROT_READ 0x1
%define MAP_PRIVATE 0x2

section .data
fname: db 'test.txt', 0

section .text
global _start

; Print a null-terminated string on rdi.
print_string:
    push rdi
    call string_length
    mov rdx, rax ; string length on rdx
    pop rsi
    mov rax, 1
    mov rdi, 1
    syscall
    ret

; Return length of string on rdi.
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

_start:
    ; call open
    mov rax, 2
    mov rdi, fname
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    ; call mmap
    mov r8, rax           ; a file descriptor for an opend file
    mov rax, 9
    mov rdi, 0            ; The kernel chooses the address.
    mov rsi, 4096         ; page size
    mov rdx, PROT_READ    ; New memory area is read only.
    mov r10, MAP_PRIVATE  ; private page
    mov r9, 0             ; offset in file
    syscall

    ; print content of the file
    mov rdi, rax
    call print_string

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall
