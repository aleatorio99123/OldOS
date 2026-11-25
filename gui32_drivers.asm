gui32_save_bg:
    pushad
    mov eax, [m_x]
    and eax, 0xFFFFFFF8
    mov [bg32_x], eax
    mov eax, [m_y]
    mov [bg32_y], eax

    mov edi, bg32_buf
    xor bl, bl
.pl:
    mov dx, 0x03CE
    mov al, 0x04
    mov ah, bl
    out dx, ax

    mov ecx, 16
    mov ebp, [bg32_y]
.rl:
    mov eax, ebp
    mov edx, 80
    mul edx
    mov esi, [bg32_x]
    shr esi, 3
    add esi, eax
    mov eax, [0xA0000 + esi]
    mov [edi], eax
    add edi, 4
    inc ebp
    loop .rl

    inc bl
    cmp bl, 4
    jl .pl
    popad
    ret

gui32_restore_bg:
    pushad
    mov esi, bg32_buf
    mov bl, 1
.pl:
    mov dx, 0x03C4
    mov al, 0x02
    mov ah, bl
    out dx, ax

    mov ecx, 16
    mov ebp, [bg32_y]
.rl:
    mov eax, ebp
    mov edx, 80
    mul edx
    mov edi, [bg32_x]
    shr edi, 3
    add edi, eax
    mov eax, [esi]
    mov [0xA0000 + edi], eax
    add esi, 4
    inc ebp
    loop .rl

    shl bl, 1
    cmp bl, 16
    jl .pl

    mov dx, 0x03C4
    mov ax, 0x0F02
    out dx, ax
    popad
    ret

gui32_draw_cursor:
    pushad
    mov eax, [m_x]
    and eax, 0xFFFFFFF8
    mov ebx, eax
    shr ebx, 3
    mov eax, [m_y]
    mov edx, 80
    mul edx
    add eax, ebx
    lea edi, [0xA0000 + eax]

    mov esi, cursor_mask
    mov ebp, cursor_fill
    mov ecx, 14
.row:
    mov bl, [esi]
    mov bh, [ebp]

    mov dx, 0x03C4
    mov ax, 0x0F02
    out dx, ax

    mov al, [edi]
    not bl
    and al, bl
    or al, bh
    mov [edi], al

    inc esi
    inc ebp
    add edi, 80
    loop .row
    popad
    ret

gui32_handle_note:
    cmp al, 58
    jae .ret
    movzx ebx, al
    mov al, [keymap + ebx]
    or al, al
    jz .ret
    mov ebx, [g_nlen]
    cmp al, 8
    je .n_bs
    cmp al, 32
    jb .ret
    cmp ebx, 45
    jae .ret
    mov [g_nbuf + ebx], al
    inc dword [g_nlen]
    mov byte [g_nbuf + ebx + 1], 0
    ret
.n_bs:
    or ebx, ebx
    jz .ret
    dec dword [g_nlen]
    mov ebx, [g_nlen]
    mov byte [g_nbuf + ebx], 0
.ret:
    ret

gui32_handle_calc:
    cmp al, 58
    jae .ret
    movzx ebx, al
    mov al, [keymap + ebx]
    cmp al, 'c'
    je .c_clr
    cmp al, '-'
    je .c_dec
    cmp al, '0'
    jb .ret
    cmp al, '9'
    ja .ret
    sub al, '0'
    movzx eax, al
    add [g_cval], eax
    ret
.c_clr:
    mov dword [g_cval], 0
    ret
.c_dec:
    cmp dword [g_cval], 0
    je .ret
    dec dword [g_cval]
.ret:
    ret

k_init_ps2_mouse32:
    call .wait_w
    mov al, 0xA8
    out 0x64, al
    call .wait_w
    mov al, 0xD4
    out 0x64, al
    call .wait_w
    mov al, 0xF4
    out 0x60, al
    call .wait_r
    in al, 0x60
    ret
.wait_w:
    in al, 0x64
    test al, 0x02
    jnz .wait_w
    ret
.wait_r:
    in al, 0x64
    test al, 0x01
    jz .wait_r
    ret

k_int_to_str32:
    xor ecx, ecx
    mov ebx, 10
.dl: xor edx, edx
    div ebx
    push edx
    inc ecx
    or eax, eax
    jnz .dl
.sl: pop eax
    add al, '0'
    mov [edi], al
    inc edi
    loop .sl
    mov byte [edi], 0
    ret

cursor_mask  db 10000000b, 11000000b, 11100000b, 11110000b, 11111000b, 11111100b, 11111110b, 11111111b, 11111000b, 11011000b, 10001100b, 00001100b, 00000110b, 00000110b
cursor_fill  db 00000000b, 01000000b, 01100000b, 01110000b, 01111000b, 01111100b, 01111110b, 01110000b, 01010000b, 00001000b, 00001000b, 00000100b, 00000100b, 00000000b

g_str_start  db 'OldOS', 0
g_btn_x      db 'X', 0
g_mascot_lbl db 'Oldog v1.0', 0
g_ico2       db 'Notes', 0
g_ico3       db 'Calc', 0
g_t_not      db 'Oldog v1.0 - Notepad', 0
g_t_clc      db 'Oldog v1.0 - Calculator', 0
g_nhint      db 'Type text (Backspace to erase):', 0
g_chint      db 'Press 0-9 to add, - to sub, C to clear:', 0
g_cres       db 'Result: ', 0
g_m1         db '1. Notepad', 0
g_m2         db '2. Calculator', 0
g_m3_exit    db '3. Exit...', 0
g_exit_title db 'Exit Oldog v1.0', 0
g_ebtn1      db ' Shut Down OldOS', 0
g_ebtn2      db ' Restart Computer', 0
g_ebtn3      db ' Restart in Shell Mode', 0

m_x          dd 320
m_y          dd 240
bg32_x       dd 320
bg32_y       dd 240
m_idx        db 0
m_clk        db 0
m_pkt        db 0, 0, 0
g_menu       db 0
g_app        db 0
g_nlen       dd 0
g_nbuf       times 50 db 0
g_cval       dd 0
g_cstr       times 12 db 0
bg32_buf     times 256 db 0