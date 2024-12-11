# 32-bit GAS/AT&T Hello World
.section .data
    msg: .string "Hello, World!\n"
    len = . - msg

.section .text
.globl _start
_start:
    # write(1, msg, len)
    movl $4, %eax           # syscall: write
    movl $1, %ebx           # fd: stdout
    movl $msg, %ecx         # buf: msg
    movl $len, %edx         # count: len
    int $0x80              # syscall

    # exit(0)
    movl $1, %eax           # syscall: exit
    movl $0, %ebx           # status: 0
    int $0x80              # syscall 
