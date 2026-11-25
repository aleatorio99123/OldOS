; ==========================================================
;   OLDOS SYSTEM UPDATER (COUNTDOWN + HARDWARE REBOOT)
; ==========================================================
v2_draw_updater_win:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_upd
    call k_print_xy

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 175
    mov dword [t_py], 150
    mov esi, upd_h1
    call k_print_xy

    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 175
    mov dword [t_py], 182
    mov esi, upd_p1
    call k_print_xy

    mov dword [t_px], 175
    mov dword [t_py], 204
    mov esi, upd_p2
    call k_print_xy

    ; Botao [Start System Update] (X=240..560, Y=270..316)
    mov dword [r_x], 240
    mov dword [r_y], 270
    mov dword [r_w], 320
    mov dword [r_h], 46
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect

    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 315
    mov dword [t_py], 285
    mov esi, upd_btn
    call k_print_xy
    ret

; Tela cheia de atualizacao com contagem regressiva de 10 segundos
v2_run_updater_countdown:
    mov dword [upd_sec], 10

.sec_loop:
    ; Fundo azul-escuro estilo tela de atualizacao moderna
    mov dword [r_x], 0
    mov dword [r_y], 0
    mov dword [r_w], 800
    mov dword [r_h], 600
    mov dword [r_rgb], 0x000B132B
    call k_fill_rect

    ; Cartao central
    mov dword [r_x], 130
    mov dword [r_y], 160
    mov dword [r_w], 540
    mov dword [r_h], 260
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect

    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x0038BDF8
    mov dword [t_px], 310
    mov dword [t_py], 185
    mov esi, upd_scr_title
    call k_print_xy

    ; Mensagem solicitada pelo usuario:
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 152
    mov dword [t_py], 235
    mov esi, upd_msg_insert
    call k_print_xy

    ; Linha de contagem: "Rebooting in X seconds to boot in new oldos.img"
    mov dword [t_fg_rgb], 0x00FACC15
    mov dword [t_px], 196
    mov dword [t_py], 275
    mov esi, upd_msg_reb1
    call k_print_xy

    mov eax, [upd_sec]
    mov edi, num_tmp
    call k_int_to_str
    mov dword [t_px], 308
    mov dword [t_py], 275
    mov esi, num_tmp
    call k_print_xy

    mov dword [t_px], 332
    mov dword [t_py], 275
    mov esi, upd_msg_reb2
    call k_print_xy

    ; Barra de progresso da contagem (X=180, Y=330, W=440, H=16)
    mov dword [r_x], 180
    mov dword [r_y], 330
    mov dword [r_w], 440
    mov dword [r_h], 16
    mov dword [r_rgb], 0x00334155
    call k_fill_rect

    ; Calcula largura preenchida = (10 - upd_sec) * 44
    mov eax, 10
    sub eax, [upd_sec]
    mov ebx, 44
    mul ebx
    or eax, eax
    jz .no_bar
    mov dword [r_x], 180
    mov dword [r_y], 330
    mov [r_w], eax
    mov dword [r_h], 16
    mov dword [r_rgb], 0x0022C55E
    call k_fill_rect
.no_bar:

    call k_flip_screen

    ; Bip curto de contagem no PC Speaker
    mov ax, 1200
    mov edx, 60
    call k_tone_ms

    ; Aguarda 940 ms (totalizando 1 segundo exato por ciclo)
    mov eax, 940
    call k_sleep_ms

    cmp dword [upd_sec], 0
    je .do_reboot
    dec dword [upd_sec]
    jmp .sec_loop

.do_reboot:
    mov ax, 900
    mov edx, 250
    call k_tone_ms
    jmp cmd_reboot

v2_i_upd       db 'Updater', 0
v2_m_upd       db '5. OldOS Updater', 0
v2_m6_exit     db '6. Exit...', 0
v2_t_upd       db 'OldOS System Updater v1.0', 0
upd_h1         db 'Upgrade OldOS to a new build:', 0
upd_p1         db '1. Prepare your USB drive with the new oldos.img.', 0
upd_p2         db '2. Click below and swap the drive during countdown.', 0
upd_btn        db 'Start System Update', 0
upd_scr_title  db 'OldOS System Updater', 0
upd_msg_insert db 'Insert the drive with new oldos.img or insert new oldos.img', 0
upd_msg_reb1   db 'Rebooting in ', 0
upd_msg_reb2   db ' seconds to boot in new oldos.img', 0
upd_sec        dd 10