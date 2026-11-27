k_real_poweroff:
    cli
    ; Usa o mesmo fundo gradiente elegante da tela de boot
    call k_draw_wallpaper

    ; Sombra suave do cartao
    mov dword [r_x], 188
    mov dword [r_y], 178
    mov dword [r_w], 440
    mov dword [r_h], 240
    mov dword [r_rgb], 0x00020617
    call k_fill_rect

    ; Cartao principal centralizado (X=180, Y=170, W=440, H=240)
    mov dword [r_x], 180
    mov dword [r_y], 170
    mov dword [r_w], 440
    mov dword [r_h], 240
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect

    ; Barra superior azul vibrante do cartao
    mov dword [r_x], 180
    mov dword [r_y], 170
    mov dword [r_w], 440
    mov dword [r_h], 6
    mov dword [r_rgb], 0x0038BDF8
    call k_fill_rect

    ; Icone circular vermelho de Power no topo do cartao (X=382, Y=196)
    mov dword [r_x], 382
    mov dword [r_y], 196
    mov dword [r_w], 36
    mov dword [r_h], 36
    mov dword [r_rgb], 0x00EF4444
    call k_fill_rect
    mov dword [r_x], 398
    mov dword [r_y], 192
    mov dword [r_w], 4
    mov dword [r_h], 20
    mov dword [r_rgb], 0x00FFFFFF
    call k_fill_rect

    ; Textos centralizados
    mov byte [t_transp], 1
    mov dword [t_fg_rgb], 0x00FFFFFF
    mov dword [t_px], 324
    mov dword [t_py], 250
    mov esi, sd_title
    call k_print_xy

    mov dword [t_fg_rgb], 0x0094A3B8
    mov dword [t_px], 248
    mov dword [t_py], 282
    mov esi, sd_sub
    call k_print_xy

    ; Barra de progresso arredondada (Estagio 1: 50%)
    mov dword [r_x], 230
    mov dword [r_y], 335
    mov dword [r_w], 340
    mov dword [r_h], 14
    mov dword [r_rgb], 0x001E293B
    call k_fill_rect

    mov dword [r_w], 170
    mov dword [r_rgb], 0x0038BDF8
    call k_fill_rect
    call k_flip_screen

    mov ax, 1000
    mov edx, 120
    call k_tone_ms
    mov eax, 250
    call k_sleep_ms

    ; Barra de progresso (Estagio 2: 100%)
    mov dword [r_x], 230
    mov dword [r_y], 335
    mov dword [r_w], 340
    mov dword [r_h], 14
    mov dword [r_rgb], 0x0022C55E
    call k_fill_rect
    call k_flip_screen

    mov ax, 1500
    mov edx, 160
    call k_tone_ms
    mov eax, 400
    call k_sleep_ms

    ; Desliga o hardware de verdade (ACPI FADT + DSDT _S5)
    call k_acpi_hardware_shutdown
    jmp k_apm_bios_shutdown

k_acpi_hardware_shutdown:
    mov esi, 0x000E0000
.scan_rsdp:
    cmp dword [esi], 'RSD '
    jne .next_16
    cmp dword [esi + 4], 'PTR '
    je .found_rsdp
.next_16:
    add esi, 16
    cmp esi, 0x000FFFF0
    jb .scan_rsdp
    ret

.found_rsdp:
    mov edi, [esi + 16]
    or edi, edi
    jz .ret_acpi
    cmp dword [edi], 'RSDT'
    jne .ret_acpi

    mov ecx, [edi + 4]
    sub ecx, 36
    shr ecx, 2
    jz .ret_acpi
    add edi, 36

.scan_tables:
    mov ebx, [edi]
    cmp dword [ebx], 'FACP'
    je .found_fadt
    add edi, 4
    loop .scan_tables
.ret_acpi:
    ret

.found_fadt:
    mov eax, [ebx + 64]
    mov [acpi_pm1a], eax
    mov eax, [ebx + 68]
    mov [acpi_pm1b], eax

    mov edx, [ebx + 48]
    or edx, edx
    jz .scan_dsdt
    mov al, [ebx + 52]
    or al, al
    jz .scan_dsdt
    out dx, al
    mov eax, 60
    call k_sleep_ms

.scan_dsdt:
    mov esi, [ebx + 40]
    or esi, esi
    jz .send_s5_all
    cmp dword [esi], 'DSDT'
    jne .send_s5_all

    mov ecx, [esi + 4]
    sub ecx, 36
    add esi, 36
.find_s5:
    cmp dword [esi], '_S5_'
    je .parse_s5
    inc esi
    loop .find_s5
    jmp .send_s5_all

.parse_s5:
    add esi, 4
    cmp byte [esi], 0x12
    jne .send_s5_all
    add esi, 3
    cmp byte [esi], 0x0A
    jne .read_typa
    inc esi
.read_typa:
    movzx eax, byte [esi]
    and ax, 0x07
    shl ax, 10
    or ax, 0x2000

    mov edx, [acpi_pm1a]
    or edx, edx
    jz .try_pm1b
    out dx, ax
.try_pm1b:
    mov edx, [acpi_pm1b]
    or edx, edx
    jz .send_s5_all
    out dx, ax

.send_s5_all:
    mov edx, [acpi_pm1a]
    or edx, edx
    jz .ret_acpi
    xor cx, cx
.loop_typa:
    mov ax, cx
    shl ax, 10
    or ax, 0x2000
    out dx, ax
    inc cx
    cmp cx, 8
    jb .loop_typa
    ret

[BITS 32]
k_apm_bios_shutdown:
    lgdt [apm_gdt_desc]
    jmp 0x18:pm16_entry

[BITS 16]
pm16_entry:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov eax, cr0
    and eax, 0xFFFFFFFE
    mov cr0, eax
    jmp 0x0000:real16_off

real16_off:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov ax, 0x5301
    xor bx, bx
    int 0x15
    mov ax, 0x530E
    xor bx, bx
    mov cx, 0x0102
    int 0x15
    mov ax, 0x5308
    mov bx, 0x0001
    mov cx, 0x0001
    int 0x15
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

    cli
.final_hlt:
    hlt
    jmp .final_hlt

align 8
apm_gdt_start:
    dq 0x0000000000000000
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
    dq 0x00009A000000FFFF
    dq 0x000092000000FFFF
apm_gdt_end:

apm_gdt_desc:
    dw apm_gdt_end - apm_gdt_start - 1
    dd apm_gdt_start

[BITS 32]
acpi_pm1a dd 0
acpi_pm1b dd 0
sd_title  db 'Shutting down OldOS', 0
sd_sub    db 'Closing apps and turning off power...', 0