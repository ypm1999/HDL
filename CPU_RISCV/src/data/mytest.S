
test.om:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <_start>:
   10054:	0eeff1b7          	lui	x3,0xeeff
   10058:	00c1d193          	srli	x3,x3,0xc
   1005c:	003001a3          	sb	x3,3(x0) # 3 <_start-0x10051>
   10060:	0081d193          	srli	x3,x3,0x8
   10064:	00300123          	sb	x3,2(x0) # 2 <_start-0x10052>
   10068:	0ccdd1b7          	lui	x3,0xccdd
   1006c:	00c1d193          	srli	x3,x3,0xc
   10070:	003000a3          	sb	x3,1(x0) # 1 <_start-0x10053>
   10074:	0081d193          	srli	x3,x3,0x8
   10078:	00300023          	sb	x3,0(x0) # 0 <_start-0x10054>
   1007c:	00300083          	lb	x1,3(x0) # 3 <_start-0x10051>
   10080:	00204083          	lbu	x1,2(x0) # 2 <_start-0x10052>
   10084:	00002083          	lw	x1,0(x0) # 0 <_start-0x10054>
   10088:	00000013          	addi	x0,x0,0
