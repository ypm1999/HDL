
./test/test.om:     file format elf32-littleriscv


Disassembly of section .rom:

00000000 <.rom>:
   0:	00020137          	lui	x2,0x20
   4:	7fd000ef          	jal	x1,1000 <main>
   8:	0ff00513          	addi	x10,x0,255
   c:	000306b7          	lui	x13,0x30
  10:	00a68223          	sb	x10,4(x13) # 30004 <__heap_start+0x2e004>
  14:	ff9ff06f          	jal	x0,c <main-0xff4>

Disassembly of section .text.startup:

00001000 <main>:
    1000:	ff010113          	addi	x2,x2,-16 # 1fff0 <__heap_start+0x1dff0>
    1004:	03000793          	addi	x15,x0,48
    1008:	00f10223          	sb	x15,4(x2)
    100c:	03300713          	addi	x14,x0,51
    1010:	000307b7          	lui	x15,0x30
    1014:	00e78023          	sb	x14,0(x15) # 30000 <__heap_start+0x2e000>
    1018:	00414703          	lbu	x14,4(x2)
    101c:	00000513          	addi	x10,x0,0
    1020:	00e78023          	sb	x14,0(x15)
    1024:	00a00713          	addi	x14,x0,10
    1028:	00e78023          	sb	x14,0(x15)
    102c:	01010113          	addi	x2,x2,16
    1030:	00008067          	jalr	x0,0(x1)

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	f6,f6,f4,f7,rmm
   4:	2820                	c.fld	f8,80(x8)
   6:	29554e47          	fmsub.s	f28,f10,f21,f5,rmm
   a:	3820                	c.fld	f8,112(x8)
   c:	322e                	c.fldsp	f4,232(x2)
   e:	302e                	c.fldsp	f0,232(x2)
	...
