k_print32:
    lodsb
    or al, al
    jz .done
    call k_putchar32
    jmp k_print32
.done:
    ret

k_putchar32:
    cmp al, 10
    je .nl
    cmp al, 8
    je .bs

    pushad
    movzx eax, al
    shl eax, 4
    lea esi, [0x6000 + eax]

    mov eax, [t_row]
    mov ebx, 1280
    mul ebx
    add eax, [t_col]
    lea edi, [0xA0000 + eax]

    mov ecx, 16
.g_row:
    mov bl, [esi]
    push ecx
    mov cl, 1
.p_loop:
    mov dx, 0x03C4
    mov al, 0x02
    mov ah, cl
    out dx, ax

    xor al, al
    test [t_fg], cl
    jz .no_fg
    or al, bl
.no_fg:
    test [t_bg], cl
    jz .no_bg
    mov dl, bl
    not dl
    or al, dl
.no_bg:
    mov [edi], al
    shl cl, 1
    cmp cl, 16
    jl .p_loop

    pop ecx
    inc esi
    add edi, 80
    loop .g_row

    mov dx, 0x03C4
    mov ax, 0x0F02
    out dx, ax
    popad

    inc dword [t_col]
    cmp dword [t_col], 80
    jb .ok_c
.nl:
    mov dword [t_col], 0
    inc dword [t_row]
    cmp dword [t_row], 29
    jb .ok_c
    mov dword [t_row], 0
.ok_c:
    ret

.bs:
    cmp dword [t_col], 0
    je .ok_c
    dec dword [t_col]
    mov al, ' '
    call k_putchar32
    dec dword [t_col]
    ret

k_read_line32:
    xor ecx, ecx
.loop:
    in al, 0x64
    test al, 0x01
    jz .loop
    test al, 0x20
    jnz .disc
    in al, 0x60
    test al, 0x80
    jnz .loop
    cmp al, 0x1C
    je .ent
    cmp al, 0x0E
    je .bks
    cmp al, 58
    jae .loop
    movzx ebx, al
    mov al, [keymap + ebx]
    or al, al
    jz .loop
    cmp ecx, 90
    jae .loop
    stosb
    inc ecx
    mov byte [t_fg], 15
    call k_putchar32
    jmp .loop
.disc:
    in al, 0x60
    jmp .loop
.bks:
    or ecx, ecx
    jz .loop
    dec edi
    dec ecx
    mov al, 8
    call k_putchar32
    jmp .loop
.ent:
    mov byte [edi], 0
    mov al, 10
    call k_putchar32
    ret

k_get_cmos_time:
    mov edi, cmos_str
    mov al, 0x04
    call .read_reg
    mov byte [edi], ':'
    inc edi
    mov al, 0x02
    call .read_reg
    mov byte [edi], ':'
    inc edi
    mov al, 0x00
    call .read_reg
    mov byte [edi], ' '
    inc edi
    mov al, 0x07
    call .read_reg
    mov byte [edi], '/'
    inc edi
    mov al, 0x08
    call .read_reg
    mov byte [edi], '/'
    inc edi
    mov al, 0x09
    call .read_reg
    mov byte [edi], 0
    ret
.read_reg:
    out 0x70, al
    in al, 0x71
    mov ah, al
    shr al, 4
    add al, '0'
    mov [edi], al
    inc edi
    and ah, 0x0F
    add ah, '0'
    mov [edi], ah
    inc edi
    ret

k_sleep_ms:
    push eax
    push ebx
    push ecx
    mov ecx, eax
.ms_l:
    mov al, 0x00
    out 0x43, al
    in al, 0x40
    mov bl, al
    in al, 0x40
    mov bh, al
.w1:
    mov al, 0x00
    out 0x43, al
    in al, 0x40
    mov dl, al
    in al, 0x40
    mov dh, al
    mov ax, bx
    sub ax, dx
    cmp ax, 1193
    jb .w1
    loop .ms_l
    pop ecx
    pop ebx
    pop eax
    ret

k_strcmp:
.l: mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .ne
    or al, al
    jz .eq
    inc esi
    inc edi
    jmp .l
.ne: or eax, 1
    ret
.eq: xor eax, eax
    ret

k_strncmp:
.l: mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .ne
    inc esi
    inc edi
    loop .l
    xor eax, eax
    ret
.ne: or eax, 1
    ret

splash_t1    db 'OldOS v1.0', 0
splash_t2    db 'with Oldog v1.0 32-bit', 0
msg_banner   db 'OldOS 32-bit Protected Mode Shell (VelocityAnOldShell32)', 10
             db 'Type "help" for commands or "entgui" to return to Oldog GUI.', 10, 10, 0
msg_prompt   db 'A:\>veloldsh32> ', 0
msg_bad      db 'Bad command or file name. Type "help".', 10, 0
msg_safe_off db 'It is now safe to turn off your computer.', 0

str_win      db 'win', 0
str_help     db 'help', 0
str_cls      db 'cls', 0
str_ver      db 'ver', 0
str_dir      db 'dir', 0
str_time     db 'time', 0
str_mem      db 'mem', 0
str_beep     db 'beep', 0
str_cpu      db 'cpu', 0
str_reboot   db 'reboot', 0
str_shutdown db 'shutdown', 0
str_echo     db 'echo ', 0
str_color    db 'color ', 0

arg_green    db 'green', 0
arg_amber    db 'amber', 0
arg_cyan     db 'cyan', 0

msg_help     db 'veloldsh32 Commands:', 10
             db '  entgui          - Return to Oldog v1.0 Desktop', 10
             db '  dir          - List system files', 10
             db '  ver          - Kernel & Shell version', 10
             db '  mem          - Detect real hardware RAM', 10
             db '  cpu          - Read CPU Vendor ID', 10
             db '  time         - Read CMOS Real-Time Clock', 10
             db '  beep         - Test PC Speaker sound', 10
             db '  echo [text]  - Print text to screen', 10
             db '  color [name] - Set text color (green, amber, cyan)', 10
             db '  cls          - Clear screen', 10
             db '  reboot       - Restart computer', 10
             db '  shutdown     - Halt CPU safely', 10, 0

msg_ver      db 'OldOS Kernel v1.0 (32-bit Protected Mode) | Oldog v1.0', 10, 0
msg_dir      db ' Volume in drive A is OLDOS32', 10
             db ' BOOT.BIN     512 bytes', 10
             db ' KERNEL.BIN   16,384 bytes (32-bit Protected Mode)', 10, 0

msg_mem_hdr  db '32-bit Protected Mode Hardware Memory Map:', 10, 0
msg_mem_conv db '  Conventional RAM: ', 0
msg_mem_ext  db '  Total System RAM: ', 0
msg_kb       db ' KB', 10, 0
msg_mb       db ' MB', 10, 0

msg_cpu      db 'CPU Vendor: ', 0
msg_time     db 'CMOS Clock: ', 0

ode_notes:
    dw 3619, 250, 3619, 250, 3416, 250, 3043, 250
    dw 3043, 250, 3416, 250, 3619, 250, 4063, 250
    dw 4560, 250, 4560, 250, 4063, 250, 3619, 250
    dw 3619, 400, 4063, 150, 4063, 500, 0, 0

keymap:
    db 0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', 8, 9
    db 'q','w','e','r','t','y','u','i','o','p','[',']', 13, 0
    db 'a','s','d','f','g','h','j','k','l',';', 39, '`', 0, '\'
    db 'z','x','c','v','b','n','m',',','.','/', 0, '*', 0, ' '

r_x         dd 0
r_y         dd 0
r_w         dd 0
r_h         dd 0
r_col       db 0
bar_pos     dd 148
t_row       dd 0
t_col       dd 0
t_fg        db 7
t_bg        db 0
vendor_str  times 16 db 0
cmos_str    times 24 db 0
mem_num_str times 16 db 0
cmd_buf     times 100 db 0