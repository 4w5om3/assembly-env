.section .data
  value1: .int 12
  value2: .int 0
  value3: .int 0
  p: .int 43
  #value2=p/value1;value3=p%value1;
  output: .asciz "The quotient is %d\n"
  output1: .asciz "The remainder is %d\n"

.section .text
.globl _start

_start:
  mov  p,%eax
  cdq  #edx:eax=SE(eax)
  #mov  value1,%ebx
  #div  %ebx
  divl value1
  mov  %eax,value2
  mov  %edx,value3

  mov  value2,%esi
  mov  $output,%rdi
  mov  $0x0,%eax
  call printf

  mov  value3,%esi
  mov  $output1,%rdi
  mov  $0x0,%eax
  call printf

  movl $0, %ebx
  movl $1, %eax
  int $0x80

