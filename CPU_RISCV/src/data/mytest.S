
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
   1008c:	0aabb1b7          	lui	x3,0xaabb
   10090:	00c1d193          	srli	x3,x3,0xc
   10094:	00301223          	sh	x3,4(x0) # 4 <_start-0x10050>
   10098:	00405083          	lhu	x1,4(x0) # 4 <_start-0x10050>
   1009c:	00401083          	lh	x1,4(x0) # 4 <_start-0x10050>
   100a0:	088991b7          	lui	x3,0x8899
   100a4:	00c1d193          	srli	x3,x3,0xc
   100a8:	00301323          	sh	x3,6(x0) # 6 <_start-0x1004e>
   100ac:	00601083          	lh	x1,6(x0) # 6 <_start-0x1004e>
   100b0:	00605083          	lhu	x1,6(x0) # 6 <_start-0x1004e>
   100b4:	044551b7          	lui	x3,0x4455
   100b8:	00c1d193          	srli	x3,x3,0xc
   100bc:	01019193          	slli	x3,x3,0x10
   100c0:	06677137          	lui	x2,0x6677
   100c4:	00c15113          	srli	x2,x2,0xc
   100c8:	003161b3          	or	x3,x2,x3
   100cc:	00302423          	sw	x3,8(x0) # 8 <_start-0x1004c>
   100d0:	00802083          	lw	x1,8(x0) # 8 <_start-0x1004c>

000100d4 <_loop>:
   100d4:	0000006f          	jal	x0,100d4 <_loop>
