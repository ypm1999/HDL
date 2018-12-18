.org 0x00000000
	.global _start
_start:
	ori x1, x0, 0x210 # x1 = h210
	ori x2, x1, 0x021 # x2 = h231
	slli x3, x2, 1  # x3 = h462
	andi x4, x3, 0x568 # x4 = h460
	ori x5, x0, 0x68a # x5 = h68a
	lw x6, 0x010(x1)
	
.org 0x220
	.word 0x3f3f3f3f