; Real mode to Protected mode

    ; Load GDT (Global Descriptor Table) address into gdtr (GDT register)
    lgdt cs:[_gdtr]

    mov eax, cr0            ; !! privilege instruction
    or al, 1                ; This bit correspoinds to protected mode.
    mov cr0, eax            ; !! privilege instruction

    jmp (0x1 << 3):start32  ; `start32` is the start code of protected mode.

align 16

_gdtr:
    dw 47    ; index of last entry of GDT
    dq _gdt  ; address of GDT

align 16

_gdt:
    ; null descriptor
    dd 0x00 0x00

    ; x32 code descriptor
    db 0xff, 0xff, 0x00, 0x00, 0x00, 0x9a, 0xcf, 0x00
    ; x32 data descriptor
    db 0xff, 0xff, 0x00, 0x00, 0x00, 0x92, 0xcf, 0x00
