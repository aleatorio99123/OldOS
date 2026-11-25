start_gui32:
    call k_init_ps2_mouse32
    call gui32_init_game
    mov dword [m_x], 320
    mov dword [m_y], 240
    mov byte [m_idx], 0
    mov byte [m_clk], 0
    mov byte [g_menu], 0
    mov byte [g_app], 0

gui32_redraw:
    mov dword [r_x], 0
    mov dword [r_y], 0
    mov dword [r_w], 640
    mov dword [r_h], 480
    mov byte [r_col], 3
    call k_draw_rect32

    mov dword [r_x], 0
    mov dword [r_y], 454
    mov dword [r_w], 640
    mov dword [r_h], 26
    mov byte [r_col], 7
    call k_draw_rect32

    mov dword [r_x], 0
    mov dword [r_y], 454
    mov dword [r_w], 640
    mov dword [r_h], 2
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [r_x], 8
    mov dword [r_y], 458
    mov dword [r_w], 72
    mov dword [r_h], 18
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [t_row], 29
    mov dword [t_col], 2
    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov esi, g_str_start
    call k_print32

    call gui32_draw_mascot
    call gui32_draw_icons

    cmp byte [g_app], 0
    je .no_win
    cmp byte [g_app], 3
    je .draw_exit_dlg
    call gui32_draw_window
    jmp .no_win
.draw_exit_dlg:
    call gui32_draw_exit_dialog

.no_win:
    cmp byte [g_menu], 1
    jne .skip_m
    call gui32_draw_menu
.skip_m:
    call gui32_save_bg
    call gui32_draw_cursor

gui32_loop:
    in al, 0x64
    test al, 0x01
    jnz .has_hw_event

    ; Se o Jogo (g_app = 4) estiver ativo, aguarda 1ms e conta 35ms para o proximo frame
    cmp byte [g_app], 4
    jne gui32_loop
    mov eax, 1
    call k_sleep_ms
    inc byte [gm_ticks]
    cmp byte [gm_ticks], 35
    jb gui32_loop
    mov byte [gm_ticks], 0

    call gui32_tick_game
    call gui32_restore_bg
    call gui32_draw_game_arena
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop

.has_hw_event:
    test al, 0x20
    jnz .mouse_byte

    in al, 0x60
    test al, 0x80
    jnz gui32_loop

    cmp al, 0x01
    je .open_exit_dlg

    cmp byte [g_app], 3
    je .exit_dlg_keys
    cmp byte [g_app], 1
    je .app_note_key
    cmp byte [g_app], 2
    je .app_calc_key
    cmp byte [g_app], 4
    je .app_game_key

    cmp al, 0x11
    je .k_up
    cmp al, 0x1F
    je .k_down
    cmp al, 0x1E
    je .k_left
    cmp al, 0x20
    je .k_right
    cmp al, 0x1C
    je .do_click
    jmp gui32_loop

.app_game_key:
    cmp al, 0x1E
    je .g_left
    cmp al, 0x20
    je .g_right
    cmp al, 0x13
    je .g_reset
    cmp al, 0x1C
    je .do_click
    jmp gui32_loop
.g_left:
    cmp dword [gm_px], 144
    jle gui32_loop
    sub dword [gm_px], 24
    call gui32_restore_bg
    call gui32_draw_game_arena
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop
.g_right:
    cmp dword [gm_px], 472
    jge gui32_loop
    add dword [gm_px], 24
    call gui32_restore_bg
    call gui32_draw_game_arena
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop
.g_reset:
    call gui32_init_game
    jmp gui32_redraw

.open_exit_dlg:
    mov byte [g_app], 3
    jmp gui32_redraw

.exit_dlg_keys:
    cmp al, 0x02
    je cmd_shutdown
    cmp al, 0x03
    je cmd_reboot
    cmp al, 0x04
    je start_shell32
    cmp al, 0x1C
    je .do_click
    jmp gui32_loop

.k_up:
    call gui32_restore_bg
    sub dword [m_y], 12
    jmp .clamp_cursor
.k_down:
    call gui32_restore_bg
    add dword [m_y], 12
    jmp .clamp_cursor
.k_left:
    call gui32_restore_bg
    sub dword [m_x], 12
    jmp .clamp_cursor
.k_right:
    call gui32_restore_bg
    add dword [m_x], 12
    jmp .clamp_cursor

.mouse_byte:
    in al, 0x60
    movzx ebx, byte [m_idx]
    or ebx, ebx
    jnz .store_b
    test al, 0x08
    jz gui32_loop
.store_b:
    mov [m_pkt + ebx], al
    inc byte [m_idx]
    cmp byte [m_idx], 3
    jb gui32_loop

    mov byte [m_idx], 0
    mov al, [m_pkt]
    test al, 0x01
    jz .no_mclk
    mov byte [m_clk], 1
.no_mclk:
    call gui32_restore_bg

    movsx ebx, byte [m_pkt + 1]
    add [m_x], ebx

    cmp byte [g_app], 4
    jne .skip_pad_m
    add [gm_px], ebx
    cmp dword [gm_px], 136
    jge .gp_max
    mov dword [gm_px], 136
.gp_max:
    cmp dword [gm_px], 472
    jle .skip_pad_m
    mov dword [gm_px], 472
.skip_pad_m:

    movsx ebx, byte [m_pkt + 2]
    sub [m_y], ebx

.clamp_cursor:
    cmp dword [m_x], 4
    jge .cx_max
    mov dword [m_x], 4
.cx_max:
    cmp dword [m_x], 620
    jle .cy_min
    mov dword [m_x], 620
.cy_min:
    cmp dword [m_y], 4
    jge .cy_max
    mov dword [m_y], 4
.cy_max:
    cmp dword [m_y], 460
    jle .after_move
    mov dword [m_y], 460

.after_move:
    cmp byte [m_clk], 1
    je .do_click
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop

.do_click:
    mov byte [m_clk], 0

    cmp byte [g_app], 3
    je .chk_exit_dlg_clicks

    cmp dword [m_x], 80
    ja .chk_menu_clk
    cmp dword [m_y], 454
    jb .chk_menu_clk
    xor byte [g_menu], 1
    jmp gui32_redraw

.chk_menu_clk:
    cmp byte [g_menu], 1
    jne .chk_x_btn
    mov byte [g_menu], 0
    cmp dword [m_x], 148
    ja .chk_x_btn
    cmp dword [m_y], 350
    jb .chk_x_btn
    cmp dword [m_y], 384
    jb .set_app1
    cmp dword [m_y], 418
    jb .set_app2
    mov byte [g_app], 3
    jmp gui32_redraw

.set_app1:
    mov byte [g_app], 1
    jmp gui32_redraw
.set_app2:
    mov byte [g_app], 2
    jmp gui32_redraw
.set_app4:
    call gui32_init_game
    mov byte [g_app], 4
    jmp gui32_redraw

.chk_x_btn:
    cmp byte [g_app], 0
    je .chk_ico_clk
    cmp dword [m_x], 536
    jb .chk_ico_clk
    cmp dword [m_x], 564
    ja .chk_ico_clk
    cmp dword [m_y], 54
    jb .chk_ico_clk
    cmp dword [m_y], 80
    ja .chk_ico_clk
    mov byte [g_app], 0
    jmp gui32_redraw

.chk_ico_clk:
    cmp dword [m_x], 64
    ja gui32_redraw
    cmp dword [m_y], 64
    jb .set_app1
    cmp dword [m_y], 128
    jb .set_app2
    cmp dword [m_y], 192
    jb .set_app4
    jmp gui32_redraw

.chk_exit_dlg_clicks:
    cmp dword [m_x], 448
    jb .chk_exit_btns
    cmp dword [m_x], 472
    ja .chk_exit_btns
    cmp dword [m_y], 144
    jb .chk_exit_btns
    cmp dword [m_y], 168
    ja .chk_exit_btns
    mov byte [g_app], 0
    jmp gui32_redraw

.chk_exit_btns:
    cmp dword [m_x], 200
    jb gui32_redraw
    cmp dword [m_x], 440
    ja gui32_redraw
    cmp dword [m_y], 190
    jb gui32_redraw
    cmp dword [m_y], 224
    jb cmd_shutdown
    cmp dword [m_y], 258
    jb cmd_reboot
    cmp dword [m_y], 292
    jb start_shell32
    jmp gui32_redraw

.app_note_key:
    call gui32_handle_note
    call gui32_restore_bg
    call gui32_draw_window
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop

.app_calc_key:
    call gui32_handle_calc
    call gui32_restore_bg
    call gui32_draw_window
    call gui32_save_bg
    call gui32_draw_cursor
    jmp gui32_loop

%include "gui32_apps.asm"
%include "gui32_game.asm"