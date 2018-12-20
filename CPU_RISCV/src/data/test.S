.org 0x000
	.global _start
_start:
	ori x1, x0, 0x210 # x1 = h210
	lw x10, 0x010(x1)
	sw x10, 0x004(x1)
	sh x10, 0x008(x1)
	sb x10, 0x000(x1)
	jalr x9, x0, 0x10
	#addi x1, x1, 0x010
	lw x6, 0x004(x1)
	lh x7, 0x008(x1)
	lb x8, 0x000(x1)
	ori x2, x1, 0x021 # x2 = h231
	slli x3, x2, 1  # x3 = h462
	andi x4, x3, 0x568 # x4 = h460
	ori x5, x0, 0x68a # x5 = h68a
	
	
.org 0x220
	.word 0x12345678
	.word 0x3f3f3f3f