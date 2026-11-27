start_oldog_v2:
    call k_init_ps2_mouse_v2
    call v2_init_paint
    call v2_init_pong
    mov dword [mx], 400
    mov dword [my], 300
    mov byte [midx], 0
    mov byte [mclk], 0
    mov byte [m_down], 0
    mov byte [v2_menu], 0
    mov byte [v2_app], 0
    mov byte [web_page], 0
    mov byte [last_sec], 0xFF
    mov byte [pg_ticks], 0

v2_render_frame:
    call k_draw_wallpaper
    call v2_draw_mascot
    call v2_draw_desktop_icons

    cmp byte [v2_app], 0
    je .no_win
    cmp byte [v2_app], 3
    je .draw_exit
    call v2_draw_app_win
    jmp .no_win
.draw_exit:
    call v2_draw_exit_win

.no_win:
    ; Barra de Tarefas Moderna Escura
    mov dword [r_x], 0
    mov dword [r_y], 564
    mov dword [r_w], 800
    mov dword [r_h], 36
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    mov dword [r_x], 8
    mov dword [r_y], 569
    mov dword [r_w], 76
    mov dword [r_h], 26
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 26
    mov dword [t_py], 574
    mov esi, v2_btn_start
    call k_print_xy

    call v2_update_clock_only

    cmp byte [v2_menu], 1
    jne .skip_mnu
    call v2_draw_start_menu

.skip_mnu:
    call v2_draw_cursor_hd
    call k_flip_screen

v2_loop:
    in al, 0x64
    test al, 0x01
    jnz .has_input

    ; Se o OldPong (v2_app = 9) estiver aberto, atualiza a fisica a cada ~30ms
    cmp byte [v2_app], 9
    jne .chk_rtc
    mov eax, 1
    call k_sleep_ms
    inc byte [pg_ticks]
    cmp byte [pg_ticks], 30
    jb .chk_rtc
    mov byte [pg_ticks], 0
    call v2_tick_pong
    jmp v2_render_frame

.chk_rtc:
    mov al, 0x00
    out 0x70, al
    in al, 0x71
    cmp al, [last_sec]
    je v2_loop

    mov [last_sec], al
    call v2_update_clock_only
    call k_flip_screen
    jmp v2_loop

.has_input:
    test al, 0x20
    jnz .mouse_b

    in al, 0x60
    test al, 0x80
    jnz v2_loop

    cmp al, 0x01
    je .open_exit

    cmp byte [v2_app], 3
    je .exit_keys
    cmp byte [v2_app], 1
    je .note_keys
    cmp byte [v2_app], 2
    je .calc_keys
    cmp byte [v2_app], 6
    je .music_keys
    cmp byte [v2_app], 9
    je .pong_keys

    cmp al, 0x11
    je .ku
    cmp al, 0x1F
    je .kd
    cmp al, 0x1E
    je .kl
    cmp al, 0x20
    je .kr
    cmp al, 0x1C
    je v2_handle_click
    jmp v2_loop

.open_exit:
    mov byte [v2_app], 3
    jmp v2_render_frame

.exit_keys:
    cmp al, 0x02
    je k_real_poweroff
    cmp al, 0x03
    je cmd_reboot
    cmp al, 0x04
    je start_shell32
    jmp v2_loop

.music_keys:
    cmp al, 0x02
    je v2_play_s1
    cmp al, 0x03
    je v2_play_s2
    cmp al, 0x04
    je v2_play_s3
    cmp al, 0x05
    je v2_play_s4
    cmp al, 0x06
    je v2_play_s5
    jmp v2_loop

.pong_keys:
    cmp al, 0x1E            ; 'A'
    je .pg_l
    cmp al, 0x20            ; 'D'
    je .pg_r
    cmp al, 0x13            ; 'R'
    je .pg_rst
    jmp v2_loop
.pg_l:
    cmp dword [pg_px], 185
    jle v2_loop
    sub dword [pg_px], 24
    jmp v2_render_frame
.pg_r:
    cmp dword [pg_px], 530
    jge v2_loop
    add dword [pg_px], 24
    jmp v2_render_frame
.pg_rst:
    call v2_init_pong
    jmp v2_render_frame

.ku: sub dword [my], 16
     jmp .clamp
.kd: add dword [my], 16
     jmp .clamp
.kl: sub dword [mx], 16
     jmp .clamp
.kr: add dword [mx], 16
     jmp .clamp

.mouse_b:
    in al, 0x60
    movzx ebx, byte [midx]
    or ebx, ebx
    jnz .sb
    test al, 0x08
    jz v2_loop
.sb:
    mov [mpkt + ebx], al
    inc byte [midx]
    cmp byte [midx], 3
    jb v2_loop

    mov byte [midx], 0
    mov al, [mpkt]
    test al, 0x01
    jz .btn_up
    cmp byte [m_down], 0
    jne .still_down
    mov byte [mclk], 1
.still_down:
    mov byte [m_down], 1
    jmp .move_xy
.btn_up:
    mov byte [m_down], 0

.move_xy:
    movsx ebx, byte [mpkt + 1]
    add [mx], ebx

    ; Se OldPong estiver aberto, touchpad/mouse move a raquete
    cmp byte [v2_app], 9
    jne .skip_pg_m
    add [pg_px], ebx
    cmp dword [pg_px], 175
    jge .pg_max
    mov dword [pg_px], 175
.pg_max:
    cmp dword [pg_px], 540
    jle .skip_pg_m
    mov dword [pg_px], 540
.skip_pg_m:

    movsx ebx, byte [mpkt + 2]
    sub [my], ebx

.clamp:
    cmp dword [mx], 4
    jge .x2
    mov dword [mx], 4
.x2: cmp dword [mx], 784
    jle .y1
    mov dword [mx], 784
.y1: cmp dword [my], 4
    jge .y2
    mov dword [my], 4
.y2: cmp dword [my], 584
    jle .done_m
    mov dword [my], 584
.done_m:
    ; Se OldPaint (v2_app = 8) estiver aberto e botao segurado, pinta continuo!
    cmp byte [v2_app], 8
    jne .chk_clk_now
    cmp byte [m_down], 1
    jne .chk_clk_now
    call v2_paint_brush

.chk_clk_now:
    cmp byte [mclk], 1
    je v2_handle_click
    jmp v2_render_frame

.note_keys:
    cmp al, 58
    jae v2_loop
    movzx ebx, al
    mov al, [keymap + ebx]
    or al, al
    jz v2_loop
    mov ebx, [v2_nlen]
    cmp al, 8
    je .nbs
    cmp al, 32
    jb v2_loop
    cmp ebx, 50
    jae v2_loop
    mov [v2_nbuf + ebx], al
    inc dword [v2_nlen]
    mov byte [v2_nbuf + ebx + 1], 0
    mov byte [note_fs_msg], 0
    jmp v2_render_frame
.nbs:
    or ebx, ebx
    jz v2_loop
    dec dword [v2_nlen]
    mov ebx, [v2_nlen]
    mov byte [v2_nbuf + ebx], 0
    jmp v2_render_frame

.calc_keys:
    cmp al, 58
    jae v2_loop
    movzx ebx, al
    mov al, [keymap + ebx]
    cmp al, 'c'
    je .cclr
    cmp al, '-'
    je .cdec
    cmp al, '0'
    jb v2_loop
    cmp al, '9'
    ja v2_loop
    sub al, '0'
    movzx eax, al
    add [v2_cval], eax
    jmp v2_render_frame
.cclr:
    mov dword [v2_cval], 0
    jmp v2_render_frame
.cdec:
    cmp dword [v2_cval], 0
    je v2_loop
    dec dword [v2_cval]
    jmp v2_render_frame

v2_update_clock_only:
    mov dword [r_x], 645
    mov dword [r_y], 568
    mov dword [r_w], 150
    mov dword [r_h], 28
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    call k_get_cmos_str
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 650
    mov dword [t_py], 574
    mov esi, cmos_buf
    call k_print_xy
    ret

last_sec db 0xFF
pg_ticks db 0
m_down   db 0

%include "oldog_v2_clicks.asm"
%include "oldog_v2_draw.asm"
%include "oldog_v2_apps.asm"
%include "oldog_v2_paint_game.asm"
%include "oldog_v2_fe.asm"
