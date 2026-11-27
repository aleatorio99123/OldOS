v2_draw_app_win:
    mov dword [r_x], 158
    mov dword [r_y], 98
    mov dword [r_w], 500
    mov dword [r_h], 380
    mov dword [r_rgb], 0x0009111E
    call k_fill_rect

    mov dword [r_x], 150
    mov dword [r_y], 90
    mov dword [r_w], 500
    mov dword [r_h], 380
    mov dword [r_rgb], 0x00F8FAFC
    call k_fill_rect

    mov dword [r_x], 150
    mov dword [r_y], 90
    mov dword [r_w], 500
    mov dword [r_h], 34
    mov dword [r_rgb], 0x001D4ED8
    call k_fill_rect

    mov dword [r_x], 616
    mov dword [r_y], 96
    mov dword [r_w], 26
    mov dword [r_h], 22
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 625
    mov dword [t_py], 99
    mov esi, v2_btn_x
    call k_print_xy

    cmp byte [v2_app], 2
    je .calc_ui
    cmp byte [v2_app], 4
    je .web_ui
    cmp byte [v2_app], 5
    je .store_ui
    cmp byte [v2_app], 6
    je .smusic_ui
    cmp byte [v2_app], 7
    je v2_draw_updater_win
    cmp byte [v2_app], 8
    je v2_draw_paint_win
    cmp byte [v2_app], 9
    je v2_draw_pong_win
    cmp byte [v2_app], 10
    je v2_draw_fe_win

    ; 1. Bloco de Notas
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_note
    call k_print_xy

    mov dword [r_x], 170
    mov dword [r_y], 134
    mov dword [r_w], 100
    mov dword [r_h], 26
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect
    mov dword [t_px], 188
    mov dword [t_py], 140
    mov esi, pt_b_save
    call k_print_xy

    mov dword [r_x], 280
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect
    mov dword [t_px], 298
    mov esi, pt_b_load
    call k_print_xy

    mov dword [r_x], 390
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov dword [t_px], 404
    mov esi, pt_b_del
    call k_print_xy

    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 170
    mov dword [t_py], 174
    mov esi, v2_nhint
    call k_print_xy

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 206
    mov esi, v2_nbuf
    call k_print_xy

    cmp byte [note_fs_msg], 1
    je .fs_ok_m
    cmp byte [note_fs_msg], 2
    je .fs_ld_m
    cmp byte [note_fs_msg], 3
    je .fs_er_m
    cmp byte [note_fs_msg], 4
    je .fs_dl_m
    ret
.fs_ok_m:
    mov dword [t_fg_rgb], 0x0016A34A
    mov dword [t_px], 170
    mov dword [t_py], 430
    mov esi, oldfs_msg_ok
    call k_print_xy
    ret
.fs_ld_m:
    mov dword [t_fg_rgb], 0x002563EB
    mov dword [t_px], 170
    mov dword [t_py], 430
    mov esi, oldfs_msg_ld
    call k_print_xy
    ret
.fs_dl_m:
    mov dword [t_fg_rgb], 0x00EA580C
    mov dword [t_px], 170
    mov dword [t_py], 430
    mov esi, oldfs_msg_del
    call k_print_xy
    ret
.fs_er_m:
    mov dword [t_fg_rgb], 0x00DC2626
    mov dword [t_px], 170
    mov dword [t_py], 430
    mov esi, oldfs_msg_err
    call k_print_xy
    ret

.calc_ui:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_calc
    call k_print_xy
    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 170
    mov dword [t_py], 144
    mov esi, v2_chint
    call k_print_xy
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 184
    mov esi, v2_cres
    call k_print_xy
    mov eax, [v2_cval]
    mov edi, num_tmp
    call k_int_to_str
    mov dword [t_px], 245
    mov dword [t_py], 184
    mov esi, num_tmp
    call k_print_xy
    ret

.web_ui:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_web
    call k_print_xy
    mov dword [r_x], 150
    mov dword [r_y], 124
    mov dword [r_w], 500
    mov dword [r_h], 38
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [t_fg_rgb], 0x001D4ED8
    mov dword [t_px], 168
    mov dword [t_py], 135
    mov esi, web_tabs
    call k_print_xy

    cmp byte [web_page], 1
    je .wp1
    cmp byte [web_page], 2
    je .wp2

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 184
    mov esi, wp0_h1
    call k_print_xy
    mov dword [t_fg_rgb], 0x00334155
    mov dword [t_px], 170
    mov dword [t_py], 216
    mov esi, wp0_p1
    call k_print_xy
    mov dword [t_fg_rgb], 0x002563EB
    mov dword [t_px], 170
    mov dword [t_py], 320
    mov esi, wp0_link
    call k_print_xy
    ret
.wp1:
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 184
    mov esi, wp1_h1
    call k_print_xy
    mov dword [t_fg_rgb], 0x00334155
    mov dword [t_px], 170
    mov dword [t_py], 216
    mov esi, wp1_p1
    call k_print_xy
    ret
.wp2:
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 184
    mov esi, wp2_h1
    call k_print_xy
    mov dword [t_fg_rgb], 0x002563EB
    mov dword [t_px], 170
    mov dword [t_py], 320
    mov esi, wp0_link
    call k_print_xy
    ret

.store_ui:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_store
    call k_print_xy
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 170
    mov dword [t_py], 145
    mov esi, st_hdr
    call k_print_xy
    mov dword [r_x], 170
    mov dword [r_y], 185
    mov dword [r_w], 460
    mov dword [r_h], 90
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [r_x], 185
    mov dword [r_y], 205
    mov dword [r_w], 50
    mov dword [r_h], 50
    mov dword [r_rgb], 0x007C3AED
    call k_fill_rect
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 250
    mov dword [t_py], 205
    mov esi, st_app_name
    call k_print_xy
    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 250
    mov dword [t_py], 230
    mov esi, st_app_desc
    call k_print_xy
    mov dword [r_x], 465
    mov dword [r_y], 212
    mov dword [r_w], 140
    mov dword [r_h], 38
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 485
    mov dword [t_py], 223
    cmp byte [smusic_installed], 1
    je .st_open_txt
    mov esi, st_btn_inst
    call k_print_xy
    ret
.st_open_txt:
    mov esi, st_btn_open
    call k_print_xy
    ret

.smusic_ui:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_smusic
    call k_print_xy
    mov dword [t_fg_rgb], 0x00475569
    mov dword [t_px], 175
    mov dword [t_py], 138
    mov esi, sm_hint
    call k_print_xy

    mov dword [r_x], 180
    mov dword [r_y], 175
    mov dword [r_w], 380
    mov dword [r_h], 32
    mov dword [r_rgb], 0x00EDE9FE
    call k_fill_rect
    mov dword [t_fg_rgb], 0x005B21B6
    mov dword [t_px], 195
    mov dword [t_py], 183
    mov esi, sm_t1
    call k_print_xy

    mov dword [r_x], 180
    mov dword [r_y], 215
    mov dword [r_w], 380
    mov dword [r_h], 32
    mov dword [r_rgb], 0x00EDE9FE
    call k_fill_rect
    mov dword [t_px], 195
    mov dword [t_py], 223
    mov esi, sm_t2
    call k_print_xy

    mov dword [r_x], 180
    mov dword [r_y], 255
    mov dword [r_w], 380
    mov dword [r_h], 32
    mov dword [r_rgb], 0x00EDE9FE
    call k_fill_rect
    mov dword [t_px], 195
    mov dword [t_py], 263
    mov esi, sm_t3
    call k_print_xy

    mov dword [r_x], 180
    mov dword [r_y], 295
    mov dword [r_w], 380
    mov dword [r_h], 32
    mov dword [r_rgb], 0x00EDE9FE
    call k_fill_rect
    mov dword [t_px], 195
    mov dword [t_py], 303
    mov esi, sm_t4
    call k_print_xy

    mov dword [r_x], 180
    mov dword [r_y], 335
    mov dword [r_w], 380
    mov dword [r_h], 32
    mov dword [r_rgb], 0x00EDE9FE
    call k_fill_rect
    mov dword [t_px], 195
    mov dword [t_py], 343
    mov esi, sm_t5
    call k_print_xy
    ret

%include "oldog_v2_data.asm"
%include "oldog_v2_update.asm"
