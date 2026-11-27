[BITS 16]
[ORG 0x7C00]

jmp short start
nop
times 59 db 0

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [boot_drive], dl
    mov [0x0508], dl

    int 0x12
    movzx eax, ax
    mov [0x0500], eax

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    mov ax, 0xE801
    int 0x15
    jc .ram_fb
    or bx, bx
    jnz .use_bx
    mov bx, dx
.use_bx:
    movzx eax, bx
    shr eax, 4
    add eax, 16
    mov [0x0504], eax
    jmp .load_k
.ram_fb:
    mov dword [0x0504], 16

.load_k:
    mov si, dap
    mov ah, 0x42
    mov dl, [boot_drive]
    int 0x13
    jnc .load_ok

    mov ax, 0x1000
    mov es, ax
    xor bx, bx
    mov ah, 0x02
    mov al, 64
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_err

.load_ok:
    xor ax, ax
    mov ds, ax
    mov es, ax

    push es
    mov ax, 0x1130
    mov bh, 0x06
    int 0x10
    push es
    pop ds
    mov si, bp
    xor ax, ax
    mov es, ax
    mov di, 0x6000
    mov cx, 2048
    rep movsw
    xor ax, ax
    mov ds, ax
    pop es

    mov ax, 0x4F01
    mov cx, 0x114
    mov di, 0x7000
    int 0x10
    movzx eax, word [0x7010]
    mov [0x050C], eax
    mov eax, [0x7028]
    mov [0x0510], eax

    mov ax, 0x4F02
    mov bx, 0x4114
    int 0x10

    cli
    mov al, 0xFF
    out 0x21, al
    out 0xA1, al

    in al, 0x92
    or al, 2
    out 0x92, al

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp dword 0x08:init_pm

disk_err:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10
    jmp $

align 4
dap:
    db 0x10, 0x00
    dw 64
    dw 0x0000, 0x1000
    dq 1

align 8
gdt_start:
    dq 0x0000000000000000
gdt_code:
    dw 0xFFFF, 0x0000
    db 0x00, 10011010b, 11001111b, 0x00
gdt_data:
    dw 0xFFFF, 0x0000
    db 0x00, 10010010b, 11001111b, 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
init_pm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    ; Copia os 32 KB do kernel de 0x10000 para 0x100000 (1 MB) - zero conflito!
    mov esi, 0x10000
    mov edi, 0x100000
    mov ecx, 8192
    rep movsd

    mov eax, 0x100000
    jmp eax

boot_drive db 0
times 446 - ($ - $$) db 0
db 0x80, 0, 2, 0, 0x0B, 0, 10, 0
dd 1, 100
times 48 db 0
dw 0xAA55
