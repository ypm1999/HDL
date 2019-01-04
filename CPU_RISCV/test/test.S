
./test/test.om:     file format elf32-littleriscv


Disassembly of section .rom:

00000000 <.rom>:
   0:	00020137          	lui	x2,0x20
   4:	218010ef          	jal	x1,121c <main>
   8:	0ff00513          	addi	x10,x0,255
   c:	000306b7          	lui	x13,0x30
  10:	00a68223          	sb	x10,4(x13) # 30004 <__heap_start+0x2e004>
  14:	ff9ff06f          	jal	x0,c <inl.part.0-0xff4>

Disassembly of section .text:

00001000 <inl.part.0>:
    1000:	00030737          	lui	x14,0x30
    1004:	00a00693          	addi	x13,x0,10
    1008:	02000613          	addi	x12,x0,32
    100c:	00900593          	addi	x11,x0,9
    1010:	0080006f          	jal	x0,1018 <inl.part.0+0x18>
    1014:	06d79c63          	bne	x15,x13,108c <inl.part.0+0x8c>
    1018:	00074783          	lbu	x15,0(x14) # 30000 <__heap_start+0x2e000>
    101c:	0ff7f793          	andi	x15,x15,255
    1020:	fe079ae3          	bne	x15,x0,1014 <inl.part.0+0x14>
    1024:	00000893          	addi	x17,x0,0
    1028:	00000513          	addi	x10,x0,0
    102c:	02d00613          	addi	x12,x0,45
    1030:	00900813          	addi	x16,x0,9
    1034:	000305b7          	lui	x11,0x30
    1038:	0180006f          	jal	x0,1050 <inl.part.0+0x50>
    103c:	04d86463          	bltu	x16,x13,1084 <inl.part.0+0x84>
    1040:	0005c783          	lbu	x15,0(x11) # 30000 <__heap_start+0x2e000>
    1044:	fd070513          	addi	x10,x14,-48
    1048:	0ff7f793          	andi	x15,x15,255
    104c:	02078c63          	beq	x15,x0,1084 <inl.part.0+0x84>
    1050:	00251713          	slli	x14,x10,0x2
    1054:	00a70733          	add	x14,x14,x10
    1058:	00171713          	slli	x14,x14,0x1
    105c:	fd078693          	addi	x13,x15,-48
    1060:	00f70733          	add	x14,x14,x15
    1064:	0ff6f693          	andi	x13,x13,255
    1068:	fcc79ae3          	bne	x15,x12,103c <inl.part.0+0x3c>
    106c:	02089663          	bne	x17,x0,1098 <inl.part.0+0x98>
    1070:	0005c783          	lbu	x15,0(x11)
    1074:	00100893          	addi	x17,x0,1
    1078:	fd070513          	addi	x10,x14,-48
    107c:	0ff7f793          	andi	x15,x15,255
    1080:	fc0798e3          	bne	x15,x0,1050 <inl.part.0+0x50>
    1084:	00089a63          	bne	x17,x0,1098 <inl.part.0+0x98>
    1088:	00008067          	jalr	x0,0(x1)
    108c:	f8c786e3          	beq	x15,x12,1018 <inl.part.0+0x18>
    1090:	f8b784e3          	beq	x15,x11,1018 <inl.part.0+0x18>
    1094:	f91ff06f          	jal	x0,1024 <inl.part.0+0x24>
    1098:	40a00533          	sub	x10,x0,x10
    109c:	00008067          	jalr	x0,0(x1)

000010a0 <tak>:
    10a0:	fe010113          	addi	x2,x2,-32 # 1ffe0 <__heap_start+0x1dfe0>
    10a4:	01212823          	sw	x18,16(x2)
    10a8:	00112e23          	sw	x1,28(x2)
    10ac:	00812c23          	sw	x8,24(x2)
    10b0:	00912a23          	sw	x9,20(x2)
    10b4:	01312623          	sw	x19,12(x2)
    10b8:	01412423          	sw	x20,8(x2)
    10bc:	00060913          	addi	x18,x12,0
    10c0:	08a5d263          	bge	x11,x10,1144 <tak+0xa4>
    10c4:	00050413          	addi	x8,x10,0
    10c8:	00058493          	addi	x9,x11,0
    10cc:	00100993          	addi	x19,x0,1
    10d0:	00090613          	addi	x12,x18,0
    10d4:	00048593          	addi	x11,x9,0
    10d8:	fff40513          	addi	x10,x8,-1
    10dc:	fc5ff0ef          	jal	x1,10a0 <tak>
    10e0:	00040613          	addi	x12,x8,0
    10e4:	00090593          	addi	x11,x18,0
    10e8:	00050a13          	addi	x20,x10,0
    10ec:	fff48513          	addi	x10,x9,-1
    10f0:	fb1ff0ef          	jal	x1,10a0 <tak>
    10f4:	00050793          	addi	x15,x10,0
    10f8:	00048613          	addi	x12,x9,0
    10fc:	00040593          	addi	x11,x8,0
    1100:	fff90513          	addi	x10,x18,-1
    1104:	00078493          	addi	x9,x15,0
    1108:	f99ff0ef          	jal	x1,10a0 <tak>
    110c:	00050913          	addi	x18,x10,0
    1110:	000a0413          	addi	x8,x20,0
    1114:	00098513          	addi	x10,x19,0
    1118:	00198993          	addi	x19,x19,1
    111c:	fb44cae3          	blt	x9,x20,10d0 <tak+0x30>
    1120:	01c12083          	lw	x1,28(x2)
    1124:	01812403          	lw	x8,24(x2)
    1128:	00a90533          	add	x10,x18,x10
    112c:	01412483          	lw	x9,20(x2)
    1130:	01012903          	lw	x18,16(x2)
    1134:	00c12983          	lw	x19,12(x2)
    1138:	00812a03          	lw	x20,8(x2)
    113c:	02010113          	addi	x2,x2,32
    1140:	00008067          	jalr	x0,0(x1)
    1144:	01c12083          	lw	x1,28(x2)
    1148:	01812403          	lw	x8,24(x2)
    114c:	01412483          	lw	x9,20(x2)
    1150:	01012903          	lw	x18,16(x2)
    1154:	00c12983          	lw	x19,12(x2)
    1158:	00812a03          	lw	x20,8(x2)
    115c:	00060513          	addi	x10,x12,0
    1160:	02010113          	addi	x2,x2,32
    1164:	00008067          	jalr	x0,0(x1)

00001168 <__divsi3>:
    1168:	06054063          	blt	x10,x0,11c8 <__umodsi3+0x10>
    116c:	0605c663          	blt	x11,x0,11d8 <__umodsi3+0x20>

00001170 <__udivsi3>:
    1170:	00058613          	addi	x12,x11,0
    1174:	00050593          	addi	x11,x10,0
    1178:	fff00513          	addi	x10,x0,-1
    117c:	02060c63          	beq	x12,x0,11b4 <__udivsi3+0x44>
    1180:	00100693          	addi	x13,x0,1
    1184:	00b67a63          	bgeu	x12,x11,1198 <__udivsi3+0x28>
    1188:	00c05863          	bge	x0,x12,1198 <__udivsi3+0x28>
    118c:	00161613          	slli	x12,x12,0x1
    1190:	00169693          	slli	x13,x13,0x1
    1194:	feb66ae3          	bltu	x12,x11,1188 <__udivsi3+0x18>
    1198:	00000513          	addi	x10,x0,0
    119c:	00c5e663          	bltu	x11,x12,11a8 <__udivsi3+0x38>
    11a0:	40c585b3          	sub	x11,x11,x12
    11a4:	00d56533          	or	x10,x10,x13
    11a8:	0016d693          	srli	x13,x13,0x1
    11ac:	00165613          	srli	x12,x12,0x1
    11b0:	fe0696e3          	bne	x13,x0,119c <__udivsi3+0x2c>
    11b4:	00008067          	jalr	x0,0(x1)

000011b8 <__umodsi3>:
    11b8:	00008293          	addi	x5,x1,0
    11bc:	fb5ff0ef          	jal	x1,1170 <__udivsi3>
    11c0:	00058513          	addi	x10,x11,0
    11c4:	00028067          	jalr	x0,0(x5)
    11c8:	40a00533          	sub	x10,x0,x10
    11cc:	0005d863          	bge	x11,x0,11dc <__umodsi3+0x24>
    11d0:	40b005b3          	sub	x11,x0,x11
    11d4:	f9dff06f          	jal	x0,1170 <__udivsi3>
    11d8:	40b005b3          	sub	x11,x0,x11
    11dc:	00008293          	addi	x5,x1,0
    11e0:	f91ff0ef          	jal	x1,1170 <__udivsi3>
    11e4:	40a00533          	sub	x10,x0,x10
    11e8:	00028067          	jalr	x0,0(x5)

000011ec <__modsi3>:
    11ec:	00008293          	addi	x5,x1,0
    11f0:	0005ca63          	blt	x11,x0,1204 <__modsi3+0x18>
    11f4:	00054c63          	blt	x10,x0,120c <__modsi3+0x20>
    11f8:	f79ff0ef          	jal	x1,1170 <__udivsi3>
    11fc:	00058513          	addi	x10,x11,0
    1200:	00028067          	jalr	x0,0(x5)
    1204:	40b005b3          	sub	x11,x0,x11
    1208:	fe0558e3          	bge	x10,x0,11f8 <__modsi3+0xc>
    120c:	40a00533          	sub	x10,x0,x10
    1210:	f61ff0ef          	jal	x1,1170 <__udivsi3>
    1214:	40b00533          	sub	x10,x0,x11
    1218:	00028067          	jalr	x0,0(x5)

Disassembly of section .text.startup:

0000121c <main>:
    121c:	fd010113          	addi	x2,x2,-48
    1220:	02112623          	sw	x1,44(x2)
    1224:	02812423          	sw	x8,40(x2)
    1228:	02912223          	sw	x9,36(x2)
    122c:	01412c23          	sw	x20,24(x2)
    1230:	03212023          	sw	x18,32(x2)
    1234:	01312e23          	sw	x19,28(x2)
    1238:	01512a23          	sw	x21,20(x2)
    123c:	dc5ff0ef          	jal	x1,1000 <inl.part.0>
    1240:	00050413          	addi	x8,x10,0
    1244:	dbdff0ef          	jal	x1,1000 <inl.part.0>
    1248:	00050493          	addi	x9,x10,0
    124c:	db5ff0ef          	jal	x1,1000 <inl.part.0>
    1250:	00050613          	addi	x12,x10,0
    1254:	00048593          	addi	x11,x9,0
    1258:	00040513          	addi	x10,x8,0
    125c:	e45ff0ef          	jal	x1,10a0 <tak>
    1260:	00050493          	addi	x9,x10,0
    1264:	00000a13          	addi	x20,x0,0
    1268:	00055663          	bge	x10,x0,1274 <main+0x58>
    126c:	40a004b3          	sub	x9,x0,x10
    1270:	00100a13          	addi	x20,x0,1
    1274:	00000993          	addi	x19,x0,0
    1278:	00410913          	addi	x18,x2,4
    127c:	00900a93          	addi	x21,x0,9
    1280:	00c0006f          	jal	x0,128c <main+0x70>
    1284:	00040993          	addi	x19,x8,0
    1288:	00050493          	addi	x9,x10,0
    128c:	00a00593          	addi	x11,x0,10
    1290:	00048513          	addi	x10,x9,0
    1294:	f59ff0ef          	jal	x1,11ec <__modsi3>
    1298:	00198413          	addi	x8,x19,1
    129c:	03050713          	addi	x14,x10,48
    12a0:	008907b3          	add	x15,x18,x8
    12a4:	00048513          	addi	x10,x9,0
    12a8:	00a00593          	addi	x11,x0,10
    12ac:	fee78fa3          	sb	x14,-1(x15)
    12b0:	eb9ff0ef          	jal	x1,1168 <__divsi3>
    12b4:	fc9ac8e3          	blt	x21,x9,1284 <main+0x68>
    12b8:	000a0c63          	beq	x20,x0,12d0 <main+0xb4>
    12bc:	01010793          	addi	x15,x2,16
    12c0:	00878433          	add	x8,x15,x8
    12c4:	02d00793          	addi	x15,x0,45
    12c8:	fef40a23          	sb	x15,-12(x8)
    12cc:	00298413          	addi	x8,x19,2
    12d0:	00890433          	add	x8,x18,x8
    12d4:	000307b7          	lui	x15,0x30
    12d8:	fff44703          	lbu	x14,-1(x8)
    12dc:	fff40413          	addi	x8,x8,-1
    12e0:	00e78023          	sb	x14,0(x15) # 30000 <__heap_start+0x2e000>
    12e4:	fe891ae3          	bne	x18,x8,12d8 <main+0xbc>
    12e8:	00a00713          	addi	x14,x0,10
    12ec:	00e78023          	sb	x14,0(x15)
    12f0:	02c12083          	lw	x1,44(x2)
    12f4:	02812403          	lw	x8,40(x2)
    12f8:	02412483          	lw	x9,36(x2)
    12fc:	02012903          	lw	x18,32(x2)
    1300:	01c12983          	lw	x19,28(x2)
    1304:	01812a03          	lw	x20,24(x2)
    1308:	01412a83          	lw	x21,20(x2)
    130c:	00000513          	addi	x10,x0,0
    1310:	03010113          	addi	x2,x2,48
    1314:	00008067          	jalr	x0,0(x1)

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
  1a:	2e01                	c.jal	32a <inl.part.0-0xcd6>
  1c:	2f2e                	c.fldsp	f30,200(x2)
  1e:	2e2e                	c.fldsp	f28,200(x2)
  20:	2f2e2e2f          	0x2f2e2e2f
  24:	2f2e                	c.fldsp	f30,200(x2)
  26:	6972                	c.flwsp	f18,28(x2)
  28:	2d766373          	csrrsi	x6,0x2d7,12
  2c:	2f636367          	0x2f636367
  30:	696c                	c.flw	f11,84(x10)
  32:	6762                	c.flwsp	f14,24(x2)
  34:	632f6363          	bltu	x30,x18,65a <inl.part.0-0x9a6>
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
  52:	1168                	c.addi4spn	x10,x2,172
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
  10:	1168                	c.addi4spn	x10,x2,172
  12:	0000                	unimp
  14:	121c                	c.addi4spn	x15,x2,288
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
  10:	1168                	c.addi4spn	x10,x2,172
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
   e:	672d7663          	bgeu	x26,x18,67a <inl.part.0-0x986>
  12:	6c2f6363          	bltu	x30,x2,6d8 <inl.part.0-0x928>
  16:	6269                	c.lui	x4,0x1a
  18:	2f636367          	0x2f636367
  1c:	666e6f63          	bltu	x28,x6,69a <inl.part.0-0x966>
  20:	6769                	c.lui	x14,0x1a
  22:	7369722f          	0x7369722f
  26:	642f7663          	bgeu	x30,x2,672 <inl.part.0-0x98e>
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
  7a:	47006363          	bltu	x0,x16,4e0 <inl.part.0-0xb20>
  7e:	554e                	c.lwsp	x10,240(x2)
  80:	4120                	c.lw	x8,64(x10)
  82:	2e322053          	0x2e322053
  86:	312e3133          	0x312e3133
	...
