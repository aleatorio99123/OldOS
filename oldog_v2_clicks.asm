v2_handle_click:
    mov byte [mclk], 0

    cmp byte [v2_app], 3
    je .chk_exit_dlg

    ; Botao [OldOS] (X: 8..84, Y: 564..600)
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
    cmp dword [my], 344
    jb .chk_close_win
    cmp dword [my], 560
    ja .chk_close_win

    cmp dword [my], 382
    jb .open_note
    cmp dword [my], 416
    jb .open_calc
    cmp dword [my], 450
    jb .open_web
    cmp dword [my], 484
    jb .open_store
    cmp dword [my], 520
    jb .open_updater
    mov byte [v2_app], 3
    jmp v2_render_frame

.chk_close_win:
    cmp byte [v2_app], 0
    je .chk_desktop_icons

    cmp dword [mx], 616
    jb .chk_inside_window
    cmp dword [mx], 644
    ja .chk_inside_window
    cmp dword [my], 96
    jb .chk_inside_window
    cmp dword [my], 120
    ja .chk_inside_window
    mov byte [v2_app], 0
    jmp v2_render_frame

.chk_inside_window:
    ; OldWeb Browser (v2_app = 4)
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
    ; OldStore (v2_app = 5)
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
    ; Smusic Dog Old (v2_app = 6)
    cmp byte [v2_app], 6
    jne .chk_updater_clicks

    cmp dword [mx], 180
    jb .chk_desktop_icons
    cmp dword [mx], 560
    ja .chk_desktop_icons

    cmp dword [my], 210
    jb .chk_desktop_icons
    cmp dword [my], 248
    jbe v2_play_s1

    cmp dword [my], 255
    jb .chk_desktop_icons
    cmp dword [my], 293
    jbe v2_play_s2

    cmp dword [my], 300
    jb .chk_desktop_icons
    cmp dword [my], 338
    jbe v2_play_s3

.chk_updater_clicks:
    ; OldOS System Updater (v2_app = 7)
    cmp byte [v2_app], 7
    jne .chk_desktop_icons

    cmp dword [mx], 240
    jb .chk_desktop_icons
    cmp dword [mx], 560
    ja .chk_desktop_icons
    cmp dword [my], 270
    jb .chk_desktop_icons
    cmp dword [my], 316
    ja .chk_desktop_icons
    jmp v2_run_updater_countdown

.chk_desktop_icons:
    cmp dword [mx], 96
    jb .col1_icons
    cmp dword [mx], 152
    ja v2_render_frame
    cmp dword [my], 24
    jb v2_render_frame
    cmp dword [my], 94
    ja v2_render_frame
    mov byte [v2_app], 7
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
.open_updater:
    mov byte [v2_app], 7
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
    jb cmd_shutdown
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
    mov byte [sm_track], 1
    mov esi, ode_30_notes
    call k_play_melody_ptr
    jmp v2_render_frame

v2_play_s2:
    mov byte [sm_track], 2
    mov esi, song_imperial
    call k_play_melody_ptr
    jmp v2_render_frame

v2_play_s3:
    mov byte [sm_track], 3
    mov esi, song_arcade
    call k_play_melody_ptr
    jmp v2_render_frame