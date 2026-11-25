gui32_draw_mascot:
    mov dword [r_x], 328
    mov dword [r_y], 172
    mov dword [r_w], 96
    mov dword [r_h], 76
    mov byte [r_col], 8
    call k_draw_rect32

    mov dword [r_x], 320
    mov dword [r_y], 168
    mov dword [r_w], 96
    mov dword [r_h], 76
    mov byte [r_col], 7
    call k_draw_rect32

    mov dword [r_x], 332
    mov dword [r_y], 178
    mov dword [r_w], 72
    mov dword [r_h], 52
    mov byte [r_col], 0
    call k_draw_rect32

    mov dword [r_x], 340
    mov dword [r_y], 188
    mov dword [r_w], 24
    mov dword [r_h], 4
    mov byte [r_col], 10
    call k_draw_rect32

    mov dword [r_x], 340
    mov dword [r_y], 196
    mov dword [r_w], 40
    mov dword [r_h], 4
    mov byte [r_col], 10
    call k_draw_rect32

    mov dword [r_x], 396
    mov dword [r_y], 234
    mov dword [r_w], 8
    mov dword [r_h], 4
    mov byte [r_col], 10
    call k_draw_rect32

    mov dword [r_x], 352
    mov dword [r_y], 244
    mov dword [r_w], 32
    mov dword [r_h], 10
    mov byte [r_col], 8
    call k_draw_rect32

    mov dword [r_x], 336
    mov dword [r_y], 254
    mov dword [r_w], 64
    mov dword [r_h], 8
    mov byte [r_col], 7
    call k_draw_rect32

    mov dword [r_x], 272
    mov dword [r_y], 236
    mov dword [r_w], 48
    mov dword [r_h], 4
    mov byte [r_col], 0
    call k_draw_rect32

    mov dword [r_x], 264
    mov dword [r_y], 224
    mov dword [r_w], 16
    mov dword [r_h], 14
    mov byte [r_col], 0
    call k_draw_rect32

    mov dword [r_x], 264
    mov dword [r_y], 216
    mov dword [r_w], 8
    mov dword [r_h], 6
    mov byte [r_col], 14
    call k_draw_rect32

    mov dword [r_x], 272
    mov dword [r_y], 238
    mov dword [r_w], 8
    mov dword [r_h], 6
    mov byte [r_col], 14
    call k_draw_rect32

    mov dword [r_x], 184
    mov dword [r_y], 216
    mov dword [r_w], 16
    mov dword [r_h], 8
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 196
    mov dword [r_y], 224
    mov dword [r_w], 56
    mov dword [r_h], 26
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 200
    mov dword [r_y], 250
    mov dword [r_w], 12
    mov dword [r_h], 12
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 236
    mov dword [r_y], 250
    mov dword [r_w], 12
    mov dword [r_h], 12
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 232
    mov dword [r_y], 196
    mov dword [r_w], 36
    mov dword [r_h], 30
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 228
    mov dword [r_y], 200
    mov dword [r_w], 12
    mov dword [r_h], 20
    mov byte [r_col], 0
    call k_draw_rect32

    mov dword [r_x], 260
    mov dword [r_y], 208
    mov dword [r_w], 16
    mov dword [r_h], 14
    mov byte [r_col], 6
    call k_draw_rect32

    mov dword [r_x], 272
    mov dword [r_y], 208
    mov dword [r_w], 8
    mov dword [r_h], 6
    mov byte [r_col], 0
    call k_draw_rect32

    mov dword [r_x], 264
    mov dword [r_y], 220
    mov dword [r_w], 8
    mov dword [r_h], 4
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [r_x], 252
    mov dword [r_y], 202
    mov dword [r_w], 8
    mov dword [r_h], 8
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [r_x], 236
    mov dword [r_y], 224
    mov dword [r_w], 24
    mov dword [r_h], 4
    mov byte [r_col], 4
    call k_draw_rect32

    mov dword [t_row], 17
    mov dword [t_col], 34
    mov byte [t_fg], 15
    mov byte [t_bg], 3
    mov esi, g_mascot_lbl
    call k_print32
    ret

gui32_draw_icons:
    mov dword [r_x], 24
    mov dword [r_y], 24
    mov dword [r_w], 32
    mov dword [r_h], 26
    mov byte [r_col], 14
    call k_draw_rect32
    mov dword [t_row], 3
    mov dword [t_col], 2
    mov byte [t_bg], 3
    mov byte [t_fg], 15
    mov esi, g_ico2
    call k_print32

    mov dword [r_x], 24
    mov dword [r_y], 88
    mov dword [r_w], 32
    mov dword [r_h], 26
    mov byte [r_col], 2
    call k_draw_rect32
    mov dword [t_row], 7
    mov dword [t_col], 2
    mov esi, g_ico3
    call k_print32
    
    mov dword [r_x], 24
    mov dword [r_y], 152
    mov dword [r_w], 32
    mov dword [r_h], 26
    mov byte [r_col], 4
    call k_draw_rect32
    mov dword [t_row], 11
    mov dword [t_col], 2
    mov esi, g_ico_game
    call k_print32
    ret

gui32_draw_window:
    mov dword [r_x], 110
    mov dword [r_y], 50
    mov dword [r_w], 460
    mov dword [r_h], 340
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [r_x], 112
    mov dword [r_y], 52
    mov dword [r_w], 456
    mov dword [r_h], 336
    mov byte [r_col], 7
    call k_draw_rect32

    mov dword [r_x], 116
    mov dword [r_y], 56
    mov dword [r_w], 448
    mov dword [r_h], 22
    mov byte [r_col], 1
    call k_draw_rect32

    mov dword [r_x], 540
    mov dword [r_y], 58
    mov dword [r_w], 20
    mov dword [r_h], 18
    mov byte [r_col], 4
    call k_draw_rect32

    mov dword [t_row], 3
    mov dword [t_col], 68
    mov byte [t_fg], 15
    mov byte [t_bg], 4
    mov esi, g_btn_x
    call k_print32

    mov dword [r_x], 122
    mov dword [r_y], 86
    mov dword [r_w], 436
    mov dword [r_h], 292
    mov byte [r_col], 15
    call k_draw_rect32

    cmp byte [g_app], 4
    je gui32_draw_game
    cmp byte [g_app], 2
    je .w_calc

    mov dword [t_row], 3
    mov dword [t_col], 16
    mov byte [t_fg], 15
    mov byte [t_bg], 1
    mov esi, g_t_not
    call k_print32

    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov dword [t_row], 6
    mov dword [t_col], 17
    mov esi, g_nhint
    call k_print32
    mov dword [t_row], 9
    mov dword [t_col], 17
    mov esi, g_nbuf
    call k_print32
    ret

.w_calc:
    mov dword [t_row], 3
    mov dword [t_col], 16
    mov byte [t_fg], 15
    mov byte [t_bg], 1
    mov esi, g_t_clc
    call k_print32

    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov dword [t_row], 7
    mov dword [t_col], 17
    mov esi, g_chint
    call k_print32
    mov dword [t_row], 10
    mov dword [t_col], 17
    mov esi, g_cres
    call k_print32

    mov eax, [g_cval]
    mov edi, g_cstr
    call k_int_to_str32
    mov dword [t_row], 10
    mov dword [t_col], 26
    mov esi, g_cstr
    call k_print32
    ret

gui32_draw_menu:
    mov dword [r_x], 8
    mov dword [r_y], 350
    mov dword [r_w], 140
    mov dword [r_h], 104
    mov byte [r_col], 7
    call k_draw_rect32

    mov byte [t_fg], 0
    mov byte [t_bg], 7
    mov dword [t_row], 22
    mov dword [t_col], 2
    mov esi, g_m1
    call k_print32
    mov dword [t_row], 24
    mov dword [t_col], 2
    mov esi, g_m2
    call k_print32
    mov dword [t_row], 26
    mov dword [t_col], 2
    mov esi, g_m3_exit
    call k_print32
    ret

gui32_draw_exit_dialog:
    mov dword [r_x], 158
    mov dword [r_y], 138
    mov dword [r_w], 324
    mov dword [r_h], 180
    mov byte [r_col], 15
    call k_draw_rect32

    mov dword [r_x], 160
    mov dword [r_y], 140
    mov dword [r_w], 320
    mov dword [r_h], 176
    mov byte [r_col], 7
    call k_draw_rect32

    mov dword [r_x], 164
    mov dword [r_y], 144
    mov dword [r_w], 312
    mov dword [r_h], 22
    mov byte [r_col], 1
    call k_draw_rect32

    mov dword [r_x], 452
    mov dword [r_y], 146
    mov dword [r_w], 20
    mov dword [r_h], 18
    mov byte [r_col], 4
    call k_draw_rect32

    mov dword [t_row], 9
    mov dword [t_col], 22
    mov byte [t_fg], 15
    mov byte [t_bg], 1
    mov esi, g_exit_title
    call k_print32

    mov dword [t_row], 9
    mov dword [t_col], 57
    mov byte [t_bg], 4
    mov esi, g_btn_x
    call k_print32

    mov dword [r_x], 200
    mov dword [r_y], 192
    mov dword [r_w], 240
    mov dword [r_h], 26
    mov byte [r_col], 15
    call k_draw_rect32
    mov dword [t_row], 12
    mov dword [t_col], 28
    mov byte [t_fg], 0
    mov byte [t_bg], 15
    mov esi, g_ebtn1
    call k_print32

    mov dword [r_x], 200
    mov dword [r_y], 226
    mov dword [r_w], 240
    mov dword [r_h], 26
    mov byte [r_col], 15
    call k_draw_rect32
    mov dword [t_row], 14
    mov dword [t_col], 28
    mov esi, g_ebtn2
    call k_print32

    mov dword [r_x], 200
    mov dword [r_y], 260
    mov dword [r_w], 240
    mov dword [r_h], 26
    mov byte [r_col], 15
    call k_draw_rect32
    mov dword [t_row], 16
    mov dword [t_col], 28
    mov esi, g_ebtn3
    call k_print32
    ret

%include "gui32_drivers.asm"