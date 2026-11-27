oldfs_rw_sectors:
    cmp byte [oldfs_target], 1
    je .do_ata_rw
    cmp byte [oldfs_target], 2
    je .do_usb_bios_rw
    mov byte [oldfs_status], 1
    ret

.do_ata_rw:
    pushad
    movzx ecx, word [fs_cnt]
    mov ebx, [fs_lba]
    mov edi, 0x00008000
.ata_loop:
    push ecx
    mov eax, ebx
    mov dx, 0x01F6
    shr eax, 24
    or al, 0xE0
    out dx, al
    mov dx, 0x01F2
    mov al, 1
    out dx, al
    mov dx, 0x01F3
    mov al, bl
    out dx, al
    mov dx, 0x01F4
    mov al, bh
    out dx, al
    mov dx, 0x01F5
    mov eax, ebx
    shr eax, 16
    out dx, al

    mov dx, 0x01F7
    mov al, 0x20
    cmp byte [fs_is_write], 1
    jne .ata_cmd
    mov al, 0x30
.ata_cmd:
    out dx, al

    call .ata_wait
    jc .ata_fail

    mov dx, 0x01F0
    mov ecx, 256
    cmp byte [fs_is_write], 1
    je .ata_out
    rep insw
    jmp .ata_next
.ata_out:
    mov esi, edi
    rep outsw
    add edi, 512
.ata_next:
    pop ecx
    inc ebx
    loop .ata_loop

    mov byte [oldfs_status], 0
    popad
    ret
.ata_fail:
    pop ecx
    mov byte [oldfs_status], 1
    popad
    ret

.ata_wait:
    mov ecx, 50000
    mov dx, 0x01F7
.ap: in al, dx
    test al, 0x80
    jnz .an
    test al, 0x08
    jnz .ao
    test al, 0x01
    jnz .af
.an: loop .ap
.af: stc
    ret
.ao: clc
    ret

; Gravacao/Leitura Fisica no Pendrive via BIOS INT 13h (100% auto-contida em 0x5000)
.do_usb_bios_rw:
    pushad
    mov eax, [fs_lba]
    mov [b16_dap_lba], eax
    mov ax, [fs_cnt]
    mov [b16_dap_cnt], ax
    mov byte [b16_fn], 0x42
    cmp byte [fs_is_write], 1
    jne .copy_bridge
    mov byte [b16_fn], 0x43

.copy_bridge:
    mov esi, usb_bridge_16_src
    mov edi, 0x00005000
    mov ecx, usb_bridge_16_end - usb_bridge_16_src
    rep movsb

    cli
    mov [saved_esp32], esp
    lgdt [0x5000 + (b16_gdtd - usb_bridge_16_src)]
    jmp 0x18:0x5000

usb_bridge_16_src:
[BITS 16]
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov eax, cr0
    and eax, 0xFFFFFFFE
    mov cr0, eax

    jmp 0x0000:(0x5000 + (.real_entry - usb_bridge_16_src))

.real_entry:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x5FF0

    mov al, 0x00
    out 0x21, al
    out 0xA1, al
    sti

    mov si, 0x5000 + (b16_dap - usb_bridge_16_src)
    mov ah, [0x5000 + (b16_fn - usb_bridge_16_src)]
    xor al, al
    mov dl, [0x0508]
    int 0x13
    jc .usb_err
    mov byte [0x5000 + (b16_st - usb_bridge_16_src)], 0
    jmp .back_pm32

.usb_err:
    mov byte [0x5000 + (b16_st - usb_bridge_16_src)], 1

.back_pm32:
    cli
    mov al, 0xFF
    out 0x21, al
    out 0xA1, al

    lgdt [0x5000 + (b16_gdtd - usb_bridge_16_src)]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp dword 0x08:fs_pm32_land

align 4
b16_dap:
    db 0x10, 0x00
b16_dap_cnt:
    dw 1
    dw 0x8000, 0x0000
b16_dap_lba:
    dq 100

b16_fn db 0x42
b16_st db 0

align 8
b16_gdt:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
    dq 0x00009A000000FFFF
    dq 0x000092000000FFFF
b16_gdt_end:

b16_gdtd:
    dw b16_gdt_end - b16_gdt - 1
    dd 0x5000 + (b16_gdt - usb_bridge_16_src)
usb_bridge_16_end:

[BITS 32]
fs_pm32_land:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, [saved_esp32]

    mov al, [0x5000 + (b16_st - usb_bridge_16_src)]
    mov [oldfs_status], al
    popad
    ret

saved_esp32   dd 0
fs_lba        dd 100
fs_cnt        dw 1
fs_is_write   db 0
oldfs_target  db 0
oldfs_status  db 0

oldfs_msg_ok  db 'OldFS: Saved physically to Drive!', 0
oldfs_msg_ld  db 'OldFS: Loaded from Drive!', 0
oldfs_msg_del db 'OldFS: Deleted from Drive!', 0
oldfs_msg_err db 'OldFS: Empty or Write Error!', 0