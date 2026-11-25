# OldOS v2.1 & Oldog Desktop Environment

A hobbyist 32-bit x86 Protected Mode operating system written from scratch in pure NASM Assembly, featuring a custom 800×600 HighColor VESA graphical desktop (**Oldog v2.1**), PC Speaker polyphonic-style boot audio, and a built-in command-line shell (**VelocityAnOldShell / `veloldsh`**).

## Features

- **32-bit Protected Mode Kernel:** Custom MBR bootloader (`boot.asm`) that detects real system memory (`int 0x12` + `E801`), copies the BIOS 8×16 font, initializes VESA VBE `800×600×16` (RGB565 Linear Framebuffer), and jumps into 32-bit flat memory mode.
- **Double-Buffered HighColor Graphics (`gfx32.asm`):** Flicker-free rendering with a RAM backbuffer (`0x00200000`), modern gradient wallpaper, and real-time CMOS clock updates.
- **Modern Boot Splash & Audio:** Features the classic *1900s Reader* pixel illustration alongside a progress bar synchronized with the first 30 notes of Beethoven's *Ode to Joy* played via the PIT / PC Speaker.
- **Oldog v2.1 Desktop Environment:**
  - Custom pixel-art desktop icons and the **Oldog** mascot chewing a CRT monitor cable.
  - Native PS/2 mouse/touchpad driver (`0x60`/`0x64`) + `WASD` keyboard fallback.
  - **Built-in Apps:** Notepad, Calculator, **OldWeb Browser**, **OldStore** (in-OS marketplace to install **Smusic Dog Old**), and **OldOS System Updater** (hot-swap countdown rebooter).
- **VelocityAnOldShell (`veloldsh`):**
  - `oldog` / `gui` — Launch the Oldog v2.1 desktop environment.
  - `sysinfo` / `mem` / `cpu` / `time` — Inspect real hardware RAM, CPUID vendor string, and CMOS RTC clock.
  - `play [1-3]` / `beep` — Play built-in PC Speaker tracks.
  - `dog` — Print the Oldog ASCII mascot.
  - `echo [text]`, `cls`, `reboot`, `shutdown`.

## Building & Running

### Requirements
- `nasm` (Netwide Assembler)
- A bash environment (Linux, WSL, or MSYS2 on Windows)

### Build the Bootable Image
```bash
chmod +x build.sh
./build.sh
```
This compiles `boot.asm` and `kernel.asm` into a standard 1.44 MB (`1,474,560` bytes) bootable image (`oldos.img`) ready for **v86**, **QEMU**, or flashing onto a USB drive (e.g., via Rufus) to boot on real x86 hardware.

### Quick Test in QEMU
```bash
qemu-system-i386 -fda oldos.img -audiodev pa,id=snd0 -machine pcspk-audiodev=snd0
```
