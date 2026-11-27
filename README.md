# OldOS v4.0 & Oldog v3.0 Desktop Environment

A 32-bit x86 hobbyist operating system running in Protected Mode, written from scratch in pure NASM Assembly. It features a custom graphical environment in 800x600 HighColor VESA (**Oldog v3.0**), a persistent hybrid file system (**OldFS v2.0**), functional ACPI/APM power management, PC Speaker audio, and a built-in command-line shell (**VelocityAnOldShell / veloldsh**).

## Key Features

- **32-bit Protected Mode Kernel (0x100000):** Includes a custom MBR bootloader (**boot.asm**) that detects actual system memory (**int 0x12 + E801**), preserves BIOS/VESA buffers, initializes VESA VBE at **800x600x16** (Linear Framebuffer, RGB565), and relocates the 32 KB kernel to the **1 MB** memory address.
- **Persistent Hybrid Storage (OldFS v2.0 - oldfs.asm / oldfs_io.asm):**
- Automatically detects **HDD/SSD (ATA PIO LBA28)** or boots from a **USB flash drive** via a 16-bit Real Mode BIOS bridge (**0x5000**). 
- Supports **Save, Load, and Delete** operations for text notes (**note.txt**) and 220 KB drawing files (**drawing.art**).
- **OldFE - Old File Explorer (oldog_v2_fe.asm):** A visual file manager that detects the active storage device and lists saved files, offering one-click options to **Open**, **Delete**, or **Refresh**. - **Oldog Desktop Environment v3.0:**
- **OldPaint:** A freehand drawing studio with a 5-color palette and full data persistence via **OldFS**. 
- **OldPong:** An 800x600 arcade game featuring double buffering and sound effects played through the PC speaker. 
- **Notepad & Calculator:** A persistent note editor and a built-in calculator. 
- **Smusic Dog Old:** A retro 5-track music player using the PC speaker (*Ode to Joy*, *Imperial March*, *Oldog Arcade*, *Für Elise*, and the *Tetris Theme*). 
- **OldWeb Browser, OldStore & OldOS System Updater:** An offline browser, an integrated app marketplace, and a system reboot/shutdown utility with a countdown timer.
- **Power Management on Real Hardware (acpi_power.asm):** A modern shutdown screen featuring a progress bar, audible signals, and physical power-off via **ACPI FADT/DSDT (_S5)** and **APM 1.2 BIOS**.
- **VelocityAnOldShell (veloldsh):**
- **oldog / gui** - Launches the Oldog v3.0 desktop environment. 
- **save [text] / cat** - Writes and reads persistent notes to/from OldFS. 
- **play [1-5] / beep** - Plays built-in tracks via the PC speaker. 
- **sysinfo / mem / cpu / time** - Inspects physical RAM, the CPUID vendor string, and the CMOS RTC clock. 
- **dog, echo [text], cls, reboot, shutdown**. ## Compilation and Execution

### Requirements

- **nasm** (Netwide Assembler)
- A bash environment (Linux, WSL, or MSYS2 on Windows)

### Compiling the Bootable Image

chmod +x build.sh
./build.sh

This compiles **boot.asm** and **kernel.asm** into a standard 1.44 MB (**1,474,560** bytes) bootable image (**oldos.img**), ready for use on flash drives (via Rufus), actual x86 hardware, **v86**, or **QEMU**.

### Quick Testing in QEMU or v86

- **QEMU:** qemu-system-i386 -hda oldos.img -audiodev pa,id=snd0 -machine pcspk-audiodev=snd0
- **v86:** Go to https://copy.sh, load **oldos.img** into the **Hard drive image** field, and click **Start Emulation**.
