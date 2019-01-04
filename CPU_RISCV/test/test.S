
./test/test.om:     file format elf32-littleriscv


Disassembly of section .rom:

00000000 <.rom>:
   0:	00020137          	lui	x2,0x20
   4:	17c010ef          	jal	x1,1180 <main>
   8:	0ff00513          	addi	x10,x0,255
   c:	000306b7          	lui	x13,0x30
  10:	00a68223          	sb	x10,4(x13) # 30004 <__heap_start+0x2e004>
  14:	ff9ff06f          	jal	x0,c <outl-0xff4>

Disassembly of section .text:

00001000 <outl>:
    1000:	fd010113          	addi	x2,x2,-48 # 1ffd0 <__heap_start+0x1dfd0>
    1004:	02912223          	sw	x9,36(x2)
    1008:	01512a23          	sw	x21,20(x2)
    100c:	02112623          	sw	x1,44(x2)
    1010:	02812423          	sw	x8,40(x2)
    1014:	03212023          	sw	x18,32(x2)
    1018:	01312e23          	sw	x19,28(x2)
    101c:	01412c23          	sw	x20,24(x2)
    1020:	00050493          	addi	x9,x10,0
    1024:	00000a93          	addi	x21,x0,0
    1028:	00055663          	bge	x10,x0,1034 <outl+0x34>
    102c:	40a004b3          	sub	x9,x0,x10
    1030:	00100a93          	addi	x21,x0,1
    1034:	00000993          	addi	x19,x0,0
    1038:	00410913          	addi	x18,x2,4
    103c:	00900a13          	addi	x20,x0,9
    1040:	00c0006f          	jal	x0,104c <outl+0x4c>
    1044:	00040993          	addi	x19,x8,0
    1048:	00050493          	addi	x9,x10,0
    104c:	00a00593          	addi	x11,x0,10
    1050:	00048513          	addi	x10,x9,0
    1054:	0fc000ef          	jal	x1,1150 <__modsi3>
    1058:	00198413          	addi	x8,x19,1
    105c:	03050713          	addi	x14,x10,48
    1060:	008907b3          	add	x15,x18,x8
    1064:	00048513          	addi	x10,x9,0
    1068:	00a00593          	addi	x11,x0,10
    106c:	fee78fa3          	sb	x14,-1(x15)
    1070:	05c000ef          	jal	x1,10cc <__divsi3>
    1074:	fc9a48e3          	blt	x20,x9,1044 <outl+0x44>
    1078:	000a8c63          	beq	x21,x0,1090 <outl+0x90>
    107c:	01010793          	addi	x15,x2,16
    1080:	008787b3          	add	x15,x15,x8
    1084:	02d00713          	addi	x14,x0,45
    1088:	fee78a23          	sb	x14,-12(x15)
    108c:	00298413          	addi	x8,x19,2
    1090:	008907b3          	add	x15,x18,x8
    1094:	000306b7          	lui	x13,0x30
    1098:	fff7c703          	lbu	x14,-1(x15)
    109c:	fff78793          	addi	x15,x15,-1
    10a0:	00e68023          	sb	x14,0(x13) # 30000 <__heap_start+0x2e000>
    10a4:	fef91ae3          	bne	x18,x15,1098 <outl+0x98>
    10a8:	02c12083          	lw	x1,44(x2)
    10ac:	02812403          	lw	x8,40(x2)
    10b0:	02412483          	lw	x9,36(x2)
    10b4:	02012903          	lw	x18,32(x2)
    10b8:	01c12983          	lw	x19,28(x2)
    10bc:	01812a03          	lw	x20,24(x2)
    10c0:	01412a83          	lw	x21,20(x2)
    10c4:	03010113          	addi	x2,x2,48
    10c8:	00008067          	jalr	x0,0(x1)

000010cc <__divsi3>:
    10cc:	06054063          	blt	x10,x0,112c <__umodsi3+0x10>
    10d0:	0605c663          	blt	x11,x0,113c <__umodsi3+0x20>

000010d4 <__udivsi3>:
    10d4:	00058613          	addi	x12,x11,0
    10d8:	00050593          	addi	x11,x10,0
    10dc:	fff00513          	addi	x10,x0,-1
    10e0:	02060c63          	beq	x12,x0,1118 <__udivsi3+0x44>
    10e4:	00100693          	addi	x13,x0,1
    10e8:	00b67a63          	bgeu	x12,x11,10fc <__udivsi3+0x28>
    10ec:	00c05863          	bge	x0,x12,10fc <__udivsi3+0x28>
    10f0:	00161613          	slli	x12,x12,0x1
    10f4:	00169693          	slli	x13,x13,0x1
    10f8:	feb66ae3          	bltu	x12,x11,10ec <__udivsi3+0x18>
    10fc:	00000513          	addi	x10,x0,0
    1100:	00c5e663          	bltu	x11,x12,110c <__udivsi3+0x38>
    1104:	40c585b3          	sub	x11,x11,x12
    1108:	00d56533          	or	x10,x10,x13
    110c:	0016d693          	srli	x13,x13,0x1
    1110:	00165613          	srli	x12,x12,0x1
    1114:	fe0696e3          	bne	x13,x0,1100 <__udivsi3+0x2c>
    1118:	00008067          	jalr	x0,0(x1)

0000111c <__umodsi3>:
    111c:	00008293          	addi	x5,x1,0
    1120:	fb5ff0ef          	jal	x1,10d4 <__udivsi3>
    1124:	00058513          	addi	x10,x11,0
    1128:	00028067          	jalr	x0,0(x5)
    112c:	40a00533          	sub	x10,x0,x10
    1130:	0005d863          	bge	x11,x0,1140 <__umodsi3+0x24>
    1134:	40b005b3          	sub	x11,x0,x11
    1138:	f9dff06f          	jal	x0,10d4 <__udivsi3>
    113c:	40b005b3          	sub	x11,x0,x11
    1140:	00008293          	addi	x5,x1,0
    1144:	f91ff0ef          	jal	x1,10d4 <__udivsi3>
    1148:	40a00533          	sub	x10,x0,x10
    114c:	00028067          	jalr	x0,0(x5)

00001150 <__modsi3>:
    1150:	00008293          	addi	x5,x1,0
    1154:	0005ca63          	blt	x11,x0,1168 <__modsi3+0x18>
    1158:	00054c63          	blt	x10,x0,1170 <__modsi3+0x20>
    115c:	f79ff0ef          	jal	x1,10d4 <__udivsi3>
    1160:	00058513          	addi	x10,x11,0
    1164:	00028067          	jalr	x0,0(x5)
    1168:	40b005b3          	sub	x11,x0,x11
    116c:	fe0558e3          	bge	x10,x0,115c <__modsi3+0xc>
    1170:	40a00533          	sub	x10,x0,x10
    1174:	f61ff0ef          	jal	x1,10d4 <__udivsi3>
    1178:	40b00533          	sub	x10,x0,x11
    117c:	00028067          	jalr	x0,0(x5)

Disassembly of section .text.startup:

00001180 <main>:
    1180:	fe010113          	addi	x2,x2,-32
    1184:	00912a23          	sw	x9,20(x2)
    1188:	000014b7          	lui	x9,0x1
    118c:	2584a783          	lw	x15,600(x9) # 1258 <__bss_start>
    1190:	200005b7          	lui	x11,0x20000
    1194:	fff58593          	addi	x11,x11,-1 # 1fffffff <__heap_start+0x1fffdfff>
    1198:	40000637          	lui	x12,0x40000
    119c:	01212823          	sw	x18,16(x2)
    11a0:	00001837          	lui	x16,0x1
    11a4:	00112e23          	sw	x1,28(x2)
    11a8:	00812c23          	sw	x8,24(x2)
    11ac:	01312623          	sw	x19,12(x2)
    11b0:	00b78733          	add	x14,x15,x11
    11b4:	ffe60613          	addi	x12,x12,-2 # 3ffffffe <__heap_start+0x3fffdffe>
    11b8:	26082503          	lw	x10,608(x16) # 1260 <A>
    11bc:	00001937          	lui	x18,0x1
    11c0:	04e66663          	bltu	x12,x14,120c <main+0x8c>
    11c4:	25c92703          	lw	x14,604(x18) # 125c <B>
    11c8:	40a786b3          	sub	x13,x15,x10
    11cc:	40a68533          	sub	x10,x13,x10
    11d0:	00151513          	slli	x10,x10,0x1
    11d4:	00e686b3          	add	x13,x13,x14
    11d8:	40a68533          	sub	x10,x13,x10
    11dc:	40a787b3          	sub	x15,x15,x10
    11e0:	40a786b3          	sub	x13,x15,x10
    11e4:	00169693          	slli	x13,x13,0x1
    11e8:	00e78733          	add	x14,x15,x14
    11ec:	40d70733          	sub	x14,x14,x13
    11f0:	00e787b3          	add	x15,x15,x14
    11f4:	40d787b3          	sub	x15,x15,x13
    11f8:	00b786b3          	add	x13,x15,x11
    11fc:	fcd676e3          	bgeu	x12,x13,11c8 <main+0x48>
    1200:	26a82023          	sw	x10,608(x16)
    1204:	24e92e23          	sw	x14,604(x18)
    1208:	24f4ac23          	sw	x15,600(x9)
    120c:	00030437          	lui	x8,0x30
    1210:	02000993          	addi	x19,x0,32
    1214:	dedff0ef          	jal	x1,1000 <outl>
    1218:	01340023          	sb	x19,0(x8) # 30000 <__heap_start+0x2e000>
    121c:	25c92503          	lw	x10,604(x18)
    1220:	de1ff0ef          	jal	x1,1000 <outl>
    1224:	01340023          	sb	x19,0(x8)
    1228:	2584a503          	lw	x10,600(x9)
    122c:	dd5ff0ef          	jal	x1,1000 <outl>
    1230:	00a00793          	addi	x15,x0,10
    1234:	00f40023          	sb	x15,0(x8)
    1238:	01c12083          	lw	x1,28(x2)
    123c:	01812403          	lw	x8,24(x2)
    1240:	01412483          	lw	x9,20(x2)
    1244:	01012903          	lw	x18,16(x2)
    1248:	00c12983          	lw	x19,12(x2)
    124c:	00000513          	addi	x10,x0,0
    1250:	02010113          	addi	x2,x2,32
    1254:	00008067          	jalr	x0,0(x1)

Disassembly of section .sdata:

00001258 <C>:
    1258:	0001                	c.addi	x0,0
	...

0000125c <B>:
    125c:	0001                	c.addi	x0,0
	...

00001260 <A>:
    1260:	0001                	c.addi	x0,0
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
   0:	0164                	c.addi4spn	x9,x2,140
   2:	0000                	unimp
   4:	0002                	c.slli64	x0
   6:	0045                	c.addi	x0,17
   8:	0000                	unimp
   a:	0101                	c.addi	x2,0
   c:	000d0efb          	0xd0efb
  10:	0101                	c.addi	x2,0
  12:	0101                	c.addi	x2,0
  14:	0000                	unimp
  16:	0100                	c.addi4spn	x8,x2,128
  18:	0000                	unimp
  1a:	2e01                	c.jal	32a <outl-0xcd6>
  1c:	2f2e                	c.fldsp	f30,200(x2)
  1e:	2e2e                	c.fldsp	f28,200(x2)
  20:	2f2e2e2f          	0x2f2e2e2f
  24:	2f2e                	c.fldsp	f30,200(x2)
  26:	6972                	c.flwsp	f18,28(x2)
  28:	2d766373          	csrrsi	x6,0x2d7,12
  2c:	2f636367          	0x2f636367
  30:	696c                	c.flw	f11,84(x10)
  32:	6762                	c.flwsp	f14,24(x2)
  34:	632f6363          	bltu	x30,x18,65a <outl-0x9a6>
  38:	69666e6f          	jal	x28,666ce <__heap_start+0x646ce>
  3c:	69722f67          	0x69722f67
  40:	00766373          	csrrsi	x6,0x7,12
  44:	6400                	c.flw	f8,8(x8)
  46:	7669                	c.lui	x12,0xffffa
  48:	532e                	c.lwsp	x6,232(x2)
  4a:	0100                	c.addi4spn	x8,x2,128
  4c:	0000                	unimp
  4e:	0000                	unimp
  50:	0205                	c.addi	x4,1
  52:	10cc                	c.addi4spn	x11,x2,100
  54:	0000                	unimp
  56:	0100c403          	lbu	x8,16(x1)
  5a:	04090103          	lb	x2,64(x18)
  5e:	0100                	c.addi4spn	x8,x2,128
  60:	04090403          	lb	x8,64(x18)
  64:	0100                	c.addi4spn	x8,x2,128
  66:	04090103          	lb	x2,64(x18)
  6a:	0100                	c.addi4spn	x8,x2,128
  6c:	04090103          	lb	x2,64(x18)
  70:	0100                	c.addi4spn	x8,x2,128
  72:	04090103          	lb	x2,64(x18)
  76:	0100                	c.addi4spn	x8,x2,128
  78:	04090103          	lb	x2,64(x18)
  7c:	0100                	c.addi4spn	x8,x2,128
  7e:	04090103          	lb	x2,64(x18)
  82:	0100                	c.addi4spn	x8,x2,128
  84:	04090203          	lb	x4,64(x18)
  88:	0100                	c.addi4spn	x8,x2,128
  8a:	04090103          	lb	x2,64(x18)
  8e:	0100                	c.addi4spn	x8,x2,128
  90:	04090103          	lb	x2,64(x18)
  94:	0100                	c.addi4spn	x8,x2,128
  96:	04090103          	lb	x2,64(x18)
  9a:	0100                	c.addi4spn	x8,x2,128
  9c:	04090203          	lb	x4,64(x18)
  a0:	0100                	c.addi4spn	x8,x2,128
  a2:	04090203          	lb	x4,64(x18)
  a6:	0100                	c.addi4spn	x8,x2,128
  a8:	04090103          	lb	x2,64(x18)
  ac:	0100                	c.addi4spn	x8,x2,128
  ae:	04090103          	lb	x2,64(x18)
  b2:	0100                	c.addi4spn	x8,x2,128
  b4:	04090203          	lb	x4,64(x18)
  b8:	0100                	c.addi4spn	x8,x2,128
  ba:	04090103          	lb	x2,64(x18)
  be:	0100                	c.addi4spn	x8,x2,128
  c0:	04090103          	lb	x2,64(x18)
  c4:	0100                	c.addi4spn	x8,x2,128
  c6:	04090203          	lb	x4,64(x18)
  ca:	0100                	c.addi4spn	x8,x2,128
  cc:	04090503          	lb	x10,64(x18)
  d0:	0100                	c.addi4spn	x8,x2,128
  d2:	04090103          	lb	x2,64(x18)
  d6:	0100                	c.addi4spn	x8,x2,128
  d8:	04090103          	lb	x2,64(x18)
  dc:	0100                	c.addi4spn	x8,x2,128
  de:	04090103          	lb	x2,64(x18)
  e2:	0100                	c.addi4spn	x8,x2,128
  e4:	04090503          	lb	x10,64(x18)
  e8:	0100                	c.addi4spn	x8,x2,128
  ea:	04090103          	lb	x2,64(x18)
  ee:	0100                	c.addi4spn	x8,x2,128
  f0:	04090103          	lb	x2,64(x18)
  f4:	0100                	c.addi4spn	x8,x2,128
  f6:	04090103          	lb	x2,64(x18)
  fa:	0100                	c.addi4spn	x8,x2,128
  fc:	04090203          	lb	x4,64(x18)
 100:	0100                	c.addi4spn	x8,x2,128
 102:	04090203          	lb	x4,64(x18)
 106:	0100                	c.addi4spn	x8,x2,128
 108:	04090103          	lb	x2,64(x18)
 10c:	0100                	c.addi4spn	x8,x2,128
 10e:	04090103          	lb	x2,64(x18)
 112:	0100                	c.addi4spn	x8,x2,128
 114:	04090103          	lb	x2,64(x18)
 118:	0100                	c.addi4spn	x8,x2,128
 11a:	04090403          	lb	x8,64(x18)
 11e:	0100                	c.addi4spn	x8,x2,128
 120:	04090103          	lb	x2,64(x18)
 124:	0100                	c.addi4spn	x8,x2,128
 126:	04090103          	lb	x2,64(x18)
 12a:	0100                	c.addi4spn	x8,x2,128
 12c:	04090203          	lb	x4,64(x18)
 130:	0100                	c.addi4spn	x8,x2,128
 132:	04090103          	lb	x2,64(x18)
 136:	0100                	c.addi4spn	x8,x2,128
 138:	04090103          	lb	x2,64(x18)
 13c:	0100                	c.addi4spn	x8,x2,128
 13e:	04090203          	lb	x4,64(x18)
 142:	0100                	c.addi4spn	x8,x2,128
 144:	04090103          	lb	x2,64(x18)
 148:	0100                	c.addi4spn	x8,x2,128
 14a:	04090203          	lb	x4,64(x18)
 14e:	0100                	c.addi4spn	x8,x2,128
 150:	04090103          	lb	x2,64(x18)
 154:	0100                	c.addi4spn	x8,x2,128
 156:	04090103          	lb	x2,64(x18)
 15a:	0100                	c.addi4spn	x8,x2,128
 15c:	04090103          	lb	x2,64(x18)
 160:	0100                	c.addi4spn	x8,x2,128
 162:	0409                	c.addi	x8,2
 164:	0000                	unimp
 166:	0101                	c.addi	x2,0

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
  10:	10cc                	c.addi4spn	x11,x2,100
  12:	0000                	unimp
  14:	1180                	c.addi4spn	x8,x2,224
  16:	0000                	unimp
  18:	0000                	unimp
  1a:	0000                	unimp
  1c:	0000002f          	0x2f
  20:	007d                	c.addi	x0,31
  22:	0000                	unimp
  24:	8001                	c.srli64	x8

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
  10:	10cc                	c.addi4spn	x11,x2,100
  12:	0000                	unimp
  14:	00b4                	c.addi4spn	x13,x2,72
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	2e2e                	c.fldsp	f28,200(x2)
   2:	2f2e2e2f          	0x2f2e2e2f
   6:	2e2e                	c.fldsp	f28,200(x2)
   8:	722f2e2f          	0x722f2e2f
   c:	7369                	c.lui	x6,0xffffa
   e:	672d7663          	bgeu	x26,x18,67a <outl-0x986>
  12:	6c2f6363          	bltu	x30,x2,6d8 <outl-0x928>
  16:	6269                	c.lui	x4,0x1a
  18:	2f636367          	0x2f636367
  1c:	666e6f63          	bltu	x28,x6,69a <outl-0x966>
  20:	6769                	c.lui	x14,0x1a
  22:	7369722f          	0x7369722f
  26:	642f7663          	bgeu	x30,x2,672 <outl-0x98e>
  2a:	7669                	c.lui	x12,0xffffa
  2c:	532e                	c.lwsp	x6,232(x2)
  2e:	2f00                	c.fld	f8,24(x14)
  30:	6e6d                	c.lui	x28,0x1b
  32:	2f74                	c.fld	f13,216(x14)
  34:	2f64                	c.fld	f9,216(x14)
  36:	6972                	c.flwsp	f18,28(x2)
  38:	2d766373          	csrrsi	x6,0x2d7,12
  3c:	2d756e67          	0x2d756e67
  40:	6f74                	c.flw	f13,92(x14)
  42:	68636c6f          	jal	x24,366c8 <__heap_start+0x346c8>
  46:	6961                	c.lui	x18,0x18
  48:	2f6e                	c.fldsp	f30,216(x2)
  4a:	7562                	c.flwsp	f10,56(x2)
  4c:	6c69                	c.lui	x24,0x1a
  4e:	2d64                	c.fld	f9,216(x10)
  50:	2d636367          	0x2d636367
  54:	656e                	c.flwsp	f10,216(x2)
  56:	62696c77          	0x62696c77
  5a:	732d                	c.lui	x6,0xfffeb
  5c:	6174                	c.flw	f13,68(x10)
  5e:	2f326567          	0x2f326567
  62:	6972                	c.flwsp	f18,28(x2)
  64:	33766373          	csrrsi	x6,mhpmevent23,12
  68:	2d32                	c.fldsp	f26,264(x2)
  6a:	6e75                	c.lui	x28,0x1d
  6c:	776f6e6b          	0x776f6e6b
  70:	2d6e                	c.fldsp	f26,216(x2)
  72:	6c65                	c.lui	x24,0x19
  74:	2f66                	c.fldsp	f30,88(x2)
  76:	696c                	c.flw	f11,84(x10)
  78:	6762                	c.flwsp	f14,24(x2)
  7a:	47006363          	bltu	x0,x16,4e0 <outl-0xb20>
  7e:	554e                	c.lwsp	x10,240(x2)
  80:	4120                	c.lw	x8,64(x10)
  82:	2e322053          	0x2e322053
  86:	312e3133          	0x312e3133
	...
