v2_handle_click:
    mov byte [mclk], 0

    cmp byte [v2_app], 3
    je .chk_exit_dlg

    cmp dword [mx], 84
    ja .chk_open_menu
    cmp dword [my], 564
    jb .chk_open_menu
    xor byte [v2_menu], 1
    jmp v2_render_frame

.chk_open_menu:
    cmp byte [v2_menu], 1
    jne .chk_close_win

    mov byte [v2_menu], 0
    cmp dword [mx], 8
    jb .chk_close_win
    cmp dword [mx], 188
    ja .chk_close_win
    cmp dword [my], 378
    jb .chk_close_win
    cmp dword [my], 560
    ja .chk_close_win

    cmp dword [my], 416
    jb .open_note
    cmp dword [my], 450
    jb .open_calc
    cmp dword [my], 484
    jb .open_web
    cmp dword [my], 520
    jb .open_store
    mov byte [v2_app], 3
    jmp v2_render_frame

.chk_close_win:
    cmp byte [v2_app], 0
    je .chk_desktop_icons

    cmp dword [mx], 616
    jb .chk_note_btns
    cmp dword [mx], 644
    ja .chk_note_btns
    cmp dword [my], 96
    jb .chk_note_btns
    cmp dword [my], 120
    ja .chk_note_btns
    mov byte [v2_app], 0
    jmp v2_render_frame

.chk_note_btns:
    cmp byte [v2_app], 1
    jne .chk_inside_window
    cmp dword [my], 134
    jb .chk_desktop_icons
    cmp dword [my], 160
    ja .chk_desktop_icons
    cmp dword [mx], 170
    jb .chk_desktop_icons
    cmp dword [mx], 270
    jbe .do_note_save
    cmp dword [mx], 280
    jb .chk_desktop_icons
    cmp dword [mx], 380
    jbe .do_note_load
    cmp dword [mx], 390
    jb .chk_desktop_icons
    cmp dword [mx], 490
    jbe .do_note_del
    jmp .chk_desktop_icons

.do_note_save:
    call oldfs_save_note
    cmp byte [oldfs_status], 0
    jne .note_fs_err
    mov byte [note_fs_msg], 1
    jmp v2_render_frame
.do_note_load:
    call oldfs_load_note
    cmp byte [oldfs_status], 0
    jne .note_fs_err
    mov byte [note_fs_msg], 2
    jmp v2_render_frame
.do_note_del:
    call oldfs_del_note
    cmp byte [oldfs_status], 0
    jne .note_fs_err
    mov byte [note_fs_msg], 4
    jmp v2_render_frame
.note_fs_err:
    mov byte [note_fs_msg], 3
    jmp v2_render_frame

.chk_inside_window:
    cmp byte [v2_app], 4
    jne .chk_store_clicks

    cmp dword [my], 124
    jb .chk_desktop_icons
    cmp dword [my], 162
    ja .chk_web_page_link

    cmp dword [mx], 150
    jb .chk_desktop_icons
    cmp dword [mx], 280
    jb .set_wp0
    cmp dword [mx], 440
    jb .set_wp1
    cmp dword [mx], 650
    ja .chk_desktop_icons
    mov byte [web_page], 2
    jmp v2_render_frame
.set_wp0:
    mov byte [web_page], 0
    jmp v2_render_frame
.set_wp1:
    mov byte [web_page], 1
    jmp v2_render_frame

.chk_web_page_link:
    cmp dword [mx], 165
    jb .chk_desktop_icons
    cmp dword [mx], 600
    ja .chk_desktop_icons
    cmp dword [my], 310
    jb .chk_desktop_icons
    cmp dword [my], 345
    ja .chk_desktop_icons
    mov byte [v2_app], 5
    jmp v2_render_frame

.chk_store_clicks:
    cmp byte [v2_app], 5
    jne .chk_smusic_clicks

    cmp dword [mx], 465
    jb .chk_desktop_icons
    cmp dword [mx], 605
    ja .chk_desktop_icons
    cmp dword [my], 212
    jb .chk_desktop_icons
    cmp dword [my], 250
    ja .chk_desktop_icons

    cmp byte [smusic_installed], 1
    je .open_smusic
    mov byte [smusic_installed], 1
    mov ax, 1000
    mov edx, 120
    call k_tone_ms
    jmp v2_render_frame

.chk_smusic_clicks:
    cmp byte [v2_app], 6
    jne .chk_updater_clicks

    cmp dword [mx], 180
    jb .chk_desktop_icons
    cmp dword [mx], 560
    ja .chk_desktop_icons

    cmp dword [my], 175
    jb .chk_desktop_icons
    cmp dword [my], 207
    jbe v2_play_s1
    cmp dword [my], 215
    jb .chk_desktop_icons
    cmp dword [my], 247
    jbe v2_play_s2
    cmp dword [my], 255
    jb .chk_desktop_icons
    cmp dword [my], 287
    jbe v2_play_s3
    cmp dword [my], 295
    jb .chk_desktop_icons
    cmp dword [my], 327
    jbe v2_play_s4
    cmp dword [my], 335
    jb .chk_desktop_icons
    cmp dword [my], 367
    jbe v2_play_s5
.chk_updater_clicks:
    cmp byte [v2_app], 7
    jne .chk_paint_clicks

    cmp dword [mx], 240
    jb .chk_desktop_icons
    cmp dword [mx], 560
    ja .chk_desktop_icons
    cmp dword [my], 270
    jb .chk_desktop_icons
    cmp dword [my], 316
    ja .chk_desktop_icons
    jmp v2_run_updater_countdown

.chk_paint_clicks:
    cmp byte [v2_app], 8
    jne .chk_fe_clicks

    cmp dword [my], 134
    jb .chk_paint_canvas
    cmp dword [my], 160
    ja .chk_paint_canvas

    cmp dword [mx], 166
    jb .chk_desktop_icons
    cmp dword [mx], 194
    jbe .pt_c0
    cmp dword [mx], 228
    jbe .pt_c1
    cmp dword [mx], 262
    jbe .pt_c2
    cmp dword [mx], 296
    jbe .pt_c3
    cmp dword [mx], 330
    jbe .pt_c4

    cmp dword [mx], 344
    jb .chk_desktop_icons
    cmp dword [mx], 404
    jbe .pt_save
    cmp dword [mx], 412
    jb .chk_desktop_icons
    cmp dword [mx], 472
    jbe .pt_load
    cmp dword [mx], 480
    jb .chk_desktop_icons
    cmp dword [mx], 540
    jbe .pt_del
    cmp dword [mx], 548
    jb .chk_desktop_icons
    cmp dword [mx], 620
    ja .chk_desktop_icons
    call v2_init_paint
    jmp v2_render_frame

.pt_save:
    call oldfs_save_paint
    cmp byte [oldfs_status], 0
    jne .pt_err
    mov byte [pt_fs_msg], 1
    jmp v2_render_frame
.pt_load:
    call oldfs_load_paint
    cmp byte [oldfs_status], 0
    jne .pt_err
    mov byte [pt_fs_msg], 2
    jmp v2_render_frame
.pt_del:
    call oldfs_del_paint
    cmp byte [oldfs_status], 0
    jne .pt_err
    mov byte [pt_fs_msg], 3
    jmp v2_render_frame
.pt_err:
    mov byte [pt_fs_msg], 4
    jmp v2_render_frame

.pt_c0: mov dword [pt_color], 0x000F172A
        jmp v2_render_frame
.pt_c1: mov dword [pt_color], 0x002563EB
        jmp v2_render_frame
.pt_c2: mov dword [pt_color], 0x00DC2626
        jmp v2_render_frame
.pt_c3: mov dword [pt_color], 0x0016A34A
        jmp v2_render_frame
.pt_c4: mov dword [pt_color], 0x00FACC15
        jmp v2_render_frame

.chk_paint_canvas:
    call v2_paint_brush
    jmp v2_render_frame

.chk_fe_clicks:
    cmp byte [v2_app], 10
    jne .chk_desktop_icons

    cmp dword [my], 128
    jb .chk_desktop_icons
    cmp dword [my], 152
    ja .chk_fe_rows
    cmp dword [mx], 545
    jb .chk_desktop_icons
    cmp dword [mx], 635
    ja .chk_desktop_icons
    call v2_scan_oldfs_files
    jmp v2_render_frame

.chk_fe_rows:
    cmp byte [fe_has_note], 1
    jne .chk_fe_r2
    cmp dword [my], 188
    jb .chk_fe_r2
    cmp dword [my], 216
    ja .chk_fe_r2
    cmp dword [mx], 460
    jb .chk_fe_r2
    cmp dword [mx], 535
    jbe .fe_open_note
    cmp dword [mx], 545
    jb .chk_fe_r2
    cmp dword [mx], 615
    jbe .fe_del_note

.chk_fe_r2:
    cmp byte [fe_has_paint], 1
    jne .chk_desktop_icons
    cmp dword [my], 248
    jb .chk_desktop_icons
    cmp dword [my], 276
    ja .chk_desktop_icons
    cmp dword [mx], 460
    jb .chk_desktop_icons
    cmp dword [mx], 535
    jbe .fe_open_paint
    cmp dword [mx], 545
    jb .chk_desktop_icons
    cmp dword [mx], 615
    jbe .fe_del_paint
    jmp .chk_desktop_icons

.fe_open_note:
    call oldfs_load_note
    mov byte [note_fs_msg], 2
    mov byte [v2_app], 1
    jmp v2_render_frame
.fe_del_note:
    call oldfs_del_note
    call v2_scan_oldfs_files
    jmp v2_render_frame
.fe_open_paint:
    call oldfs_load_paint
    mov byte [pt_fs_msg], 2
    mov byte [v2_app], 8
    jmp v2_render_frame
.fe_del_paint:
    call oldfs_del_paint
    call v2_scan_oldfs_files
    jmp v2_render_frame

.chk_desktop_icons:
    cmp dword [mx], 96
    jb .col1_icons
    cmp dword [mx], 152
    ja v2_render_frame
    cmp dword [my], 24
    jb v2_render_frame
    cmp dword [my], 94
    jb .open_upd
    cmp dword [my], 104
    jb v2_render_frame
    cmp dword [my], 174
    jb .open_paint
    cmp dword [my], 184
    jb v2_render_frame
    cmp dword [my], 254
    jb .open_pong
    cmp dword [my], 264
    jb v2_render_frame
    cmp dword [my], 334
    ja v2_render_frame
    call v2_scan_oldfs_files
    mov byte [v2_app], 10
    jmp v2_render_frame

.open_upd:
    mov byte [v2_app], 7
    jmp v2_render_frame
.open_paint:
    mov byte [v2_app], 8
    jmp v2_render_frame
.open_pong:
    call v2_init_pong
    mov byte [v2_app], 9
    jmp v2_render_frame

.col1_icons:
    cmp dword [mx], 20
    jb v2_render_frame
    cmp dword [mx], 88
    ja v2_render_frame

    cmp dword [my], 24
    jb v2_render_frame
    cmp dword [my], 94
    jb .open_note
    cmp dword [my], 104
    jb v2_render_frame
    cmp dword [my], 174
    jb .open_calc
    cmp dword [my], 184
    jb v2_render_frame
    cmp dword [my], 254
    jb .open_web
    cmp dword [my], 264
    jb v2_render_frame
    cmp dword [my], 334
    jb .open_store
    cmp dword [my], 344
    jb v2_render_frame
    cmp dword [my], 414
    ja v2_render_frame
    cmp byte [smusic_installed], 1
    je .open_smusic
    jmp v2_render_frame

.open_note:
    mov byte [v2_app], 1
    jmp v2_render_frame
.open_calc:
    mov byte [v2_app], 2
    jmp v2_render_frame
.open_web:
    mov byte [v2_app], 4
    jmp v2_render_frame
.open_store:
    mov byte [v2_app], 5
    jmp v2_render_frame
.open_smusic:
    mov byte [v2_app], 6
    jmp v2_render_frame

.chk_exit_dlg:
    cmp dword [mx], 528
    jb .chk_exit_buttons
    cmp dword [mx], 552
    ja .chk_exit_buttons
    cmp dword [my], 185
    jb .chk_exit_buttons
    cmp dword [my], 207
    ja .chk_exit_buttons
    mov byte [v2_app], 0
    jmp v2_render_frame

.chk_exit_buttons:
    cmp dword [mx], 280
    jb v2_render_frame
    cmp dword [mx], 520
    ja v2_render_frame
    cmp dword [my], 236
    jb v2_render_frame
    cmp dword [my], 264
    jb k_real_poweroff
    cmp dword [my], 274
    jb v2_render_frame
    cmp dword [my], 302
    jb cmd_reboot
    cmp dword [my], 312
    jb v2_render_frame
    cmp dword [my], 340
    jb start_shell32
    jmp v2_render_frame

v2_play_s1:
    mov esi, ode_30_notes
    call k_play_melody_ptr
    jmp v2_render_frame
v2_play_s2:
    mov esi, song_imperial
    call k_play_melody_ptr
    jmp v2_render_frame
v2_play_s3:
    mov esi, song_arcade
    call k_play_melody_ptr
    jmp v2_render_frame
v2_play_s4:
    mov esi, song_elise
    call k_play_melody_ptr
    jmp v2_render_frame
v2_play_s5:
    mov esi, song_tetris
    call k_play_melody_ptr
    jmp v2_render_frame
