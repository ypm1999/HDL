
./test/test.om:     file format elf32-littleriscv


Disassembly of section .rom:

00000000 <.rom>:
   0:	00020137          	lui	x2,0x20
   4:	0d4010ef          	jal	x1,10d8 <main>
   8:	0ff00513          	addi	x10,x0,255
   c:	000306b7          	lui	x13,0x30
  10:	00a68223          	sb	x10,4(x13) # 30004 <__heap_start+0x2c004>
  14:	ff9ff06f          	jal	x0,c <__mulsi3-0xff4>

Disassembly of section .text:

00001000 <__mulsi3>:
    1000:	00050613          	addi	x12,x10,0
    1004:	00000513          	addi	x10,x0,0
    1008:	0015f693          	andi	x13,x11,1
    100c:	00068463          	beq	x13,x0,1014 <__mulsi3+0x14>
    1010:	00c50533          	add	x10,x10,x12
    1014:	0015d593          	srli	x11,x11,0x1
    1018:	00161613          	slli	x12,x12,0x1
    101c:	fe0596e3          	bne	x11,x0,1008 <__mulsi3+0x8>
    1020:	00008067          	jalr	x0,0(x1)

00001024 <__divsi3>:
    1024:	06054063          	blt	x10,x0,1084 <__umodsi3+0x10>
    1028:	0605c663          	blt	x11,x0,1094 <__umodsi3+0x20>

0000102c <__udivsi3>:
    102c:	00058613          	addi	x12,x11,0
    1030:	00050593          	addi	x11,x10,0
    1034:	fff00513          	addi	x10,x0,-1
    1038:	02060c63          	beq	x12,x0,1070 <__udivsi3+0x44>
    103c:	00100693          	addi	x13,x0,1
    1040:	00b67a63          	bgeu	x12,x11,1054 <__udivsi3+0x28>
    1044:	00c05863          	bge	x0,x12,1054 <__udivsi3+0x28>
    1048:	00161613          	slli	x12,x12,0x1
    104c:	00169693          	slli	x13,x13,0x1
    1050:	feb66ae3          	bltu	x12,x11,1044 <__udivsi3+0x18>
    1054:	00000513          	addi	x10,x0,0
    1058:	00c5e663          	bltu	x11,x12,1064 <__udivsi3+0x38>
    105c:	40c585b3          	sub	x11,x11,x12
    1060:	00d56533          	or	x10,x10,x13
    1064:	0016d693          	srli	x13,x13,0x1
    1068:	00165613          	srli	x12,x12,0x1
    106c:	fe0696e3          	bne	x13,x0,1058 <__udivsi3+0x2c>
    1070:	00008067          	jalr	x0,0(x1)

00001074 <__umodsi3>:
    1074:	00008293          	addi	x5,x1,0
    1078:	fb5ff0ef          	jal	x1,102c <__udivsi3>
    107c:	00058513          	addi	x10,x11,0
    1080:	00028067          	jalr	x0,0(x5)
    1084:	40a00533          	sub	x10,x0,x10
    1088:	0005d863          	bge	x11,x0,1098 <__umodsi3+0x24>
    108c:	40b005b3          	sub	x11,x0,x11
    1090:	f9dff06f          	jal	x0,102c <__udivsi3>
    1094:	40b005b3          	sub	x11,x0,x11
    1098:	00008293          	addi	x5,x1,0
    109c:	f91ff0ef          	jal	x1,102c <__udivsi3>
    10a0:	40a00533          	sub	x10,x0,x10
    10a4:	00028067          	jalr	x0,0(x5)

000010a8 <__modsi3>:
    10a8:	00008293          	addi	x5,x1,0
    10ac:	0005ca63          	blt	x11,x0,10c0 <__modsi3+0x18>
    10b0:	00054c63          	blt	x10,x0,10c8 <__modsi3+0x20>
    10b4:	f79ff0ef          	jal	x1,102c <__udivsi3>
    10b8:	00058513          	addi	x10,x11,0
    10bc:	00028067          	jalr	x0,0(x5)
    10c0:	40b005b3          	sub	x11,x0,x11
    10c4:	fe0558e3          	bge	x10,x0,10b4 <__modsi3+0xc>
    10c8:	40a00533          	sub	x10,x0,x10
    10cc:	f61ff0ef          	jal	x1,102c <__udivsi3>
    10d0:	40b00533          	sub	x10,x0,x11
    10d4:	00028067          	jalr	x0,0(x5)

Disassembly of section .text.startup:

000010d8 <main>:
    10d8:	000017b7          	lui	x15,0x1
    10dc:	00003737          	lui	x14,0x3
    10e0:	fa010113          	addi	x2,x2,-96 # 1ffa0 <__heap_start+0x1bfa0>
    10e4:	30c78793          	addi	x15,x15,780 # 130c <__bss_start>
    10e8:	bc070713          	addi	x14,x14,-1088 # 2bc0 <__bss_start+0x18b4>
    10ec:	04112e23          	sw	x1,92(x2)
    10f0:	04812c23          	sw	x8,88(x2)
    10f4:	04912a23          	sw	x9,84(x2)
    10f8:	05212823          	sw	x18,80(x2)
    10fc:	05312623          	sw	x19,76(x2)
    1100:	05412423          	sw	x20,72(x2)
    1104:	05512223          	sw	x21,68(x2)
    1108:	05612023          	sw	x22,64(x2)
    110c:	03712e23          	sw	x23,60(x2)
    1110:	03812c23          	sw	x24,56(x2)
    1114:	03912a23          	sw	x25,52(x2)
    1118:	03a12823          	sw	x26,48(x2)
    111c:	03b12623          	sw	x27,44(x2)
    1120:	00e78733          	add	x14,x15,x14
    1124:	7d000693          	addi	x13,x0,2000
    1128:	00d7a023          	sw	x13,0(x15)
    112c:	00478793          	addi	x15,x15,4
    1130:	fef71ce3          	bne	x14,x15,1128 <main+0x50>
    1134:	00002db7          	lui	x27,0x2
    1138:	00001c37          	lui	x24,0x1
    113c:	00004cb7          	lui	x25,0x4
    1140:	710d8793          	addi	x15,x27,1808 # 2710 <__bss_start+0x1404>
    1144:	aefc0d13          	addi	x26,x24,-1297 # aef <__mulsi3-0x511>
    1148:	ec8c8c93          	addi	x25,x25,-312 # 3ec8 <__bss_start+0x2bbc>
    114c:	5dfc0c13          	addi	x24,x24,1503
    1150:	00000493          	addi	x9,x0,0
    1154:	01410a13          	addi	x20,x2,20
    1158:	00f12623          	sw	x15,12(x2)
    115c:	00900b13          	addi	x22,x0,9
    1160:	00030bb7          	lui	x23,0x30
    1164:	004ca783          	lw	x15,4(x25)
    1168:	000c0593          	addi	x11,x24,0
    116c:	000d0413          	addi	x8,x26,0
    1170:	00279913          	slli	x18,x15,0x2
    1174:	00f90933          	add	x18,x18,x15
    1178:	00391913          	slli	x18,x18,0x3
    117c:	40f90933          	sub	x18,x18,x15
    1180:	00491913          	slli	x18,x18,0x4
    1184:	00f90933          	add	x18,x18,x15
    1188:	00491913          	slli	x18,x18,0x4
    118c:	00090513          	addi	x10,x18,0
    1190:	f19ff0ef          	jal	x1,10a8 <__modsi3>
    1194:	00aca223          	sw	x10,4(x25)
    1198:	000c0593          	addi	x11,x24,0
    119c:	00090513          	addi	x10,x18,0
    11a0:	e85ff0ef          	jal	x1,1024 <__divsi3>
    11a4:	00050a93          	addi	x21,x10,0
    11a8:	ffec0993          	addi	x19,x24,-2
    11ac:	000c8913          	addi	x18,x25,0
    11b0:	00040593          	addi	x11,x8,0
    11b4:	000a8513          	addi	x10,x21,0
    11b8:	e49ff0ef          	jal	x1,1000 <__mulsi3>
    11bc:	00092783          	lw	x15,0(x18)
    11c0:	00098593          	addi	x11,x19,0
    11c4:	fff40413          	addi	x8,x8,-1
    11c8:	00279a93          	slli	x21,x15,0x2
    11cc:	00fa8ab3          	add	x21,x21,x15
    11d0:	003a9a93          	slli	x21,x21,0x3
    11d4:	40fa8ab3          	sub	x21,x21,x15
    11d8:	004a9a93          	slli	x21,x21,0x4
    11dc:	00fa8ab3          	add	x21,x21,x15
    11e0:	004a9a93          	slli	x21,x21,0x4
    11e4:	00aa8ab3          	add	x21,x21,x10
    11e8:	000a8513          	addi	x10,x21,0
    11ec:	ebdff0ef          	jal	x1,10a8 <__modsi3>
    11f0:	00a92023          	sw	x10,0(x18)
    11f4:	00098593          	addi	x11,x19,0
    11f8:	000a8513          	addi	x10,x21,0
    11fc:	e29ff0ef          	jal	x1,1024 <__divsi3>
    1200:	00050a93          	addi	x21,x10,0
    1204:	ffc90913          	addi	x18,x18,-4
    1208:	ffe98993          	addi	x19,x19,-2
    120c:	fa0412e3          	bne	x8,x0,11b0 <main+0xd8>
    1210:	00c12583          	lw	x11,12(x2)
    1214:	00000913          	addi	x18,x0,0
    1218:	e0dff0ef          	jal	x1,1024 <__divsi3>
    121c:	009504b3          	add	x9,x10,x9
    1220:	0004dc63          	bge	x9,x0,1238 <main+0x160>
    1224:	409004b3          	sub	x9,x0,x9
    1228:	00100913          	addi	x18,x0,1
    122c:	00c0006f          	jal	x0,1238 <main+0x160>
    1230:	000d8413          	addi	x8,x27,0
    1234:	00050493          	addi	x9,x10,0
    1238:	00a00593          	addi	x11,x0,10
    123c:	00048513          	addi	x10,x9,0
    1240:	e69ff0ef          	jal	x1,10a8 <__modsi3>
    1244:	03050513          	addi	x10,x10,48
    1248:	00140d93          	addi	x27,x8,1
    124c:	0ff57993          	andi	x19,x10,255
    1250:	01ba0733          	add	x14,x20,x27
    1254:	00048513          	addi	x10,x9,0
    1258:	00a00593          	addi	x11,x0,10
    125c:	ff370fa3          	sb	x19,-1(x14)
    1260:	dc5ff0ef          	jal	x1,1024 <__divsi3>
    1264:	fc9b46e3          	blt	x22,x9,1230 <main+0x158>
    1268:	00090e63          	beq	x18,x0,1284 <main+0x1ac>
    126c:	02010793          	addi	x15,x2,32
    1270:	01b78733          	add	x14,x15,x27
    1274:	02d00793          	addi	x15,x0,45
    1278:	fef70a23          	sb	x15,-12(x14)
    127c:	000d8413          	addi	x8,x27,0
    1280:	02d00993          	addi	x19,x0,45
    1284:	008a0433          	add	x8,x20,x8
    1288:	00c0006f          	jal	x0,1294 <main+0x1bc>
    128c:	fff44983          	lbu	x19,-1(x8)
    1290:	00078413          	addi	x8,x15,0
    1294:	013b8023          	sb	x19,0(x23) # 30000 <__heap_start+0x2c000>
    1298:	fff40793          	addi	x15,x8,-1
    129c:	fe8a18e3          	bne	x20,x8,128c <main+0x1b4>
    12a0:	00c12583          	lw	x11,12(x2)
    12a4:	000a8513          	addi	x10,x21,0
    12a8:	fe4c0c13          	addi	x24,x24,-28
    12ac:	dfdff0ef          	jal	x1,10a8 <__modsi3>
    12b0:	fff00793          	addi	x15,x0,-1
    12b4:	00050493          	addi	x9,x10,0
    12b8:	ff2d0d13          	addi	x26,x26,-14
    12bc:	fc8c8c93          	addi	x25,x25,-56
    12c0:	eafc12e3          	bne	x24,x15,1164 <main+0x8c>
    12c4:	00a00793          	addi	x15,x0,10
    12c8:	00fb8023          	sb	x15,0(x23)
    12cc:	05c12083          	lw	x1,92(x2)
    12d0:	05812403          	lw	x8,88(x2)
    12d4:	05412483          	lw	x9,84(x2)
    12d8:	05012903          	lw	x18,80(x2)
    12dc:	04c12983          	lw	x19,76(x2)
    12e0:	04812a03          	lw	x20,72(x2)
    12e4:	04412a83          	lw	x21,68(x2)
    12e8:	04012b03          	lw	x22,64(x2)
    12ec:	03c12b83          	lw	x23,60(x2)
    12f0:	03812c03          	lw	x24,56(x2)
    12f4:	03412c83          	lw	x25,52(x2)
    12f8:	03012d03          	lw	x26,48(x2)
    12fc:	02c12d83          	lw	x27,44(x2)
    1300:	00000513          	addi	x10,x0,0
    1304:	06010113          	addi	x2,x2,96
    1308:	00008067          	jalr	x0,0(x1)

Disassembly of section .bss:

0000130c <f>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	f6,f6,f4,f7,rmm
   4:	2820                	c.fld	f8,80(x8)
   6:	29554e47          	fmsub.s	f28,f10,f21,f5,rmm
   a:	3820                	c.fld	f8,112(x8)
   c:	322e                	c.fldsp	f4,232(x2)
   e:	302e                	c.fldsp	f0,232(x2)
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	008e                	c.slli	x1,0x3
   2:	0000                	unimp
   4:	0002                	c.slli64	x0
   6:	0048                	c.addi4spn	x10,x2,4
   8:	0000                	unimp
   a:	0101                	c.addi	x2,0
   c:	000d0efb          	0xd0efb
  10:	0101                	c.addi	x2,0
  12:	0101                	c.addi	x2,0
  14:	0000                	unimp
  16:	0100                	c.addi4spn	x8,x2,128
  18:	0000                	unimp
  1a:	2e01                	c.jal	32a <__mulsi3-0xcd6>
  1c:	2f2e                	c.fldsp	f30,200(x2)
  1e:	2e2e                	c.fldsp	f28,200(x2)
  20:	2f2e2e2f          	0x2f2e2e2f
  24:	2f2e                	c.fldsp	f30,200(x2)
  26:	6972                	c.flwsp	f18,28(x2)
  28:	2d766373          	csrrsi	x6,0x2d7,12
  2c:	2f636367          	0x2f636367
  30:	696c                	c.flw	f11,84(x10)
  32:	6762                	c.flwsp	f14,24(x2)
  34:	632f6363          	bltu	x30,x18,65a <__mulsi3-0x9a6>
  38:	69666e6f          	jal	x28,666ce <__heap_start+0x626ce>
  3c:	69722f67          	0x69722f67
  40:	00766373          	csrrsi	x6,0x7,12
  44:	6d00                	c.flw	f8,24(x10)
  46:	6c75                	c.lui	x24,0x1d
  48:	6964                	c.flw	f9,84(x10)
  4a:	00532e33          	slt	x28,x6,x5
  4e:	0001                	c.addi	x0,0
  50:	0000                	unimp
  52:	0500                	c.addi4spn	x8,x2,640
  54:	0002                	c.slli64	x0
  56:	0010                	0x10
  58:	0300                	c.addi4spn	x8,x2,384
  5a:	0124                	c.addi4spn	x9,x2,136
  5c:	04090103          	lb	x2,64(x18)
  60:	0100                	c.addi4spn	x8,x2,128
  62:	04090203          	lb	x4,64(x18)
  66:	0100                	c.addi4spn	x8,x2,128
  68:	04090103          	lb	x2,64(x18)
  6c:	0100                	c.addi4spn	x8,x2,128
  6e:	04090103          	lb	x2,64(x18)
  72:	0100                	c.addi4spn	x8,x2,128
  74:	04090203          	lb	x4,64(x18)
  78:	0100                	c.addi4spn	x8,x2,128
  7a:	04090103          	lb	x2,64(x18)
  7e:	0100                	c.addi4spn	x8,x2,128
  80:	04090103          	lb	x2,64(x18)
  84:	0100                	c.addi4spn	x8,x2,128
  86:	04090103          	lb	x2,64(x18)
  8a:	0100                	c.addi4spn	x8,x2,128
  8c:	0409                	c.addi	x8,2
  8e:	0000                	unimp
  90:	0101                	c.addi	x2,0
  92:	0164                	c.addi4spn	x9,x2,140
  94:	0000                	unimp
  96:	0002                	c.slli64	x0
  98:	0045                	c.addi	x0,17
  9a:	0000                	unimp
  9c:	0101                	c.addi	x2,0
  9e:	000d0efb          	0xd0efb
  a2:	0101                	c.addi	x2,0
  a4:	0101                	c.addi	x2,0
  a6:	0000                	unimp
  a8:	0100                	c.addi4spn	x8,x2,128
  aa:	0000                	unimp
  ac:	2e01                	c.jal	3bc <__mulsi3-0xc44>
  ae:	2f2e                	c.fldsp	f30,200(x2)
  b0:	2e2e                	c.fldsp	f28,200(x2)
  b2:	2f2e2e2f          	0x2f2e2e2f
  b6:	2f2e                	c.fldsp	f30,200(x2)
  b8:	6972                	c.flwsp	f18,28(x2)
  ba:	2d766373          	csrrsi	x6,0x2d7,12
  be:	2f636367          	0x2f636367
  c2:	696c                	c.flw	f11,84(x10)
  c4:	6762                	c.flwsp	f14,24(x2)
  c6:	632f6363          	bltu	x30,x18,6ec <__mulsi3-0x914>
  ca:	69666e6f          	jal	x28,66760 <__heap_start+0x62760>
  ce:	69722f67          	0x69722f67
  d2:	00766373          	csrrsi	x6,0x7,12
  d6:	6400                	c.flw	f8,8(x8)
  d8:	7669                	c.lui	x12,0xffffa
  da:	532e                	c.lwsp	x6,232(x2)
  dc:	0100                	c.addi4spn	x8,x2,128
  de:	0000                	unimp
  e0:	0000                	unimp
  e2:	0205                	c.addi	x4,1
  e4:	1024                	c.addi4spn	x9,x2,40
  e6:	0000                	unimp
  e8:	0100c403          	lbu	x8,16(x1)
  ec:	04090103          	lb	x2,64(x18)
  f0:	0100                	c.addi4spn	x8,x2,128
  f2:	04090403          	lb	x8,64(x18)
  f6:	0100                	c.addi4spn	x8,x2,128
  f8:	04090103          	lb	x2,64(x18)
  fc:	0100                	c.addi4spn	x8,x2,128
  fe:	04090103          	lb	x2,64(x18)
 102:	0100                	c.addi4spn	x8,x2,128
 104:	04090103          	lb	x2,64(x18)
 108:	0100                	c.addi4spn	x8,x2,128
 10a:	04090103          	lb	x2,64(x18)
 10e:	0100                	c.addi4spn	x8,x2,128
 110:	04090103          	lb	x2,64(x18)
 114:	0100                	c.addi4spn	x8,x2,128
 116:	04090203          	lb	x4,64(x18)
 11a:	0100                	c.addi4spn	x8,x2,128
 11c:	04090103          	lb	x2,64(x18)
 120:	0100                	c.addi4spn	x8,x2,128
 122:	04090103          	lb	x2,64(x18)
 126:	0100                	c.addi4spn	x8,x2,128
 128:	04090103          	lb	x2,64(x18)
 12c:	0100                	c.addi4spn	x8,x2,128
 12e:	04090203          	lb	x4,64(x18)
 132:	0100                	c.addi4spn	x8,x2,128
 134:	04090203          	lb	x4,64(x18)
 138:	0100                	c.addi4spn	x8,x2,128
 13a:	04090103          	lb	x2,64(x18)
 13e:	0100                	c.addi4spn	x8,x2,128
 140:	04090103          	lb	x2,64(x18)
 144:	0100                	c.addi4spn	x8,x2,128
 146:	04090203          	lb	x4,64(x18)
 14a:	0100                	c.addi4spn	x8,x2,128
 14c:	04090103          	lb	x2,64(x18)
 150:	0100                	c.addi4spn	x8,x2,128
 152:	04090103          	lb	x2,64(x18)
 156:	0100                	c.addi4spn	x8,x2,128
 158:	04090203          	lb	x4,64(x18)
 15c:	0100                	c.addi4spn	x8,x2,128
 15e:	04090503          	lb	x10,64(x18)
 162:	0100                	c.addi4spn	x8,x2,128
 164:	04090103          	lb	x2,64(x18)
 168:	0100                	c.addi4spn	x8,x2,128
 16a:	04090103          	lb	x2,64(x18)
 16e:	0100                	c.addi4spn	x8,x2,128
 170:	04090103          	lb	x2,64(x18)
 174:	0100                	c.addi4spn	x8,x2,128
 176:	04090503          	lb	x10,64(x18)
 17a:	0100                	c.addi4spn	x8,x2,128
 17c:	04090103          	lb	x2,64(x18)
 180:	0100                	c.addi4spn	x8,x2,128
 182:	04090103          	lb	x2,64(x18)
 186:	0100                	c.addi4spn	x8,x2,128
 188:	04090103          	lb	x2,64(x18)
 18c:	0100                	c.addi4spn	x8,x2,128
 18e:	04090203          	lb	x4,64(x18)
 192:	0100                	c.addi4spn	x8,x2,128
 194:	04090203          	lb	x4,64(x18)
 198:	0100                	c.addi4spn	x8,x2,128
 19a:	04090103          	lb	x2,64(x18)
 19e:	0100                	c.addi4spn	x8,x2,128
 1a0:	04090103          	lb	x2,64(x18)
 1a4:	0100                	c.addi4spn	x8,x2,128
 1a6:	04090103          	lb	x2,64(x18)
 1aa:	0100                	c.addi4spn	x8,x2,128
 1ac:	04090403          	lb	x8,64(x18)
 1b0:	0100                	c.addi4spn	x8,x2,128
 1b2:	04090103          	lb	x2,64(x18)
 1b6:	0100                	c.addi4spn	x8,x2,128
 1b8:	04090103          	lb	x2,64(x18)
 1bc:	0100                	c.addi4spn	x8,x2,128
 1be:	04090203          	lb	x4,64(x18)
 1c2:	0100                	c.addi4spn	x8,x2,128
 1c4:	04090103          	lb	x2,64(x18)
 1c8:	0100                	c.addi4spn	x8,x2,128
 1ca:	04090103          	lb	x2,64(x18)
 1ce:	0100                	c.addi4spn	x8,x2,128
 1d0:	04090203          	lb	x4,64(x18)
 1d4:	0100                	c.addi4spn	x8,x2,128
 1d6:	04090103          	lb	x2,64(x18)
 1da:	0100                	c.addi4spn	x8,x2,128
 1dc:	04090203          	lb	x4,64(x18)
 1e0:	0100                	c.addi4spn	x8,x2,128
 1e2:	04090103          	lb	x2,64(x18)
 1e6:	0100                	c.addi4spn	x8,x2,128
 1e8:	04090103          	lb	x2,64(x18)
 1ec:	0100                	c.addi4spn	x8,x2,128
 1ee:	04090103          	lb	x2,64(x18)
 1f2:	0100                	c.addi4spn	x8,x2,128
 1f4:	0409                	c.addi	x8,2
 1f6:	0000                	unimp
 1f8:	0101                	c.addi	x2,0

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	0022                	c.slli	x0,0x8
   2:	0000                	unimp
   4:	0002                	c.slli64	x0
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0104                	c.addi4spn	x9,x2,128
   c:	0000                	unimp
   e:	0000                	unimp
  10:	1000                	c.addi4spn	x8,x2,32
  12:	0000                	unimp
  14:	1024                	c.addi4spn	x9,x2,40
  16:	0000                	unimp
  18:	0000                	unimp
  1a:	0000                	unimp
  1c:	0032                	c.slli	x0,0xc
  1e:	0000                	unimp
  20:	0080                	c.addi4spn	x8,x2,64
  22:	0000                	unimp
  24:	8001                	c.srli64	x8
  26:	0022                	c.slli	x0,0x8
  28:	0000                	unimp
  2a:	0002                	c.slli64	x0
  2c:	0014                	0x14
  2e:	0000                	unimp
  30:	0104                	c.addi4spn	x9,x2,128
  32:	0092                	c.slli	x1,0x4
  34:	0000                	unimp
  36:	1024                	c.addi4spn	x9,x2,40
  38:	0000                	unimp
  3a:	10d8                	c.addi4spn	x14,x2,100
  3c:	0000                	unimp
  3e:	008e                	c.slli	x1,0x3
  40:	0000                	unimp
  42:	0032                	c.slli	x0,0xc
  44:	0000                	unimp
  46:	0080                	c.addi4spn	x8,x2,64
  48:	0000                	unimp
  4a:	8001                	c.srli64	x8

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	1101                	c.addi	x2,-32
   2:	1000                	c.addi4spn	x8,x2,32
   4:	1106                	c.slli	x2,0x21
   6:	1201                	c.addi	x4,-32
   8:	0301                	c.addi	x6,0
   a:	1b0e                	c.slli	x22,0x23
   c:	250e                	c.fldsp	f10,192(x2)
   e:	130e                	c.slli	x6,0x23
  10:	0005                	c.addi	x0,1
  12:	0000                	unimp
  14:	1101                	c.addi	x2,-32
  16:	1000                	c.addi4spn	x8,x2,32
  18:	1106                	c.slli	x2,0x21
  1a:	1201                	c.addi	x4,-32
  1c:	0301                	c.addi	x6,0
  1e:	1b0e                	c.slli	x22,0x23
  20:	250e                	c.fldsp	f10,192(x2)
  22:	130e                	c.slli	x6,0x23
  24:	0005                	c.addi	x0,1
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	001c                	0x1c
   2:	0000                	unimp
   4:	0002                	c.slli64	x0
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0004                	0x4
   c:	0000                	unimp
   e:	0000                	unimp
  10:	1000                	c.addi4spn	x8,x2,32
  12:	0000                	unimp
  14:	0024                	c.addi4spn	x9,x2,8
	...
  1e:	0000                	unimp
  20:	001c                	0x1c
  22:	0000                	unimp
  24:	0002                	c.slli64	x0
  26:	0026                	c.slli	x0,0x9
  28:	0000                	unimp
  2a:	0004                	0x4
  2c:	0000                	unimp
  2e:	0000                	unimp
  30:	1024                	c.addi4spn	x9,x2,40
  32:	0000                	unimp
  34:	00b4                	c.addi4spn	x13,x2,72
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	2e2e                	c.fldsp	f28,200(x2)
   2:	2f2e2e2f          	0x2f2e2e2f
   6:	2e2e                	c.fldsp	f28,200(x2)
   8:	722f2e2f          	0x722f2e2f
   c:	7369                	c.lui	x6,0xffffa
   e:	672d7663          	bgeu	x26,x18,67a <__mulsi3-0x986>
  12:	6c2f6363          	bltu	x30,x2,6d8 <__mulsi3-0x928>
  16:	6269                	c.lui	x4,0x1a
  18:	2f636367          	0x2f636367
  1c:	666e6f63          	bltu	x28,x6,69a <__mulsi3-0x966>
  20:	6769                	c.lui	x14,0x1a
  22:	7369722f          	0x7369722f
  26:	6d2f7663          	bgeu	x30,x18,6f2 <__mulsi3-0x90e>
  2a:	6c75                	c.lui	x24,0x1d
  2c:	6964                	c.flw	f9,84(x10)
  2e:	00532e33          	slt	x28,x6,x5
  32:	746e6d2f          	0x746e6d2f
  36:	722f642f          	0x722f642f
  3a:	7369                	c.lui	x6,0xffffa
  3c:	672d7663          	bgeu	x26,x18,6a8 <__mulsi3-0x958>
  40:	756e                	c.flwsp	f10,248(x2)
  42:	742d                	c.lui	x8,0xfffeb
  44:	636c6f6f          	jal	x30,c667a <__heap_start+0xc267a>
  48:	6168                	c.flw	f10,68(x10)
  4a:	6e69                	c.lui	x28,0x1a
  4c:	6975622f          	0x6975622f
  50:	646c                	c.flw	f11,76(x8)
  52:	672d                	c.lui	x14,0xb
  54:	6e2d6363          	bltu	x26,x2,73a <__mulsi3-0x8c6>
  58:	7765                	c.lui	x14,0xffff9
  5a:	696c                	c.flw	f11,84(x10)
  5c:	2d62                	c.fldsp	f26,24(x2)
  5e:	67617473          	csrrci	x8,0x676,2
  62:	3265                	c.jal	fffffa0a <__heap_start+0xffffba0a>
  64:	7369722f          	0x7369722f
  68:	32337663          	bgeu	x6,x3,394 <__mulsi3-0xc6c>
  6c:	752d                	c.lui	x10,0xfffeb
  6e:	6b6e                	c.flwsp	f22,216(x2)
  70:	6f6e                	c.flwsp	f30,216(x2)
  72:	652d6e77          	0x652d6e77
  76:	666c                	c.flw	f11,76(x12)
  78:	62696c2f          	0x62696c2f
  7c:	00636367          	0x636367
  80:	20554e47          	fmsub.s	f28,f10,f5,f4,rmm
  84:	5341                	c.li	x6,-16
  86:	3220                	c.fld	f8,96(x12)
  88:	332e                	c.fldsp	f6,232(x2)
  8a:	2e31                	c.jal	3a6 <__mulsi3-0xc5a>
  8c:	0031                	c.addi	x0,12
  8e:	2e2e                	c.fldsp	f28,200(x2)
  90:	2f2e2e2f          	0x2f2e2e2f
  94:	2e2e                	c.fldsp	f28,200(x2)
  96:	722f2e2f          	0x722f2e2f
  9a:	7369                	c.lui	x6,0xffffa
  9c:	672d7663          	bgeu	x26,x18,708 <__mulsi3-0x8f8>
  a0:	6c2f6363          	bltu	x30,x2,766 <__mulsi3-0x89a>
  a4:	6269                	c.lui	x4,0x1a
  a6:	2f636367          	0x2f636367
  aa:	666e6f63          	bltu	x28,x6,728 <__mulsi3-0x8d8>
  ae:	6769                	c.lui	x14,0x1a
  b0:	7369722f          	0x7369722f
  b4:	642f7663          	bgeu	x30,x2,700 <__mulsi3-0x900>
  b8:	7669                	c.lui	x12,0xffffa
  ba:	532e                	c.lwsp	x6,232(x2)
	...
