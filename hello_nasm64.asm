; 64-bit NASM/Intel Hello World
section .data
    msg db "Hello, World!", 10
    len equ $ - msg

section .text
global _start
_start:
    ; write(1, msg, len)
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; fd: stdout
    mov rsi, msg            ; buf: msg
    mov rdx, len            ; count: len
    syscall                ; syscall

    ; exit(0)
    mov rax, 60             ; syscall: exit
    mov rdi, 0              ; status: 0
    syscall                ; syscall 
