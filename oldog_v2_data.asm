v2_draw_exit_win:
    mov dword [r_x], 240
    mov dword [r_y], 180
    mov dword [r_w], 320
    mov dword [r_h], 190
    mov dword [r_rgb], 0x00F1F5F9
    call k_fill_rect
    mov dword [r_x], 240
    mov dword [r_y], 180
    mov dword [r_w], 320
    mov dword [r_h], 32
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect
    mov dword [r_x], 528
    mov dword [r_y], 185
    mov dword [r_w], 24
    mov dword [r_h], 22
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 254
    mov dword [t_py], 188
    mov esi, v2_etitle
    call k_print_xy
    mov dword [t_px], 536
    mov dword [t_py], 188
    mov esi, v2_btn_x
    call k_print_xy
    mov dword [r_x], 280
    mov dword [r_y], 236
    mov dword [r_w], 240
    mov dword [r_h], 28
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 310
    mov dword [t_py], 242
    mov esi, v2_eb1
    call k_print_xy
    mov dword [r_x], 280
    mov dword [r_y], 274
    mov dword [r_w], 240
    mov dword [r_h], 28
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [t_px], 310
    mov dword [t_py], 280
    mov esi, v2_eb2
    call k_print_xy
    mov dword [r_x], 280
    mov dword [r_y], 312
    mov dword [r_w], 240
    mov dword [r_h], 28
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect
    mov dword [t_px], 310
    mov dword [t_py], 318
    mov esi, v2_eb3
    call k_print_xy
    ret

v2_cmask         db 10000000b, 11000000b, 11100000b, 11110000b, 11111000b, 11111100b, 11111110b, 11111111b, 11111000b, 11011000b, 10001100b, 00001100b, 00000110b, 00000110b
v2_cfill         db 00000000b, 01000000b, 01100000b, 01110000b, 01111000b, 01111100b, 01111110b, 01110000b, 01010000b, 00001000b, 00001000b, 00000100b, 00000100b, 00000000b

v2_btn_start     db 'OldOS', 0
v2_btn_x         db 'X', 0
v2_mascot_lbl    db 'Oldog v2.2 HighColor', 0
v2_i1            db 'Notes', 0
v2_i2            db 'Calc', 0
v2_i3            db 'OldWeb', 0
v2_i4            db 'OldStore', 0
v2_i5            db 'Smusic', 0
v2_i_paint       db 'OldPaint', 0
v2_i_pong        db 'OldPong', 0

v2_m1            db '1. Notepad', 0
v2_m2            db '2. Calculator', 0
v2_m3_web        db '3. OldWeb Browser', 0
v2_m4_store      db '4. OldStore Apps', 0
v2_m5_exit       db '5. Exit...', 0

v2_t_note        db 'Oldog Notepad (OldFS)', 0
v2_btn_save      db 'Save OldFS', 0
v2_btn_load      db 'Load OldFS', 0
v2_t_calc        db 'Oldog Calculator', 0
v2_t_web         db 'OldWeb Browser - oldos://home', 0
v2_t_store       db 'OldStore - App Marketplace', 0
v2_t_smusic      db 'Smusic Dog Old v2.2 - 5 Tracks', 0

v2_nhint         db 'Type text below (Backspace erases):', 0
v2_chint         db 'Press 0-9 to add, - to sub, C to clear:', 0
v2_cres          db 'Result: ', 0

web_tabs         db '[ Home ]      [ About OldOS ]      [ Get Apps ]', 0
wp0_h1           db 'Welcome to OldWeb Browser v1.0!', 0
wp0_p1           db 'Surfing offline on OldOS v3.0 32-bit Kernel.', 0
wp0_link         db '>> Click here to open OldStore & download Smusic! <<', 0
wp1_h1           db 'About OldOS v3.0 & Oldog v2.2', 0
wp1_p1           db 'Pure x86 Assembly OS with OldFS & ACPI PowerOff.', 0
wp2_h1           db 'Featured Software on OldStore:', 0

st_hdr           db 'Available Apps for OldOS v3.0:', 0
st_app_name      db 'Smusic Dog Old v2.2', 0
st_app_desc      db '5-Track Retro PC Speaker Player', 0
st_btn_inst      db 'Install App', 0
st_btn_open      db 'Open Player', 0

sm_hint          db 'Click a track (or press 1..5) to play:', 0
sm_t1            db '1. Ode to Joy (30 Notes Full)', 0
sm_t2            db '2. Imperial March (8-bit)', 0
sm_t3            db '3. Oldog Arcade Theme', 0
sm_t4            db '4. Fur Elise (Beethoven)', 0
sm_t5            db '5. Tetris Theme (Korobeiniki)', 0

v2_etitle        db 'Exit Oldog v2.2', 0
v2_eb1           db '1. Shut Down OldOS', 0
v2_eb2           db '2. Restart Computer', 0
v2_eb3           db '3. Restart in Shell Mode', 0

mx               dd 400
my               dd 300
midx             db 0
mclk             db 0
mpkt             db 0, 0, 0
v2_menu          db 0
v2_app           db 0
web_page         db 0
smusic_installed db 0
note_fs_msg      db 0
v2_nlen          dd 0
v2_nbuf          times 60 db 0
v2_cval          dd 0
