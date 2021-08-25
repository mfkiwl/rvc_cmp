.org 0x00
clear_pipe:
  nop                       
  nop                       
  nop                       
  nop                       
reset:
  mv    x1, x0
  mv    x2, x1
  mv    x3, x1
  mv    x4, x1
  mv    x5, x1
  mv    x6, x1
  mv    x7, x1
  mv    x8, x1
  mv    x9, x1
  mv    x10, x1
  mv    x11, x1
  mv    x12, x1
  mv    x13, x1
  mv    x14, x1
  mv    x15, x1
  mv    x16, x1
  mv    x17, x1
  mv    x18, x1
  mv    x19, x1
  mv    x20, x1
  mv    x21, x1
  mv    x22, x1
  mv    x23, x1
  mv    x24, x1
  mv    x25, x1
  mv    x26, x1
  mv    x27, x1
  mv    x28, x1
  mv    x29, x1
  mv    x30, x1
  mv    x31, x1
main:
  li    x1,  1
  li    x2,  2
  li    x3,  3
  li    x4,  4
  li    x5,  5
  li    x6,  6
  li    x7,  7
  li    x8,  8

  slt   x9,  x2, x1 # x1>x2         -> 0
  sltu  x10, x1, x2 # x1>x2         -> 1
  srl   x11, x4, x1 # x4>>x1        -> 2
  and   x12, x3, x7 # 011 & 111     -> 3 (3'b011)
  sll   x13, x2, x1 # x2<<x1        -> 4
  add   x14, x1, x4 # x1+x4         -> 5
  xor   x15, x3, x5 # 011 ^ 101     -> 6 (3'b110)
  or    x16, x1, x6 # 001 | 110     -> 7 (3'b111)

  li    x31, 0x400
  sw    x1,  0x0(x10)
  sw    x2,  0x4(x10)
  sw    x3,  0x8(x10)
  sw    x4,  0xc(x10)
  sw    x5,  0x10(x10)
  sw    x6,  0x14(x10)
  sw    x7,  0x18(x10)
  sw    x8,  0x1c(x10)
  sw    x9,  0x20(x10)
  sw    x10, 0x24(x10)
  sw    x11, 0x28(x10)
  sw    x12, 0x2c(x10)
  sw    x13, 0x30(x10)
  sw    x14, 0x34(x10)
  sw    x15, 0x38(x10)
  sw    x16, 0x3c(x10)
eot:
  nop
  nop
  nop
  nop
  ebreak
  nop
  nop
  nop
  nop
