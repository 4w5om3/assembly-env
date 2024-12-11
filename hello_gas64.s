# 64-bit GAS/AT&T Hello World
.section .data
    msg: .string "Hello, World!\n"
    len = . - msg

.section .text
.globl _start
_start:
    # write(1, msg, len)
    movq $1, %rax           # syscall: write
    movq $1, %rdi           # fd: stdout
    movq $msg, %rsi         # buf: msg
    movq $len, %rdx         # count: len
    syscall                 # syscall

    # exit(0)
    movq $60, %rax          # syscall: exit
    movq $0, %rdi           # status: 0
    syscall                 # syscall 
