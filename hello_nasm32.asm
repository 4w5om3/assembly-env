; 32-bit NASM/Intel Hello World
section .data
    msg db "Hello, World!", 10
    len equ $ - msg

section .text
global _start
_start:
    ; write(1, msg, len)
    mov eax, 4              ; syscall: write
    mov ebx, 1              ; fd: stdout
    mov ecx, msg            ; buf: msg
    mov edx, len            ; count: len
    int 0x80               ; syscall

    ; exit(0)
    mov eax, 1              ; syscall: exit
    mov ebx, 0              ; status: 0
    int 0x80               ; syscall 
