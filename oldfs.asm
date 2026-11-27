; ==========================================================
;   OLDFS v2.0 - HYBRID HDD/SSD + USB PEN DRIVE STORAGE
; ==========================================================
; [oldfs_target]: 1 = HDD/SSD (ATA PIO), 2 = USB/BIOS Drive, 0 = Nenhum
; [oldfs_status]: 0 = OK, 1 = Erro/Vazio

oldfs_probe_storage:
    push eax
    push ecx
    push edx

    ; 1. Verifica primeiro se existe HD ou SSD conectado (ATA Primario 0x1F0)
    mov dx, 0x01F6
    mov al, 0xA0
    out dx, al
    mov dx, 0x01F2
    xor al, al
    out dx, al
    mov dx, 0x01F3
    out dx, al
    mov dx, 0x01F4
    out dx, al
    mov dx, 0x01F5
    out dx, al
    mov dx, 0x01F7
    mov al, 0xEC
    out dx, al

    in al, dx
    or al, al
    jz .chk_usb
    cmp al, 0xFF
    je .chk_usb

    mov ecx, 40000
.w_ata:
    in al, dx
    test al, 0x01
    jnz .chk_usb
    test al, 0x80
    jnz .n_ata
    test al, 0x08
    jnz .found_hdd
.n_ata:
    loop .w_ata

.chk_usb:
    ; 2. Sem HD/SSD: usa o Pendrive USB de boot ([0x0508]) via BIOS INT 13h
    mov al, [0x0508]
    cmp al, 0x80
    jb .no_storage
    mov byte [oldfs_target], 2
    pop edx
    pop ecx
    pop eax
    ret

.found_hdd:
    mov dx, 0x01F0
    mov ecx, 256
.drn:
    in ax, dx
    loop .drn
    mov byte [oldfs_target], 1
    pop edx
    pop ecx
    pop eax
    ret

.no_storage:
    mov byte [oldfs_target], 0
    pop edx
    pop ecx
    pop eax
    ret

; ==========================================================
;   BLOCO DE NOTAS: SAVE / LOAD / DELETE (SETOR 100)
; ==========================================================
oldfs_save_note:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    mov edi, 0x00008000
    mov ecx, 128
    xor eax, eax
    rep stosd

    mov dword [0x00008000], 'OLDF'
    mov esi, v2_nbuf
    mov edi, 0x00008004
    mov ecx, 60
    rep movsb

    mov dword [fs_lba], 100
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 1
    call oldfs_rw_sectors
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

oldfs_load_note:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    mov dword [fs_lba], 100
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 0
    call oldfs_rw_sectors
    cmp byte [oldfs_status], 0
    jne .err

    cmp dword [0x00008000], 'OLDF'
    jne .err

    mov esi, 0x00008004
    mov edi, v2_nbuf
    mov ecx, 60
    rep movsb

    mov esi, v2_nbuf
    xor ecx, ecx
.cnt:
    lodsb
    or al, al
    jz .done_c
    inc ecx
    cmp ecx, 58
    jb .cnt
.done_c:
    mov [v2_nlen], ecx
    mov byte [oldfs_status], 0
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

oldfs_del_note:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    mov edi, 0x00008000
    mov ecx, 128
    xor eax, eax
    rep stosd

    mov dword [fs_lba], 100
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 1
    call oldfs_rw_sectors
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

; ==========================================================
;   OLDPAINT: SAVE / LOAD / DELETE (SETORES 200..629)
; ==========================================================
oldfs_save_paint:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    ; Grava assinatura 'OLDP' no Setor 199
    mov edi, 0x00008000
    mov ecx, 128
    xor eax, eax
    rep stosd
    mov dword [0x00008000], 'OLDP'
    mov dword [fs_lba], 199
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 1
    call oldfs_rw_sectors
    cmp byte [oldfs_status], 0
    jne .err

    ; Copia Canvas (0x00300000, 220KB) em blocos de 16KB (32 setores)
    mov esi, 0x00300000
    mov dword [fs_lba], 200
    mov ecx, 14                 ; 14 blocos x 16KB = 224KB (cobre 220KB)
.blk_w:
    push ecx
    push esi
    mov edi, 0x00008000
    mov ecx, 4096               ; 16384 bytes = 4096 dwords
    rep movsd

    mov word [fs_cnt], 32
    mov byte [fs_is_write], 1
    call oldfs_rw_sectors
    pop esi
    pop ecx
    cmp byte [oldfs_status], 0
    jne .err
    add esi, 16384
    add dword [fs_lba], 32
    loop .blk_w

    mov byte [oldfs_status], 0
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

oldfs_load_paint:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    mov dword [fs_lba], 199
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 0
    call oldfs_rw_sectors
    cmp byte [oldfs_status], 0
    jne .err

    cmp dword [0x00008000], 'OLDP'
    jne .err

    mov edi, 0x00300000
    mov dword [fs_lba], 200
    mov ecx, 14
.blk_r:
    push ecx
    push edi
    mov word [fs_cnt], 32
    mov byte [fs_is_write], 0
    call oldfs_rw_sectors
    pop edi
    pop ecx
    cmp byte [oldfs_status], 0
    jne .err

    mov esi, 0x00008000
    push ecx
    mov ecx, 4096
    rep movsd
    pop ecx
    add dword [fs_lba], 32
    loop .blk_r

    mov byte [oldfs_status], 0
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

oldfs_del_paint:
    pushad
    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .err

    mov edi, 0x00008000
    mov ecx, 128
    xor eax, eax
    rep stosd
    mov dword [fs_lba], 199
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 1
    call oldfs_rw_sectors
    popad
    ret
.err:
    mov byte [oldfs_status], 1
    popad
    ret

%include "oldfs_io.asm"