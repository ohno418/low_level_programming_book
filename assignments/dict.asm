global find_word
extern string_equals

section .text
; Finds a key from dict and returns the address of the record.
; Otherwise returns zero.
;
; rdi: pointer to a null-terminated string (= key)
; rsi: pointer to last word of the dict
find_word:
    xor rax, rax
.loop:
    test rsi, rsi 
    jz .end 
    push rdi
    push rsi
    add rsi, 8
    call string_equals
    pop rsi
    pop rdi
    test rax, rax
    jnz .found
    mov rsi, [rsi]
    jmp .loop
.found:
    mov rax, rsi
.end:
    ret
