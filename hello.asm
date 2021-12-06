global _start

section .data
message: db 'hello, world!', 10

section .text
_start:
    mov rax, 1        ; write system call number
    mov rdi, 1        ; argument #1: descriptor to write (stdout)
    mov rsi, message  ; argument #2: first address of string
    mov rdx, 14       ; argument #3: the number of bytes to write
    syscall           ; invoke syscall

    mov rax, 60       ; exit system call number
    xor rdi, rdi      ; set exit status to 0
    syscall
