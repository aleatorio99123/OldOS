gui32_init_game:
    mov dword [gm_px], 280
    mov dword [gm_bx], 312
    mov dword [gm_by], 240
    mov dword [gm_vx], 8
    mov dword [gm_vy], -6
    mov dword [gm_score], 0
    mov byte [gm_over], 0
    mov byte [gm_ticks], 0
    ret

gui32_draw_game:
    mov dword [t_row], 3
    mov dword [t_col], 16
    mov byte [t_fg], 15
    mov byte [t_bg], 1
    mov esi, g_t_game
    call k_print32

    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov dword [t_row], 6
    mov dword [t_col], 17
    mov esi, g_ghint
    call k_print32

    call gui32_draw_game_arena
    ret

gui32_draw_game_arena:
    ; Limpa apenas a area interna de jogo (sem repintar a janela inteira!)
    mov dword [r_x], 128
    mov dword [r_y], 116
    mov dword [r_w], 424
    mov dword [r_h], 256
    mov byte [r_col], 15
    call k_draw_rect32

    ; Atualiza Placar
    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov dword [t_row], 6
    mov dword [t_col], 56
    mov esi, g_gscore_lbl
    call k_print32

    mov eax, [gm_score]
    mov edi, g_cstr
    call k_int_to_str32
    mov dword [t_row], 6
    mov dword [t_col], 63
    mov esi, g_cstr
    call k_print32

    cmp byte [gm_over], 1
    je .draw_gameover

    ; Parede de Blocos Coloridos
    mov dword [r_x], 144
    mov dword [r_y], 124
    mov dword [r_w], 88
    mov dword [r_h], 14
    mov byte [r_col], 4
    call k_draw_rect32

    mov dword [r_x], 240
    mov dword [r_y], 124
    mov dword [r_w], 88
    mov dword [r_h], 14
    mov byte [r_col], 14
    call k_draw_rect32

    mov dword [r_x], 336
    mov dword [r_y], 124
    mov dword [r_w], 88
    mov dword [r_h], 14
    mov byte [r_col], 2
    call k_draw_rect32

    mov dword [r_x], 432
    mov dword [r_y], 124
    mov dword [r_w], 96
    mov dword [r_h], 14
    mov byte [r_col], 9
    call k_draw_rect32

    ; Raquete do Jogador
    mov eax, [gm_px]
    and eax, 0xFFFFFFF8
    mov [r_x], eax
    mov dword [r_y], 350
    mov dword [r_w], 72
    mov dword [r_h], 10
    mov byte [r_col], 1
    call k_draw_rect32

    ; Bolinha (8x8 Vermelha)
    mov eax, [gm_bx]
    and eax, 0xFFFFFFF8
    mov [r_x], eax
    mov eax, [gm_by]
    mov [r_y], eax
    mov dword [r_w], 8
    mov dword [r_h], 8
    mov byte [r_col], 4
    call k_draw_rect32
    ret

.draw_gameover:
    mov dword [t_row], 14
    mov dword [t_col], 28
    mov byte [t_fg], 4
    mov byte [t_bg], 15
    mov esi, g_gover_msg
    call k_print32
    ret

gui32_tick_game:
    cmp byte [gm_over], 1
    je .done

    mov eax, [gm_vx]
    add [gm_bx], eax
    mov eax, [gm_vy]
    add [gm_by], eax

    cmp dword [gm_bx], 136
    jg .chk_rwall
    mov dword [gm_bx], 136
    neg dword [gm_vx]
    call gui32_beep_low
.chk_rwall:
    cmp dword [gm_bx], 536
    jl .chk_twall
    mov dword [gm_bx], 536
    neg dword [gm_vx]
    call gui32_beep_low

.chk_twall:
    cmp dword [gm_by], 140
    jg .chk_paddle
    mov dword [gm_by], 140
    neg dword [gm_vy]
    inc dword [gm_score]
    call gui32_beep_high

.chk_paddle:
    cmp dword [gm_by], 342
    jl .done
    cmp dword [gm_by], 356
    jg .chk_floor

    mov eax, [gm_px]
    sub eax, 8
    cmp [gm_bx], eax
    jl .chk_floor
    add eax, 88
    cmp [gm_bx], eax
    jg .chk_floor

    mov dword [gm_by], 340
    neg dword [gm_vy]
    inc dword [gm_score]
    call gui32_beep_high
    jmp .done

.chk_floor:
    cmp dword [gm_by], 364
    jl .done
    mov byte [gm_over], 1
    call gui32_beep_low

.done:
    ret

gui32_beep_high:
    push eax
    mov al, 0xB6
    out 0x43, al
    mov ax, 1100
    out 0x42, al
    mov al, ah
    out 0x42, al
    in al, 0x61
    or al, 0x03
    out 0x61, al
    mov eax, 10
    call k_sleep_ms
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    pop eax
    ret

gui32_beep_low:
    push eax
    mov al, 0xB6
    out 0x43, al
    mov ax, 2600
    out 0x42, al
    mov al, ah
    out 0x42, al
    in al, 0x61
    or al, 0x03
    out 0x61, al
    mov eax, 10
    call k_sleep_ms
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    pop eax
    ret

g_ico_game   db 'Game', 0
g_t_game     db 'Oldog v1.0 - Brick Pong', 0
g_ghint      db 'A/D or Mouse to move | R = Restart', 0
g_gscore_lbl db 'Score: ', 0
g_gover_msg  db 'GAME OVER! Press R to play again.', 0

gm_px        dd 280
gm_bx        dd 312
gm_by        dd 240
gm_vx        dd 8
gm_vy        dd -6
gm_score     dd 0
gm_over      db 0
gm_ticks     db 0