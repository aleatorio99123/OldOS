v2_init_paint:
    pushad
    mov edi, 0x00300000
    mov ecx, 440 * 125
    mov eax, 0xFFFFFFFF
    rep stosd
    mov dword [pt_color], 0x000F172A
    mov byte [pt_fs_msg], 0
    popad
    ret

v2_draw_paint_win:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_paint
    call k_print_xy

    ; Paleta de Cores (X=166..346, Y=134..160)
    mov dword [r_x], 166
    mov dword [r_y], 134
    mov dword [r_w], 28
    mov dword [r_h], 26
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    mov dword [r_x], 200
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect

    mov dword [r_x], 234
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect

    mov dword [r_x], 268
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect

    mov dword [r_x], 302
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect

    ; Botoes OldFS no OldPaint: [Save] (344..404), [Load] (412..472), [Del] (480..540), [Clear] (548..620)
    mov dword [r_x], 344
    mov dword [r_y], 134
    mov dword [r_w], 60
    mov dword [r_h], 26
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 356
    mov dword [t_py], 140
    mov esi, pt_b_save
    call k_print_xy

    mov dword [r_x], 412
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect
    mov dword [t_px], 424
    mov esi, pt_b_load
    call k_print_xy

    mov dword [r_x], 480
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov dword [t_px], 496
    mov esi, pt_b_del
    call k_print_xy

    mov dword [r_x], 548
    mov dword [r_w], 72
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 564
    mov esi, pt_btn_clr
    call k_print_xy

    ; Copia Canvas (440x250) para o Backbuffer em X=180, Y=175
    pushad
    mov esi, 0x00300000
    mov edi, 0x00200000 + (175 * 1600) + (180 * 2)
    mov edx, 250
.cpy_y:
    push edi
    mov ecx, 220
    rep movsd
    pop edi
    add edi, 1600
    dec edx
    jnz .cpy_y
    popad

    ; Status OldFS no rodape do OldPaint (Y=436)
    cmp byte [pt_fs_msg], 1
    je .p_ok
    cmp byte [pt_fs_msg], 2
    je .p_ld
    cmp byte [pt_fs_msg], 3
    je .p_dl
    cmp byte [pt_fs_msg], 4
    je .p_er
    ret
.p_ok:
    mov dword [t_fg_rgb], 0x0016A34A
    mov dword [t_px], 180
    mov dword [t_py], 436
    mov esi, oldfs_msg_ok
    call k_print_xy
    ret
.p_ld:
    mov dword [t_fg_rgb], 0x002563EB
    mov dword [t_px], 180
    mov dword [t_py], 436
    mov esi, oldfs_msg_ld
    call k_print_xy
    ret
.p_dl:
    mov dword [t_fg_rgb], 0x00EA580C
    mov dword [t_px], 180
    mov dword [t_py], 436
    mov esi, oldfs_msg_del
    call k_print_xy
    ret
.p_er:
    mov dword [t_fg_rgb], 0x00DC2626
    mov dword [t_px], 180
    mov dword [t_py], 436
    mov esi, oldfs_msg_err
    call k_print_xy
    ret

v2_paint_brush:
    cmp dword [mx], 184
    jl .done
    cmp dword [mx], 612
    jg .done
    cmp dword [my], 179
    jl .done
    cmp dword [my], 418
    jg .done

    pushad
    mov eax, [pt_color]
    mov [r_rgb], eax
    call k_rgb_to_565
    mov bx, ax

    mov eax, [my]
    sub eax, 177
    mov edx, 880
    mul edx
    mov edx, [mx]
    sub edx, 182
    shl edx, 1
    add eax, edx
    lea edi, [0x00300000 + eax]

    mov ax, bx
    mov edx, 6
.by:
    push edi
    mov ecx, 6
    rep stosw
    pop edi
    add edi, 880
    dec edx
    jnz .by
    popad
.done:
    ret

v2_init_pong:
    mov dword [pg_px], 360
    mov dword [pg_bx], 395
    mov dword [pg_by], 280
    mov dword [pg_vx], 6
    mov dword [pg_vy], -5
    mov dword [pg_score], 0
    mov byte [pg_over], 0
    ret

v2_draw_pong_win:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_pong
    call k_print_xy

    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 170
    mov dword [t_py], 136
    mov esi, pg_hint
    call k_print_xy

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 530
    mov dword [t_py], 136
    mov esi, pg_lbl_sc
    call k_print_xy

    mov eax, [pg_score]
    mov edi, num_tmp
    call k_int_to_str
    mov dword [t_px], 590
    mov dword [t_py], 136
    mov esi, num_tmp
    call k_print_xy

    mov dword [r_x], 170
    mov dword [r_y], 164
    mov dword [r_w], 460
    mov dword [r_h], 286
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    cmp byte [pg_over], 1
    je .pg_gameover

    mov dword [r_x], 185
    mov dword [r_y], 178
    mov dword [r_w], 100
    mov dword [r_h], 14
    mov dword [r_rgb], 0x00EF4444
    call k_fill_rect

    mov dword [r_x], 295
    mov dword [r_rgb], 0x00FACC15
    call k_fill_rect

    mov dword [r_x], 405
    mov dword [r_rgb], 0x0022C55E
    call k_fill_rect

    mov dword [r_x], 515
    mov dword [r_rgb], 0x0038BDF8
    call k_fill_rect

    mov eax, [pg_px]
    mov [r_x], eax
    mov dword [r_y], 426
    mov dword [r_w], 84
    mov dword [r_h], 10
    mov dword [r_rgb], 0x003B82F6
    call k_fill_rect

    mov eax, [pg_bx]
    mov [r_x], eax
    mov eax, [pg_by]
    mov [r_y], eax
    mov dword [r_w], 10
    mov dword [r_h], 10
    mov dword [r_rgb], 0x00FFFFFF
    call k_fill_rect
    ret

.pg_gameover:
    mov dword [t_fg_rgb], 0x00F87171
    mov dword [t_px], 265
    mov dword [t_py], 295
    mov esi, pg_msg_over
    call k_print_xy
    ret

v2_tick_pong:
    cmp byte [pg_over], 1
    je .done

    mov eax, [pg_vx]
    add [pg_bx], eax
    mov eax, [pg_vy]
    add [pg_by], eax

    cmp dword [pg_bx], 174
    jg .chk_r
    mov dword [pg_bx], 174
    neg dword [pg_vx]
    mov ax, 2200
    mov edx, 12
    call k_tone_ms
.chk_r:
    cmp dword [pg_bx], 616
    jl .chk_t
    mov dword [pg_bx], 616
    neg dword [pg_vx]
    mov ax, 2200
    mov edx, 12
    call k_tone_ms
.chk_t:
    cmp dword [pg_by], 194
    jg .chk_pad
    mov dword [pg_by], 194
    neg dword [pg_vy]
    inc dword [pg_score]
    mov ax, 1100
    mov edx, 15
    call k_tone_ms
.chk_pad:
    cmp dword [pg_by], 416
    jl .done
    cmp dword [pg_by], 430
    jg .chk_bot

    mov eax, [pg_px]
    sub eax, 10
    cmp [pg_bx], eax
    jl .chk_bot
    add eax, 96
    cmp [pg_bx], eax
    jg .chk_bot

    mov dword [pg_by], 415
    neg dword [pg_vy]
    inc dword [pg_score]
    mov ax, 1100
    mov edx, 15
    call k_tone_ms
    jmp .done

.chk_bot:
    cmp dword [pg_by], 438
    jl .done
    mov byte [pg_over], 1
    mov ax, 3000
    mov edx, 80
    call k_tone_ms
.done:
    ret

v2_t_paint   db 'OldPaint v2.0 (OldFS Storage)', 0
pt_b_save    db 'Save', 0
pt_b_load    db 'Load', 0
pt_b_del     db 'Del', 0
pt_btn_clr   db 'Clear', 0
pt_color     dd 0x000F172A
pt_fs_msg    db 0

v2_t_pong    db 'OldPong Arcade v1.0', 0
pg_hint      db 'Mouse or A/D to move | R = Restart', 0
pg_lbl_sc    db 'Score:', 0
pg_msg_over  db 'GAME OVER! Press R to play again.', 0

pg_px        dd 360
pg_bx        dd 395
pg_by        dd 280
pg_vx        dd 6
pg_vy        dd -5
pg_score     dd 0
pg_over      db 0