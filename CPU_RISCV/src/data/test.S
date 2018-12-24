	.org 0x0
	.globl _start

_start:
	lui	x3,0x0eeff
	srli x3, x3, 12
	sb	x3, 3(x0)		 # [0x3] = 0xff
	srl  x3,x3,8
	sb	x3, 2(x0)		 # [0x2] = 0xee
	lui x3,0xccdd
	srli x3, x3, 12
	sb	x3, 1(x0)		 # [0x1] = 0xdd
	srl  x3,x3,8
	sb	x3, 0(x0)		 # [0x0] = 0xcc
	lb	x1, 3(x0)		 # x1 = 0xffffffff
	lbu  x1, 2(x0)		 # x1 = 0x000000ee
	lw	x1, 0(x0)		# x1 = 0xffeeddcc
	nop
