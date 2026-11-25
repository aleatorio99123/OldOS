[BITS 32]
[ORG 0x1000]

kernel_main:
    mov esp, 0x90000
    cld

    mov al, 0x34
    out 0x43, al
    xor al, al
    out 0x40, al
    out 0x40, al

    call k_splash_modern
    jmp start_oldog_v2

start_shell32:
    call k_shell_cls
    mov dword [t_fg_rgb], 0x0038BDF8
    mov esi, msg_banner
    call k_print_xy
    call k_flip_screen

prompt_loop:
    mov dword [t_fg_rgb], 0x004ADE80
    mov esi, msg_prompt
    call k_print_xy
    call k_flip_screen

    mov edi, cmd_buf
    call k_read_line_tc

    cmp byte [cmd_buf], 0
    je prompt_loop

    mov esi, cmd_buf
    mov edi, str_oldog
    call k_strcmp
    je start_oldog_v2

    mov esi, cmd_buf
    mov edi, str_gui
    call k_strcmp
    je start_oldog_v2

    mov esi, cmd_buf
    mov edi, str_help
    call k_strcmp
    je cmd_help

    mov esi, cmd_buf
    mov edi, str_cls
    call k_strcmp
    je .do_cls

    mov esi, cmd_buf
    mov edi, str_ver
    call k_strcmp
    je cmd_ver

    mov esi, cmd_buf
    mov edi, str_sysinfo
    call k_strcmp
    je cmd_sysinfo

    mov esi, cmd_buf
    mov edi, str_dog
    call k_strcmp
    je cmd_dog

    mov esi, cmd_buf
    mov edi, str_beep
    call k_strcmp
    je cmd_beep

    mov esi, cmd_buf
    mov edi, str_mem
    call k_strcmp
    je cmd_mem

    mov esi, cmd_buf
    mov edi, str_time
    call k_strcmp
    je cmd_time

    mov esi, cmd_buf
    mov edi, str_cpu
    call k_strcmp
    je cmd_cpu

    mov esi, cmd_buf
    mov edi, str_reboot
    call k_strcmp
    je cmd_reboot

    mov esi, cmd_buf
    mov edi, str_shutdown
    call k_strcmp
    je cmd_shutdown

    mov esi, cmd_buf
    mov edi, str_echo
    mov ecx, 5
    call k_strncmp
    je cmd_echo

    mov esi, cmd_buf
    mov edi, str_play
    mov ecx, 5
    call k_strncmp
    je cmd_play

    mov dword [t_fg_rgb], 0x00F87171
    mov esi, msg_bad
    call k_print_xy
    call k_flip_screen
    jmp prompt_loop

.do_cls:
    call k_shell_cls
    call k_flip_screen
    jmp prompt_loop

k_shell_cls:
    mov dword [r_x], 0
    mov dword [r_y], 0
    mov dword [r_w], 800
    mov dword [r_h], 600
    mov dword [r_rgb], 0x000F172A
    call k_fill_rect
    mov dword [t_px], 16
    mov dword [t_py], 16
    mov byte [t_transp], 0
    mov dword [t_bg_rgb], 0x000F172A
    ret

cmd_help:
    mov dword [t_fg_rgb], 0x00E2E8F0
    mov esi, msg_help
    call k_print_xy
    call k_flip_screen
    jmp prompt_loop

cmd_ver:
    mov dword [t_fg_rgb], 0x0038BDF8
    mov esi, msg_ver
    call k_print_xy
    call k_flip_screen
    jmp prompt_loop

cmd_dog:
    mov dword [t_fg_rgb], 0x00FACC15
    mov esi, msg_dog_art
    call k_print_xy
    call k_flip_screen
    jmp prompt_loop

cmd_beep:
    mov ax, 1400
    mov edx, 160
    call k_tone_ms
    jmp prompt_loop

cmd_play:
    mov al, [cmd_buf + 5]
    cmp al, '2'
    je .t2
    cmp al, '3'
    je .t3
    mov esi, ode_30_notes
    call k_play_melody_ptr
    jmp prompt_loop
.t2:
    mov esi, song_imperial
    call k_play_melody_ptr
    jmp prompt_loop
.t3:
    mov esi, song_arcade
    call k_play_melody_ptr
    jmp prompt_loop

cmd_sysinfo:
    mov dword [t_fg_rgb], 0x0038BDF8
    mov esi, msg_ver
    call k_print_xy
    mov dword [t_fg_rgb], 0x00E2E8F0
    mov esi, msg_res
    call k_print_xy
    jmp cmd_mem

cmd_echo:
    mov dword [t_fg_rgb], 0x00F8FAFC
    mov esi, cmd_buf + 5
    call k_print_xy
    mov dword [t_px], 16
    add dword [t_py], 18
    call k_flip_screen
    jmp prompt_loop

cmd_mem:
    mov dword [t_fg_rgb], 0x00E2E8F0
    mov esi, msg_mem_conv
    call k_print_xy
    mov eax, [0x0500]
    mov edi, num_tmp
    call k_int_to_str
    mov esi, num_tmp
    call k_print_xy
    mov esi, msg_kb
    call k_print_xy

    mov esi, msg_mem_ext
    call k_print_xy
    mov eax, [0x0504]
    mov edi, num_tmp
    call k_int_to_str
    mov esi, num_tmp
    call k_print_xy
    mov esi, msg_mb
    call k_print_xy
    call k_flip_screen
    jmp prompt_loop

cmd_time:
    mov dword [t_fg_rgb], 0x0038BDF8
    call k_get_cmos_str
    mov esi, cmos_buf
    call k_print_xy
    mov dword [t_px], 16
    add dword [t_py], 18
    call k_flip_screen
    jmp prompt_loop

cmd_cpu:
    mov dword [t_fg_rgb], 0x00FACC15
    xor eax, eax
    cpuid
    mov [cpu_buf], ebx
    mov [cpu_buf + 4], edx
    mov [cpu_buf + 8], ecx
    mov byte [cpu_buf + 12], 0
    mov esi, cpu_buf
    call k_print_xy
    mov dword [t_px], 16
    add dword [t_py], 18
    call k_flip_screen
    jmp prompt_loop

cmd_shutdown:
    call k_shell_cls
    mov dword [t_px], 240
    mov dword [t_py], 280
    mov dword [t_fg_rgb], 0x00FACC15
    mov esi, msg_safe_off
    call k_print_xy
    call k_flip_screen
    cli
.hlt: hlt
    jmp .hlt

cmd_reboot:
    cli
.w: in al, 0x64
    test al, 0x02
    jnz .w
    mov al, 0xFE
    out 0x64, al
    hlt

%include "shell_sys.asm"
%include "gfx32.asm"
%include "oldog_v2.asm"

times 24576 - ($ - $$) db 0