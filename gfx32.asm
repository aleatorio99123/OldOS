; ==========================================================
;   MOTOR GRAFICO VESA 800x600x16 (RGB565 + DOUBLE BUFFER)
; ==========================================================
; Backbuffer em 0x00200000 (960 KB), LFB real em [0x0510], Pitch em [0x050C]

k_flip_screen:
    pushad
    mov esi, 0x00200000
    mov edi, [0x0510]
    mov ebx, [0x050C]       ; Pitch real em bytes por linha
    or ebx, ebx
    jnz .ok_p
    mov ebx, 1600
.ok_p:
    mov edx, 600
.yl:
    push esi
    push edi
    mov ecx, 400            ; 800 pixels * 2 bytes = 1600 bytes = 400 dwords
    rep movsd
    pop edi
    pop esi
    add esi, 1600
    add edi, ebx
    dec edx
    jnz .yl
    popad
    ret

; Converte cor 24-bit [r_rgb] (0x00RRGGBB) para 16-bit RGB565 em AX
k_rgb_to_565:
    mov eax, [r_rgb]
    mov edx, eax
    shr edx, 8
    and dx, 0xF800          ; Vermelho (5 bits)
    mov ecx, eax
    shr ecx, 5
    and cx, 0x07E0          ; Verde (6 bits)
    or dx, cx
    shr eax, 3
    and ax, 0x001F          ; Azul (5 bits)
    or ax, dx
    ret

; Desenha retangulo colorido no Backbuffer
k_fill_rect:
    pushad
    call k_rgb_to_565
    mov bx, ax              ; BX = Cor RGB565

    mov eax, [r_y]
    mov edx, 1600
    mul edx
    mov edx, [r_x]
    shl edx, 1              ; X * 2 bytes
    add eax, edx
    lea edi, [0x00200000 + eax]

    mov ax, bx
    mov edx, [r_h]
.yl:
    push edi
    mov ecx, [r_w]
    rep stosw
    pop edi
    add edi, 1600
    dec edx
    jnz .yl
    popad
    ret

; Papel de parede moderno com degrade suave Azul-Marinho -> Ciano
k_draw_wallpaper:
    pushad
    mov edi, 0x00200000
    xor ebx, ebx
.yl:
    ; G = 12 + Y/16 (0..49), B = 14 + Y/35 (14..31)
    mov eax, ebx
    shr eax, 4
    add eax, 8
    shl eax, 5              ; Verde (bits 5..10)
    mov edx, ebx
    shr edx, 5
    add edx, 12             ; Azul (bits 0..4)
    or ax, dx
    or ax, 0x1000           ; Toque suave de Vermelho (bit 12)

    mov ecx, 800
    rep stosw
    inc ebx
    cmp ebx, 600
    jl .yl
    popad
    ret

k_print_xy:
    lodsb
    or al, al
    jz .done
    cmp al, 10
    je .nl
    cmp al, 8
    je .bs
    call k_putchar_xy
    add dword [t_px], 8
    jmp k_print_xy
.nl:
    mov dword [t_px], 16
    add dword [t_py], 18
    jmp k_print_xy
.bs:
    cmp dword [t_px], 16
    jle k_print_xy
    sub dword [t_px], 8
    mov al, ' '
    call k_putchar_xy
    jmp k_print_xy
.done:
    ret

k_putchar_xy:
    pushad
    movzx eax, al
    shl eax, 4
    lea esi, [0x6000 + eax]

    mov eax, [t_fg_rgb]
    mov [r_rgb], eax
    call k_rgb_to_565
    mov [fg_565], ax

    mov eax, [t_bg_rgb]
    mov [r_rgb], eax
    call k_rgb_to_565
    mov [bg_565], ax

    mov eax, [t_py]
    mov ebx, 1600
    mul ebx
    mov ebx, [t_px]
    shl ebx, 1
    add eax, ebx
    lea edi, [0x00200000 + eax]

    mov ecx, 16
.row:
    mov bl, [esi]
    push edi
    push ecx
    mov ecx, 8
.bit:
    test bl, 0x80
    jz .is_bg
    mov ax, [fg_565]
    mov [edi], ax
    jmp .next_b
.is_bg:
    cmp byte [t_transp], 1
    je .next_b
    mov ax, [bg_565]
    mov [edi], ax
.next_b:
    shl bl, 1
    add edi, 2
    loop .bit

    pop ecx
    pop edi
    inc esi
    add edi, 1600
    loop .row
    popad
    ret

; ==========================================================
;   SPLASH SCREEN MODERNA + 30 NOTAS DA ODE A ALEGRIA
; ==========================================================
k_splash_modern:
    call k_draw_wallpaper

    ; Sombra + Cartao Branco Central
    mov dword [r_x], 216
    mov dword [r_y], 126
    mov dword [r_w], 380
    mov dword [r_h], 260
    mov dword [r_rgb], 0x00081224
    call k_fill_rect

    mov dword [r_x], 210
    mov dword [r_y], 120
    mov dword [r_w], 380
    mov dword [r_h], 260
    mov dword [r_rgb], 0x00F8FAFC
    call k_fill_rect

    ; Leitor de 1900 em Alta Definicao
    mov dword [r_x], 376
    mov dword [r_y], 144
    mov dword [r_w], 48
    mov dword [r_h], 16
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect

    mov dword [r_x], 362
    mov dword [r_y], 160
    mov dword [r_w], 76
    mov dword [r_h], 5
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect

    mov dword [r_x], 380
    mov dword [r_y], 165
    mov dword [r_w], 40
    mov dword [r_h], 28
    mov dword [r_rgb], 0x00FDBA74
    call k_fill_rect

    mov dword [r_x], 384
    mov dword [r_y], 174
    mov dword [r_w], 12
    mov dword [r_h], 6
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    mov dword [r_x], 404
    mov dword [r_y], 174
    mov dword [r_w], 12
    mov dword [r_h], 6
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    mov dword [r_x], 360
    mov dword [r_y], 195
    mov dword [r_w], 80
    mov dword [r_h], 48
    mov dword [r_rgb], 0x00334155
    call k_fill_rect

    mov dword [r_x], 350
    mov dword [r_y], 214
    mov dword [r_w], 100
    mov dword [r_h], 36
    mov dword [r_rgb], 0x0078350F
    call k_fill_rect

    mov dword [r_x], 355
    mov dword [r_y], 217
    mov dword [r_w], 42
    mov dword [r_h], 29
    mov dword [r_rgb], 0x00FEF3C7
    call k_fill_rect

    mov dword [r_x], 403
    mov dword [r_y], 217
    mov dword [r_w], 42
    mov dword [r_h], 29
    mov dword [r_rgb], 0x00FEF3C7
    call k_fill_rect

    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x000F172A
    mov dword [t_px], 360
    mov dword [t_py], 272
    mov esi, splash_t1
    call k_print_xy

    mov dword [t_fg_rgb], 0x002563EB
    mov dword [t_px], 308
    mov dword [t_py], 296
    mov esi, splash_t2
    call k_print_xy

    mov dword [r_x], 230
    mov dword [r_y], 340
    mov dword [r_w], 340
    mov dword [r_h], 12
    mov dword [r_rgb], 0x00CBD5E1
    call k_fill_rect

    call k_flip_screen

    mov dword [bar_w], 10
    mov esi, ode_30_notes
.play_l:
    lodsw
    or ax, ax
    jz .done
    mov bx, ax
    lodsw
    movzx eax, ax

    push esi
    push eax
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

    mov dword [r_x], 230
    mov dword [r_y], 340
    mov eax, [bar_w]
    mov [r_w], eax
    mov dword [r_h], 12
    mov dword [r_rgb], 0x002563EB
    call k_fill_rect
    call k_flip_screen

    add dword [bar_w], 11
    cmp dword [bar_w], 340
    jle .ok_b
    mov dword [bar_w], 340
.ok_b:
    mov eax, 35
    call k_sleep_ms
    pop esi
    jmp .play_l

.done:
    mov eax, 350
    call k_sleep_ms
    ret

ode_30_notes:
    dw 3619, 240, 3619, 240, 3416, 240, 3043, 240
    dw 3043, 240, 3416, 240, 3619, 240, 4063, 240
    dw 4560, 240, 4560, 240, 4063, 240, 3619, 240
    dw 3619, 360, 4063, 140, 4063, 480
    dw 3619, 240, 3619, 240, 3416, 240, 3043, 240
    dw 3043, 240, 3416, 240, 3619, 240, 4063, 240
    dw 4560, 240, 4560, 240, 4063, 240, 3619, 240
    dw 4063, 360, 4560, 140, 4560, 520
    dw 0, 0

splash_t1 db 'OldOS v2.0', 0
splash_t2 db 'with Oldog v2.0', 0

r_x       dd 0
r_y       dd 0
r_w       dd 0
r_h       dd 0
r_rgb     dd 0
fg_565    dw 0
bg_565    dw 0
t_px      dd 0
t_py      dd 0
t_fg_rgb  dd 0x00FFFFFF
t_bg_rgb  dd 0x00000000
t_transp  db 0
bar_w     dd 10