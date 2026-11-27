k_rgb_to_565:
    mov eax, [r_rgb]
    mov ebx, eax
    shr ebx, 19
    and ebx, 0x1F
    shl ebx, 11
    mov ecx, eax
    shr ecx, 10
    and ecx, 0x3F
    shl ecx, 5
    or ebx, ecx
    shr eax, 3
    and eax, 0x1F
    or eax, ebx
    ret

k_fill_rect:
    pushad
    mov eax, [r_y]
    cmp eax, 600
    jge .done
    mov ebx, [r_x]
    cmp ebx, 800
    jge .done

    mov ecx, [r_h]
    add eax, ecx
    cmp eax, 600
    jle .h_ok
    mov ecx, 600
    sub ecx, [r_y]
.h_ok:
    cmp ecx, 0
    jle .done
    mov [tmp_h], ecx

    mov ecx, [r_w]
    add ebx, ecx
    cmp ebx, 800
    jle .w_ok
    mov ecx, 800
    sub ecx, [r_x]
.w_ok:
    cmp ecx, 0
    jle .done
    mov [tmp_w], ecx

    call k_rgb_to_565
    mov [tmp_c16], ax

    mov eax, [r_y]
    mov edx, 1600
    mul edx
    mov edx, [r_x]
    shl edx, 1
    add eax, edx
    lea edi, [0x00200000 + eax]

    mov ax, [tmp_c16]
    mov edx, [tmp_h]
.yl:
    push edi
    mov ecx, [tmp_w]
    rep stosw
    pop edi
    add edi, 1600
    dec edx
    jnz .yl
.done:
    popad
    ret

k_flip_screen:
    pushad
    mov esi, 0x00200000
    mov edi, [0x0510]
    mov ecx, 600
    mov eax, [0x050C]
.fl:
    push ecx
    push esi
    push edi
    mov ecx, 400
    rep movsd
    pop edi
    pop esi
    pop ecx
    add esi, 1600
    add edi, eax
    loop .fl
    popad
    ret

k_putchar_xy:
    pushad
    movzx esi, al
    shl esi, 4
    add esi, 0x6000

    mov eax, [t_fg_rgb]
    mov [r_rgb], eax
    call k_rgb_to_565
    mov [tmp_fg], ax

    mov eax, [t_bg_rgb]
    mov [r_rgb], eax
    call k_rgb_to_565
    mov [tmp_bg], ax

    mov eax, [t_py]
    mov edx, 1600
    mul edx
    mov edx, [t_px]
    shl edx, 1
    add eax, edx
    lea edi, [0x00200000 + eax]

    mov ecx, 16
.cy:
    push ecx
    push edi
    lodsb
    mov bl, al
    mov ecx, 8
.cx:
    test bl, 0x80
    jz .bg
    mov ax, [tmp_fg]
    mov [edi], ax
    jmp .nx
.bg:
    cmp byte [t_transp], 1
    je .nx
    mov ax, [tmp_bg]
    mov [edi], ax
.nx:
    shl bl, 1
    add edi, 2
    loop .cx
    pop edi
    pop ecx
    add edi, 1600
    loop .cy
    popad
    ret

k_print_xy:
    push eax
    push esi
.pl:
    lodsb
    or al, al
    jz .pd
    cmp al, 10
    je .nl
    call k_putchar_xy
    add dword [t_px], 8
    jmp .pl
.nl:
    mov dword [t_px], 16
    add dword [t_py], 18
    jmp .pl
.pd:
    pop esi
    pop eax
    ret

k_draw_wallpaper:
    mov dword [r_x], 0
    mov dword [r_w], 800
    mov dword [r_h], 100
    mov dword [r_y], 0
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect
    mov dword [r_y], 100
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect
    mov dword [r_y], 200
    mov dword [r_rgb], 0x001D4ED8
    call k_fill_rect
    mov dword [r_y], 300
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect
    mov dword [r_y], 400
    mov dword [r_rgb], 0x000284C7
    call k_fill_rect
    mov dword [r_y], 500
    mov dword [r_rgb], 0x000369A1
    call k_fill_rect
    ret

k_splash_modern:
    call k_draw_wallpaper

    mov dword [r_x], 270
    mov dword [r_y], 110
    mov dword [r_w], 260
    mov dword [r_h], 200
    mov dword [r_rgb], 0x00090D16
    call k_fill_rect

    mov dword [r_x], 335
    mov dword [r_y], 126
    mov dword [r_w], 120
    mov dword [r_h], 92
    mov dword [r_rgb], 0x00CBD5E1
    call k_fill_rect
    mov dword [r_x], 349
    mov dword [r_y], 138
    mov dword [r_w], 92
    mov dword [r_h], 64
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect
    mov dword [r_x], 360
    mov dword [r_y], 150
    mov dword [r_w], 44
    mov dword [r_h], 4
    mov dword [r_rgb], 0x004ADE80
    call k_fill_rect
    mov dword [r_x], 360
    mov dword [r_y], 162
    mov dword [r_w], 66
    mov dword [r_h], 4
    mov dword [r_rgb], 0x0038BDF8
    call k_fill_rect
    mov dword [r_x], 377
    mov dword [r_y], 218
    mov dword [r_w], 36
    mov dword [r_h], 12
    mov dword [r_rgb], 0x0064748B
    call k_fill_rect
    mov dword [r_x], 357
    mov dword [r_y], 230
    mov dword [r_w], 76
    mov dword [r_h], 8
    mov dword [r_rgb], 0x0094A3B8
    call k_fill_rect

    mov dword [r_x], 330
    mov dword [r_y], 254
    mov dword [r_w], 140
    mov dword [r_h], 42
    mov dword [r_rgb], 0x0078350F
    call k_fill_rect

    mov dword [r_x], 380
    mov dword [r_y], 188
    mov dword [r_w], 38
    mov dword [r_h], 66
    mov dword [r_rgb], 0x001D4ED8
    call k_fill_rect
    mov dword [r_x], 386
    mov dword [r_y], 158
    mov dword [r_w], 26
    mov dword [r_h], 28
    mov dword [r_rgb], 0x00FDBA74
    call k_fill_rect
    mov dword [r_x], 386
    mov dword [r_y], 154
    mov dword [r_w], 26
    mov dword [r_h], 8
    mov dword [r_rgb], 0x00451A03
    call k_fill_rect
    mov dword [r_x], 362
    mov dword [r_y], 204
    mov dword [r_w], 24
    mov dword [r_h], 10
    mov dword [r_rgb], 0x001D4ED8
    call k_fill_rect

    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 352
    mov dword [t_py], 335
    mov esi, splash_t1
    call k_print_xy

    mov dword [t_fg_rgb], 0x00BAE6FD
    mov dword [t_px], 304
    mov dword [t_py], 360
    mov esi, splash_t2
    call k_print_xy

    mov dword [r_x], 220
    mov dword [r_y], 410
    mov dword [r_w], 360
    mov dword [r_h], 14
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect
    call k_flip_screen

    mov esi, ode_30_notes
    mov dword [bar_w], 0
.play_sp:
    lodsw
    or ax, ax
    jz .end_sp
    mov dx, ax
    lodsw
    movzx eax, ax
    push esi
    push eax

    add dword [bar_w], 12
    mov eax, [bar_w]
    mov [r_w], eax
    mov dword [r_x], 220
    mov dword [r_y], 410
    mov dword [r_h], 14
    mov dword [r_rgb], 0x0038BDF8
    call k_fill_rect
    call k_flip_screen

    mov ax, dx
    pop edx
    call k_tone_ms
    mov eax, 35
    call k_sleep_ms
    pop esi
    jmp .play_sp
.end_sp:
    mov eax, 250
    call k_sleep_ms
    ret

splash_t1 db 'OldOS v3.0', 0
splash_t2 db 'with Oldog v2.2 HighColor', 0
bar_w     dd 0

ode_30_notes:
    dw 3619, 220, 3619, 220, 3416, 220, 3043, 220
    dw 3043, 220, 3416, 220, 3619, 220, 4063, 220
    dw 4560, 220, 4560, 220, 4063, 220, 3619, 220
    dw 3619, 330, 4063, 110, 4063, 440
    dw 3619, 220, 3619, 220, 3416, 220, 3043, 220
    dw 3043, 220, 3416, 220, 3619, 220, 4063, 220
    dw 4560, 220, 4560, 220, 4063, 220, 3619, 220
    dw 4063, 330, 4560, 110, 4560, 440
    dw 0, 0

r_x       dd 0
r_y       dd 0
r_w       dd 0
r_h       dd 0
r_rgb     dd 0
t_px      dd 0
t_py      dd 0
t_fg_rgb  dd 0x00FFFFFF
t_bg_rgb  dd 0x00000000
t_transp  db 0
tmp_w     dd 0
tmp_h     dd 0
tmp_c16   dw 0
tmp_fg    dw 0
tmp_bg    dw 0
