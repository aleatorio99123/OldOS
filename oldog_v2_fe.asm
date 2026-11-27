v2_scan_oldfs_files:
    pushad
    mov byte [fe_has_note], 0
    mov byte [fe_has_paint], 0

    call oldfs_probe_storage
    cmp byte [oldfs_target], 0
    je .done_scan

    mov dword [fs_lba], 100
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 0
    call oldfs_rw_sectors
    cmp byte [oldfs_status], 0
    jne .chk_p
    cmp dword [0x00008000], 'OLDF'
    jne .chk_p
    mov byte [fe_has_note], 1

.chk_p:
    mov dword [fs_lba], 199
    mov word [fs_cnt], 1
    mov byte [fs_is_write], 0
    call oldfs_rw_sectors
    cmp byte [oldfs_status], 0
    jne .done_scan
    cmp dword [0x00008000], 'OLDP'
    jne .done_scan
    mov byte [fe_has_paint], 1

.done_scan:
    popad
    ret

v2_draw_fe_win:
    mov dword [t_px], 166
    mov dword [t_py], 99
    mov esi, v2_t_fe
    call k_print_xy

    mov dword [r_x], 150
    mov dword [r_y], 124
    mov dword [r_w], 500
    mov dword [r_h], 34
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 168
    mov dword [t_py], 133
    mov esi, fe_drv_lbl
    call k_print_xy

    mov dword [t_px], 245
    cmp byte [oldfs_target], 1
    je .fe_hdd
    cmp byte [oldfs_target], 2
    je .fe_usb
    mov dword [t_fg_rgb], 0x00DC2626
    mov esi, fe_drv_none
    call k_print_xy
    jmp .fe_btn_ref
.fe_hdd:
    mov dword [t_fg_rgb], 0x0016A34A
    mov esi, fe_drv_hdd
    call k_print_xy
    jmp .fe_btn_ref
.fe_usb:
    mov dword [t_fg_rgb], 0x002563EB
    mov esi, fe_drv_usb
    call k_print_xy

.fe_btn_ref:
    mov dword [r_x], 545
    mov dword [r_y], 128
    mov dword [r_w], 90
    mov dword [r_h], 24
    mov dword [r_rgb], 0x001D4ED8
    call k_fill_rect
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 562
    mov dword [t_py], 133
    mov esi, fe_btn_ref
    call k_print_xy

    mov al, [fe_has_note]
    or al, [fe_has_paint]
    jnz .draw_files

    mov dword [t_fg_rgb], 0x0064748B
    mov dword [t_px], 225
    mov dword [t_py], 260
    mov esi, fe_empty_msg
    call k_print_xy
    ret

.draw_files:
    cmp byte [fe_has_note], 1
    jne .draw_r2

    mov dword [r_x], 170
    mov dword [r_y], 184
    mov dword [r_w], 460
    mov dword [r_h], 36
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 185
    mov dword [t_py], 194
    mov esi, fe_f_note
    call k_print_xy

    mov dword [r_x], 460
    mov dword [r_y], 188
    mov dword [r_w], 75
    mov dword [r_h], 28
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 480
    mov dword [t_py], 194
    mov esi, fe_btn_open
    call k_print_xy

    mov dword [r_x], 545
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov dword [t_px], 566
    mov esi, pt_b_del
    call k_print_xy

.draw_r2:
    cmp byte [fe_has_paint], 1
    jne .done_fe

    mov dword [r_x], 170
    mov dword [r_y], 244
    mov dword [r_w], 460
    mov dword [r_h], 36
    mov dword [r_rgb], 0x00E2E8F0
    call k_fill_rect

    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 185
    mov dword [t_py], 254
    mov esi, fe_f_paint
    call k_print_xy

    mov dword [r_x], 460
    mov dword [r_y], 248
    mov dword [r_w], 75
    mov dword [r_h], 28
    mov dword [r_rgb], 0x0016A34A
    call k_fill_rect
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 480
    mov dword [t_py], 254
    mov esi, fe_btn_open
    call k_print_xy

    mov dword [r_x], 545
    mov dword [r_rgb], 0x00DC2626
    call k_fill_rect
    mov dword [t_px], 566
    mov esi, pt_b_del
    call k_print_xy

.done_fe:
    ret

v2_i_fe      db 'OldFE', 0
v2_t_fe      db 'OldFE - Old File Explorer', 0
fe_drv_lbl   db 'Storage:', 0
fe_drv_hdd   db 'HDD / SSD (ATA)', 0
fe_drv_usb   db 'USB Pen Drive (Phisical)', 0
fe_drv_none  db 'No Drive Found', 0
fe_btn_ref   db 'Refresh', 0
fe_btn_open  db 'Open', 0
fe_empty_msg db 'No saved files found in OldFS.', 0
fe_f_note    db 'note.txt      (512 B - Notepad)', 0
fe_f_paint   db 'drawing.art   (220 KB - OldPaint)', 0
fe_has_note  db 0
fe_has_paint db 0