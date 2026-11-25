#!/bin/bash
set -e

echo "Building OldOS v2.1 (1.44 MB Standard Boot Image)..."
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin

cat boot.bin kernel.bin > oldos.img
rm -f boot.bin kernel.bin

# Expande a imagem para 1.44 MB (1474560 bytes) para o SeaBIOS reconhecer como HD/Floppy valido
truncate -s 1474560 oldos.img

TAMANHO=$(wc -c < oldos.img)
echo "Done! oldos.img size: $TAMANHO bytes (SeaBIOS & USB Ready)"