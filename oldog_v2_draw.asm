v2_draw_desktop_icons:
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF

    ; 1. Bloco de Notas
    mov dword [r_x], 30
    mov dword [r_y], 28
    mov dword [r_w], 38
    mov dword [r_h], 44
    mov dword [r_rgb], 0x00F8FAFC
    call k_fill_rect
    mov dword [r_x], 35
    mov dword [r_y], 36
    mov dword [r_w], 24
    mov dword [r_h], 3
    mov dword [r_rgb], 0x0064748B
    call k_fill_rect
    mov dword [r_y], 44
    call k_fill_rect
    mov dword [r_y], 52
    call k_fill_rect
    mov dword [r_x], 60
    mov dword [r_y], 34
    mov dword [r_w], 8
    mov dword [r_h], 34
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect
    mov dword [t_px], 30
    mov dword [t_py], 76
    mov esi, v2_i1
    call k_print_xy

    ; 2. Calculadora
    mov dword [r_x], 30
    mov dword [r_y], 108
    mov dword [r_w], 38
    mov dword [r_h], 44
    mov dword [r_rgb], 0x00334155
    call k_fill_rect
    mov dword [r_x], 34
    mov dword [r_y], 113
    mov dword [r_w], 30
    mov dword [r_h], 10
    mov dword [r_rgb], 0x004ADE80
    call k_fill_rect
    mov dword [r_x], 35
    mov dword [r_y], 128
    mov dword [r_w], 12
    mov dword [r_h], 8
    mov dword [r_rgb], 0x0094A3B8
    call k_fill_rect
    mov dword [r_x], 51
    mov dword [r_rgb], 0x00F97316
    call k_fill_rect
    mov dword [r_x], 35
    mov dword [r_y], 140
    mov dword [r_rgb], 0x0094A3B8
    call k_fill_rect
    mov dword [r_x], 51
    call k_fill_rect
    mov dword [t_px], 34
    mov dword [t_py], 156
    mov esi, v2_i2
    call k_print_xy

    ; 3. OldWeb Browser
    mov dword [r_x], 30
    mov dword [r_y], 188
    mov dword [r_w], 40
    mov dword [r_h], 40
    mov dword [r_rgb], 0x000284C7
    call k_fill_rect
    mov dword [r_x], 36
    mov dword [r_y], 194
    mov dword [r_w], 14
    mov dword [r_h], 14
    mov dword [r_rgb], 0x0022C55E
    call k_fill_rect
    mov dword [r_x], 52
    mov dword [r_y], 208
    mov dword [r_w], 12
    mov dword [r_h], 14
    call k_fill_rect
    mov dword [t_px], 26
    mov dword [t_py], 234
    mov esi, v2_i3
    call k_print_xy

    ; 4. OldStore Loja de Apps
    mov dword [r_x], 40
    mov dword [r_y], 264
    mov dword [r_w], 20
    mov dword [r_h], 8
    mov dword [r_rgb], 0x00F8FAFC
    call k_fill_rect
    mov dword [r_x], 30
    mov dword [r_y], 272
    mov dword [r_w], 40
    mov dword [r_h], 36
    mov dword [r_rgb], 0x00EA580C
    call k_fill_rect
    mov dword [r_x], 44
    mov dword [r_y], 282
    mov dword [r_w], 12
    mov dword [r_h], 14
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect
    mov dword [t_px], 22
    mov dword [t_py], 314
    mov esi, v2_i4
    call k_print_xy

    ; 5. Smusic Dog Old (apos instalar)
    cmp byte [smusic_installed], 1
    jne .col2_icons
    mov dword [r_x], 30
    mov dword [r_y], 348
    mov dword [r_w], 40
    mov dword [r_h], 40
    mov dword [r_rgb], 0x007C3AED
    call k_fill_rect
    mov dword [r_x], 44
    mov dword [r_y], 356
    mov dword [r_w], 14
    mov dword [r_h], 5
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect
    mov dword [r_x], 44
    mov dword [r_y], 356
    mov dword [r_w], 4
    mov dword [r_h], 22
    call k_fill_rect
    mov dword [r_x], 38
    mov dword [r_y], 372
    mov dword [r_w], 10
    mov dword [r_h], 8
    call k_fill_rect
    mov dword [t_px], 26
    mov dword [t_py], 394
    mov esi, v2_i5
    call k_print_xy

.col2_icons:
    ; 6. OldOS Updater (Coluna 2: X=104, Y=28)
    mov dword [r_x], 104
    mov dword [r_y], 28
    mov dword [r_w], 40
    mov dword [r_h], 40
    mov dword [r_rgb], 0x000284C7
    call k_fill_rect
    mov dword [r_x], 112
    mov dword [r_y], 38
    mov dword [r_w], 24
    mov dword [r_h], 6
    mov dword [r_rgb], 0x00FFFFFF
    call k_fill_rect
    mov dword [r_x], 112
    mov dword [r_y], 52
    mov dword [r_w], 24
    mov dword [r_h], 6
    call k_fill_rect
    mov dword [t_px], 98
    mov dword [t_py], 76
    mov esi, v2_i_upd
    call k_print_xy
    ret

v2_draw_start_menu:
    mov dword [r_x], 8
    mov dword [r_y], 344
    mov dword [r_w], 180
    mov dword [r_h], 216
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect

    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF

    mov dword [t_px], 20
    mov dword [t_py], 356
    mov esi, v2_m1
    call k_print_xy

    mov dword [t_px], 20
    mov dword [t_py], 390
    mov esi, v2_m2
    call k_print_xy

    mov dword [t_px], 20
    mov dword [t_py], 424
    mov esi, v2_m3_web
    call k_print_xy

    mov dword [t_px], 20
    mov dword [t_py], 458
    mov esi, v2_m4_store
    call k_print_xy

    mov dword [t_px], 20
    mov dword [t_py], 492
    mov esi, v2_m_upd
    call k_print_xy

    mov dword [t_px], 20
    mov dword [t_py], 528
    mov esi, v2_m6_exit
    call k_print_xy
    ret

v2_draw_mascot:
    mov dword [r_x], 410
    mov dword [r_y], 210
    mov dword [r_w], 104
    mov dword [r_h], 84
    mov dword [r_rgb], 0x00CBD5E1
    call k_fill_rect
    mov dword [r_x], 422
    mov dword [r_y], 220
    mov dword [r_w], 80
    mov dword [r_h], 58
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect
    mov dword [r_x], 432
    mov dword [r_y], 234
    mov dword [r_w], 36
    mov dword [r_h], 4
    mov dword [r_rgb], 0x004ADE80
    call k_fill_rect
    mov dword [r_x], 446
    mov dword [r_y], 294
    mov dword [r_w], 32
    mov dword [r_h], 10
    mov dword [r_rgb], 0x0064748B
    call k_fill_rect
    mov dword [r_x], 430
    mov dword [r_y], 304
    mov dword [r_w], 64
    mov dword [r_h], 8
    mov dword [r_rgb], 0x0094A3B8
    call k_fill_rect
    mov dword [r_x], 356
    mov dword [r_y], 282
    mov dword [r_w], 54
    mov dword [r_h], 5
    mov dword [r_rgb], 0x00020617
    call k_fill_rect
    mov dword [r_x], 350
    mov dword [r_y], 266
    mov dword [r_w], 8
    mov dword [r_h], 8
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect
    mov dword [r_x], 276
    mov dword [r_y], 268
    mov dword [r_w], 64
    mov dword [r_h], 30
    mov dword [r_rgb], 0x0092400E
    call k_fill_rect
    mov dword [r_x], 282
    mov dword [r_y], 298
    mov dword [r_w], 12
    mov dword [r_h], 14
    mov dword [r_rgb], 0x0078350F
    call k_fill_rect
    mov dword [r_x], 320
    call k_fill_rect
    mov dword [r_x], 316
    mov dword [r_y], 236
    mov dword [r_w], 40
    mov dword [r_h], 34
    mov dword [r_rgb], 0x0092400E
    call k_fill_rect
    mov dword [r_x], 312
    mov dword [r_y], 242
    mov dword [r_w], 12
    mov dword [r_h], 22
    mov dword [r_rgb], 0x00451A03
    call k_fill_rect
    mov dword [r_x], 348
    mov dword [r_y], 250
    mov dword [r_w], 18
    mov dword [r_h], 16
    mov dword [r_rgb], 0x00B45309
    call k_fill_rect
    mov dword [r_x], 352
    mov dword [r_y], 264
    mov dword [r_w], 8
    mov dword [r_h], 4
    mov dword [r_rgb], 0x00FFFFFF
    call k_fill_rect
    mov dword [r_x], 338
    mov dword [r_y], 244
    mov dword [r_w], 8
    mov dword [r_h], 8
    call k_fill_rect
    mov dword [r_x], 320
    mov dword [r_y], 268
    mov dword [r_w], 28
    mov dword [r_h], 5
    mov dword [r_rgb], 0x00EF4444
    call k_fill_rect
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00E2E8F0
    mov dword [t_px], 336
    mov dword [t_py], 326
    mov esi, v2_mascot_lbl
    call k_print_xy
    ret

v2_draw_cursor_hd:
    pushad
    mov esi, v2_cmask
    mov ebp, v2_cfill
    mov ecx, 14
    mov edx, [my]
.yl:
    push ecx
    mov bl, [esi]
    mov bh, [ebp]
    mov ecx, 8
    mov edi, [mx]
.xl:
    test bl, 0x80
    jz .nb
    mov dword [r_x], edi
    mov [r_y], edx
    mov dword [r_w], 1
    mov dword [r_h], 1
    mov dword [r_rgb], 0x00000000
    test bh, 0x80
    jz .set_p
    mov dword [r_rgb], 0x00FFFFFF
.set_p:
    call k_fill_rect
.nb:
    shl bl, 1
    shl bh, 1
    inc edi
    loop .xl
    pop ecx
    inc esi
    inc ebp
    inc edx
    loop .yl
    popad
    ret

k_init_ps2_mouse_v2:
    call .ww
    mov al, 0xA8
    out 0x64, al
    call .ww
    mov al, 0xD4
    out 0x64, al
    call .ww
    mov al, 0xF4
    out 0x60, al
    call .wr
    in al, 0x60
    ret
.ww: in al, 0x64
    test al, 0x02
    jnz .ww
    ret
.wr: in al, 0x64
    test al, 0x01
    jz .wr
    ret