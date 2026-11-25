k_tone_ms:
    push eax
    push edx
    mov bx, ax
    mov al, 0xB6
    out 0x43, al
    mov ax, bx
    out 0x42, al
    mov al, ah
    out 0x42, al
    in al, 0x61
    or al, 0x03
    out 0x61, al
    pop eax
    call k_sleep_ms
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    pop eax
    ret

k_play_melody_ptr:
.pl:
    lodsw
    or ax, ax
    jz .dn
    mov dx, ax
    lodsw
    movzx eax, ax
    push esi
    push eax
    mov ax, dx
    pop edx
    call k_tone_ms
    mov eax, 35
    call k_sleep_ms
    pop esi
    jmp .pl
.dn:
    ret

k_read_line_tc:
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
    cmp ecx, 85
    jae .loop
    stosb
    inc ecx
    mov dword [t_fg_rgb], 0x00FFFFFF
    call k_putchar_xy
    add dword [t_px], 8
    call k_flip_screen
    jmp .loop
.disc:
    in al, 0x60
    jmp .loop
.bks:
    or ecx, ecx
    jz .loop
    dec edi
    dec ecx
    sub dword [t_px], 8
    mov al, ' '
    call k_putchar_xy
    call k_flip_screen
    jmp .loop
.ent:
    mov byte [edi], 0
    mov dword [t_px], 16
    add dword [t_py], 18
    cmp dword [t_py], 560
    jb .ok_y
    call k_shell_cls
.ok_y:
    call k_flip_screen
    ret

k_get_cmos_str:
    push eax
    push edi
.wait_rtc:
    mov al, 0x0A
    out 0x70, al
    in al, 0x71
    test al, 0x80
    jnz .wait_rtc

    mov edi, cmos_buf
    mov al, 0x04            ; Horas
    call .r
    mov byte [edi], ':'
    inc edi
    mov al, 0x02            ; Minutos
    call .r
    mov byte [edi], ':'
    inc edi
    mov al, 0x00            ; Segundos
    call .r
    mov byte [edi], ' '
    inc edi
    mov al, 0x07            ; Dia
    call .r
    mov byte [edi], '/'
    inc edi
    mov al, 0x08            ; Mes
    call .r
    mov byte [edi], '/'
    inc edi
    mov al, 0x09            ; Ano
    call .r
    mov byte [edi], 0
    pop edi
    pop eax
    ret
.r:
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

k_int_to_str:
    xor ecx, ecx
    mov ebx, 10
.dl: xor edx, edx
    div ebx
    push edx
    inc ecx
    or eax, eax
    jnz .dl
.sl: pop eax
    add al, '0'
    mov [edi], al
    inc edi
    loop .sl
    mov byte [edi], 0
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

msg_banner   db 'OldOS v2.1 HighColor Kernel | VelocityAnOldShell (veloldsh)', 10
             db 'Type "oldog" to launch GUI or "help" for original commands.', 10, 10, 0
msg_prompt   db 'oldos@veloldsh:~$ ', 0
msg_bad      db 'Unknown command. Type "help".', 10, 0
msg_safe_off db 'It is now safe to turn off your computer.', 0
msg_help     db 'Original veloldsh Commands:', 10
             db '  oldog        - Launch Oldog v2.1 Desktop Environment', 10
             db '  sysinfo      - Full hardware & display summary', 10
             db '  play [1-3]   - Play PC Speaker tracks (1=Ode, 2=March, 3=Arcade)', 10
             db '  dog          - Print Oldog ASCII mascot', 10
             db '  beep         - Test motherboard speaker', 10
             db '  mem / cpu / time / echo [txt] / cls / reboot / shutdown', 10, 0
msg_ver      db 'OldOS v2.1 (32-bit Protected Mode) | Desktop: Oldog v2.1', 10, 0
msg_res      db 'Display: 800x600x16 HighColor VESA LFB', 10, 0
msg_mem_conv db 'Conventional RAM: ', 0
msg_mem_ext  db 'Total System RAM: ', 0
msg_kb       db ' KB', 10, 0
msg_mb       db ' MB', 10, 0
msg_dog_art  db '  / \__', 10
             db ' (    @\___   Oldog v2.1 - Chewing CRT cables since 1900!', 10
             db ' /         O', 10
             db '/   (_____/', 10, 0

str_oldog    db 'oldog', 0
str_gui      db 'gui', 0
str_help     db 'help', 0
str_cls      db 'cls', 0
str_ver      db 'ver', 0
str_sysinfo  db 'sysinfo', 0
str_dog      db 'dog', 0
str_beep     db 'beep', 0
str_mem      db 'mem', 0
str_time     db 'time', 0
str_cpu      db 'cpu', 0
str_reboot   db 'reboot', 0
str_shutdown db 'shutdown', 0
str_echo     db 'echo ', 0
str_play     db 'play ', 0

song_imperial:
    dw 2711, 350, 2711, 350, 2711, 350, 3416, 260, 2280, 110
    dw 2711, 350, 3416, 260, 2280, 110, 2711, 600, 0, 0
song_arcade:
    dw 1805, 110, 1517, 110, 1207, 110, 902, 220, 1207, 110, 902, 400, 0, 0

keymap:
    db 0, 27, '1','2','3','4','5','6','7','8','9','0','-','=', 8, 9
    db 'q','w','e','r','t','y','u','i','o','p','[',']', 13, 0
    db 'a','s','d','f','g','h','j','k','l',';', 39, '`', 0, '\'
    db 'z','x','c','v','b','n','m',',','.','/', 0, '*', 0, ' '

cpu_buf      times 16 db 0
cmos_buf     times 24 db 0
num_tmp      times 16 db 0
cmd_buf      times 100 db 0