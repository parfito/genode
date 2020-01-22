
munich:     file format elf32-i386


Disassembly of section .text:

00018000 <__mbheader>:
   18000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
   18006:	00 00                	add    %al,(%eax)
   18008:	fe 4f 52             	decb   0x52(%edi)
   1800b:	e4 8d                	in     $0x8d,%al

0001800c <__start>:
	.long   0x1BADB002              /* magic */
	.long   0x00000000              /* feature flags */
	.long   0 - 0x1BADB002

FUNCTION __start
	leal    _stack,%esp
   1800c:	8d 25 c0 8d 01 00    	lea    0x18dc0,%esp
	xchg    %eax,%edx
   18012:	92                   	xchg   %eax,%edx
	xchg    %ebx,%eax
   18013:	93                   	xchg   %eax,%ebx
	pushl	%eax
   18014:	50                   	push   %eax
	pushl   $__exit
   18015:	68 2f 81 01 00       	push   $0x1812f
	jmp     __main
   1801a:	e9 7b 09 00 00       	jmp    1899a <__main>

0001801f <reboot>:


FUNCTION reboot
	mov	$0x4, %al
   1801f:	b0 04                	mov    $0x4,%al
	outb	%al, $0x60
   18021:	e6 60                	out    %al,$0x60
	mov	$0xFE, %al
   18023:	b0 fe                	mov    $0xfe,%al
	outb	%al, $0x64
   18025:	e6 64                	out    %al,$0x64
	lidt    dummy_idt_desc
   18027:	0f 01 1d b8 8b 01 00 	lidtl  0x18bb8
	ud2
   1802e:	0f 0b                	ud2    

00018030 <inb>:


static inline
unsigned char
inb(const unsigned short port)
{
   18030:	83 ec 14             	sub    $0x14,%esp
   18033:	66 89 04 24          	mov    %ax,(%esp)
  unsigned char res;
  asm volatile("inb %1, %0" : "=a"(res): "Nd"(port));
   18037:	0f b7 04 24          	movzwl (%esp),%eax
   1803b:	89 c2                	mov    %eax,%edx
   1803d:	ec                   	in     (%dx),%al
   1803e:	88 44 24 13          	mov    %al,0x13(%esp)
  return res;
   18042:	0f b6 44 24 13       	movzbl 0x13(%esp),%eax
}
   18047:	83 c4 14             	add    $0x14,%esp
   1804a:	c3                   	ret    

0001804b <outb>:


static inline
void
outb(const unsigned short port, unsigned char value)
{
   1804b:	83 ec 08             	sub    $0x8,%esp
   1804e:	89 c1                	mov    %eax,%ecx
   18050:	89 d0                	mov    %edx,%eax
   18052:	66 89 4c 24 04       	mov    %cx,0x4(%esp)
   18057:	88 04 24             	mov    %al,(%esp)
  asm volatile("outb %0,%1" :: "a"(value),"Nd"(port));
   1805a:	0f b6 04 24          	movzbl (%esp),%eax
   1805e:	0f b7 54 24 04       	movzwl 0x4(%esp),%edx
   18063:	ee                   	out    %al,(%dx)
}
   18064:	83 c4 08             	add    $0x8,%esp
   18067:	c3                   	ret    

00018068 <bsr>:


static inline
unsigned
bsr(unsigned int value)
{
   18068:	83 ec 14             	sub    $0x14,%esp
   1806b:	89 04 24             	mov    %eax,(%esp)
  unsigned res;
  asm volatile("bsr %1,%0" : "=r"(res): "r"(value));
   1806e:	8b 04 24             	mov    (%esp),%eax
   18071:	0f bd c0             	bsr    %eax,%eax
   18074:	89 44 24 10          	mov    %eax,0x10(%esp)
  return res;
   18078:	8b 44 24 10          	mov    0x10(%esp),%eax
}
   1807c:	83 c4 14             	add    $0x14,%esp
   1807f:	c3                   	ret    

00018080 <wait>:
 *
 * We use the PIT for this.
 */
void
wait(int ms)
{
   18080:	83 ec 14             	sub    $0x14,%esp
   18083:	89 04 24             	mov    %eax,(%esp)
  /* the PIT counts with 1.193 Mhz */
  ms*=1193;
   18086:	8b 04 24             	mov    (%esp),%eax
   18089:	69 c0 a9 04 00 00    	imul   $0x4a9,%eax,%eax
   1808f:	89 04 24             	mov    %eax,(%esp)

  /* initalize the PIT, let counter0 count from 256 backwards */
  outb(0x43, 0x34);
   18092:	ba 34 00 00 00       	mov    $0x34,%edx
   18097:	b8 43 00 00 00       	mov    $0x43,%eax
   1809c:	e8 aa ff ff ff       	call   1804b <outb>
  outb(0x40, 0);
   180a1:	ba 00 00 00 00       	mov    $0x0,%edx
   180a6:	b8 40 00 00 00       	mov    $0x40,%eax
   180ab:	e8 9b ff ff ff       	call   1804b <outb>
  outb(0x40, 0);
   180b0:	ba 00 00 00 00       	mov    $0x0,%edx
   180b5:	b8 40 00 00 00       	mov    $0x40,%eax
   180ba:	e8 8c ff ff ff       	call   1804b <outb>

  unsigned short state;
  unsigned short old = 0;
   180bf:	66 c7 44 24 12 00 00 	movw   $0x0,0x12(%esp)
  while (ms>0)
   180c6:	eb 5d                	jmp    18125 <wait+0xa5>
    {
      outb(0x43, 0);
   180c8:	ba 00 00 00 00       	mov    $0x0,%edx
   180cd:	b8 43 00 00 00       	mov    $0x43,%eax
   180d2:	e8 74 ff ff ff       	call   1804b <outb>
      state = inb(0x40);
   180d7:	b8 40 00 00 00       	mov    $0x40,%eax
   180dc:	e8 4f ff ff ff       	call   18030 <inb>
   180e1:	0f b6 c0             	movzbl %al,%eax
   180e4:	66 89 44 24 10       	mov    %ax,0x10(%esp)
      state |= inb(0x40) << 8;
   180e9:	b8 40 00 00 00       	mov    $0x40,%eax
   180ee:	e8 3d ff ff ff       	call   18030 <inb>
   180f3:	0f b6 c0             	movzbl %al,%eax
   180f6:	c1 e0 08             	shl    $0x8,%eax
   180f9:	89 c2                	mov    %eax,%edx
   180fb:	0f b7 44 24 10       	movzwl 0x10(%esp),%eax
   18100:	09 d0                	or     %edx,%eax
   18102:	66 89 44 24 10       	mov    %ax,0x10(%esp)
      ms -= (unsigned short)(old - state);
   18107:	0f b7 44 24 10       	movzwl 0x10(%esp),%eax
   1810c:	0f b7 54 24 12       	movzwl 0x12(%esp),%edx
   18111:	29 c2                	sub    %eax,%edx
   18113:	89 d0                	mov    %edx,%eax
   18115:	0f b7 c0             	movzwl %ax,%eax
   18118:	29 04 24             	sub    %eax,(%esp)
      old = state;
   1811b:	0f b7 44 24 10       	movzwl 0x10(%esp),%eax
   18120:	66 89 44 24 12       	mov    %ax,0x12(%esp)
  outb(0x40, 0);
  outb(0x40, 0);

  unsigned short state;
  unsigned short old = 0;
  while (ms>0)
   18125:	83 3c 24 00          	cmpl   $0x0,(%esp)
   18129:	7f 9d                	jg     180c8 <wait+0x48>
      state = inb(0x40);
      state |= inb(0x40) << 8;
      ms -= (unsigned short)(old - state);
      old = state;
    }
}
   1812b:	83 c4 14             	add    $0x14,%esp
   1812e:	c3                   	ret    

0001812f <__exit>:
/**
 * Print the exit status and reboot the machine.
 */
void
__exit(unsigned status)
{
   1812f:	83 ec 2c             	sub    $0x2c,%esp
   18132:	89 44 24 0c          	mov    %eax,0xc(%esp)
  out_char('\n');
   18136:	b8 0a 00 00 00       	mov    $0xa,%eax
   1813b:	e8 17 01 00 00       	call   18257 <out_char>
  out_description("exit()", status);
   18140:	8b 44 24 0c          	mov    0xc(%esp),%eax
   18144:	89 c2                	mov    %eax,%edx
   18146:	b8 03 8a 01 00       	mov    $0x18a03,%eax
   1814b:	e8 a6 02 00 00       	call   183f6 <out_description>
  for (unsigned i=0; i<16;i++)
   18150:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
   18157:	00 
   18158:	eb 19                	jmp    18173 <__exit+0x44>
    {
      wait(1000);
   1815a:	b8 e8 03 00 00       	mov    $0x3e8,%eax
   1815f:	e8 1c ff ff ff       	call   18080 <wait>
      out_char('.');
   18164:	b8 2e 00 00 00       	mov    $0x2e,%eax
   18169:	e8 e9 00 00 00       	call   18257 <out_char>
void
__exit(unsigned status)
{
  out_char('\n');
  out_description("exit()", status);
  for (unsigned i=0; i<16;i++)
   1816e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
   18173:	83 7c 24 1c 0f       	cmpl   $0xf,0x1c(%esp)
   18178:	76 e0                	jbe    1815a <__exit+0x2b>
    {
      wait(1000);
      out_char('.');
    }
  out_string("-> OK, reboot now!\n");
   1817a:	b8 0a 8a 01 00       	mov    $0x18a0a,%eax
   1817f:	e8 df 01 00 00       	call   18363 <out_string>
  reboot();
   18184:	e8 96 fe ff ff       	call   1801f <reboot>

00018189 <serial_init>:
#define SERIAL_BASE 0x3f8

void
serial_init()
{
  serial_initialized = 1;
   18189:	c7 05 c0 8d 01 00 01 	movl   $0x1,0x18dc0
   18190:	00 00 00 
  // enable DLAB and set baudrate 115200
  outb(SERIAL_BASE+0x3, 0x80);
   18193:	ba 80 00 00 00       	mov    $0x80,%edx
   18198:	b8 fb 03 00 00       	mov    $0x3fb,%eax
   1819d:	e8 a9 fe ff ff       	call   1804b <outb>
  outb(SERIAL_BASE+0x0, 0x01);
   181a2:	ba 01 00 00 00       	mov    $0x1,%edx
   181a7:	b8 f8 03 00 00       	mov    $0x3f8,%eax
   181ac:	e8 9a fe ff ff       	call   1804b <outb>
  outb(SERIAL_BASE+0x1, 0x00);
   181b1:	ba 00 00 00 00       	mov    $0x0,%edx
   181b6:	b8 f9 03 00 00       	mov    $0x3f9,%eax
   181bb:	e8 8b fe ff ff       	call   1804b <outb>
  // disable DLAB and set 8N1
  outb(SERIAL_BASE+0x3, 0x03);
   181c0:	ba 03 00 00 00       	mov    $0x3,%edx
   181c5:	b8 fb 03 00 00       	mov    $0x3fb,%eax
   181ca:	e8 7c fe ff ff       	call   1804b <outb>
  // reset IRQ register
  outb(SERIAL_BASE+0x1, 0x00);
   181cf:	ba 00 00 00 00       	mov    $0x0,%edx
   181d4:	b8 f9 03 00 00       	mov    $0x3f9,%eax
   181d9:	e8 6d fe ff ff       	call   1804b <outb>
  // enable fifo, flush buffer, enable fifo
  outb(SERIAL_BASE+0x2, 0x01);
   181de:	ba 01 00 00 00       	mov    $0x1,%edx
   181e3:	b8 fa 03 00 00       	mov    $0x3fa,%eax
   181e8:	e8 5e fe ff ff       	call   1804b <outb>
  outb(SERIAL_BASE+0x2, 0x07);
   181ed:	ba 07 00 00 00       	mov    $0x7,%edx
   181f2:	b8 fa 03 00 00       	mov    $0x3fa,%eax
   181f7:	e8 4f fe ff ff       	call   1804b <outb>
  outb(SERIAL_BASE+0x2, 0x01);
   181fc:	ba 01 00 00 00       	mov    $0x1,%edx
   18201:	b8 fa 03 00 00       	mov    $0x3fa,%eax
   18206:	e8 40 fe ff ff       	call   1804b <outb>
  // set RTS,DTR
  outb(SERIAL_BASE+0x4, 0x03);
   1820b:	ba 03 00 00 00       	mov    $0x3,%edx
   18210:	b8 fc 03 00 00       	mov    $0x3fc,%eax
   18215:	e8 31 fe ff ff       	call   1804b <outb>
}
   1821a:	c3                   	ret    

0001821b <serial_send>:


static
void
serial_send(unsigned value)
{
   1821b:	83 ec 04             	sub    $0x4,%esp
   1821e:	89 04 24             	mov    %eax,(%esp)
  if (!serial_initialized)
   18221:	a1 c0 8d 01 00       	mov    0x18dc0,%eax
   18226:	85 c0                	test   %eax,%eax
   18228:	75 02                	jne    1822c <serial_send+0x11>
    return;
   1822a:	eb 27                	jmp    18253 <serial_send+0x38>

  while (!(inb(SERIAL_BASE+0x5) & 0x20))
   1822c:	90                   	nop
   1822d:	b8 fd 03 00 00       	mov    $0x3fd,%eax
   18232:	e8 f9 fd ff ff       	call   18030 <inb>
   18237:	0f b6 c0             	movzbl %al,%eax
   1823a:	83 e0 20             	and    $0x20,%eax
   1823d:	85 c0                	test   %eax,%eax
   1823f:	74 ec                	je     1822d <serial_send+0x12>
    ;
  outb(SERIAL_BASE, value);
   18241:	8b 04 24             	mov    (%esp),%eax
   18244:	0f b6 c0             	movzbl %al,%eax
   18247:	89 c2                	mov    %eax,%edx
   18249:	b8 f8 03 00 00       	mov    $0x3f8,%eax
   1824e:	e8 f8 fd ff ff       	call   1804b <outb>
}
   18253:	83 c4 04             	add    $0x4,%esp
   18256:	c3                   	ret    

00018257 <out_char>:
 * Output a single char.
 * Note: We allow only to put a char on the last line.
 */
int
out_char(unsigned value)
{
   18257:	57                   	push   %edi
   18258:	56                   	push   %esi
   18259:	53                   	push   %ebx
   1825a:	83 ec 14             	sub    $0x14,%esp
   1825d:	89 04 24             	mov    %eax,(%esp)
#define BASE(ROW) ((unsigned short *) (0xb8000+ROW*160))
  static unsigned int col;
  if (value!='\n')
   18260:	83 3c 24 0a          	cmpl   $0xa,(%esp)
   18264:	74 2e                	je     18294 <out_char+0x3d>
    {
      unsigned short *p = BASE(24)+col;
   18266:	a1 c4 8d 01 00       	mov    0x18dc4,%eax
   1826b:	01 c0                	add    %eax,%eax
   1826d:	05 00 8f 0b 00       	add    $0xb8f00,%eax
   18272:	89 44 24 10          	mov    %eax,0x10(%esp)
      *p = 0x0f00 | value;
   18276:	8b 04 24             	mov    (%esp),%eax
   18279:	80 cc 0f             	or     $0xf,%ah
   1827c:	89 c2                	mov    %eax,%edx
   1827e:	8b 44 24 10          	mov    0x10(%esp),%eax
   18282:	66 89 10             	mov    %dx,(%eax)
      col++;
   18285:	a1 c4 8d 01 00       	mov    0x18dc4,%eax
   1828a:	83 c0 01             	add    $0x1,%eax
   1828d:	a3 c4 8d 01 00       	mov    %eax,0x18dc4
   18292:	eb 0a                	jmp    1829e <out_char+0x47>
    }
#ifndef NDEBUG
  else
    serial_send('\r');
   18294:	b8 0d 00 00 00       	mov    $0xd,%eax
   18299:	e8 7d ff ff ff       	call   1821b <serial_send>
#endif

  if (col>=80 || value == '\n')
   1829e:	a1 c4 8d 01 00       	mov    0x18dc4,%eax
   182a3:	83 f8 4f             	cmp    $0x4f,%eax
   182a6:	77 0a                	ja     182b2 <out_char+0x5b>
   182a8:	83 3c 24 0a          	cmpl   $0xa,(%esp)
   182ac:	0f 85 9f 00 00 00    	jne    18351 <out_char+0xfa>
    {
      col=0;
   182b2:	c7 05 c4 8d 01 00 00 	movl   $0x0,0x18dc4
   182b9:	00 00 00 
      unsigned short *p=BASE(0);
   182bc:	c7 44 24 0c 00 80 0b 	movl   $0xb8000,0xc(%esp)
   182c3:	00 
      memcpy(p, p+80, 24*160);
   182c4:	8b 44 24 0c          	mov    0xc(%esp),%eax
   182c8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
   182ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
   182d2:	bb 00 0f 00 00       	mov    $0xf00,%ebx
   182d7:	89 c1                	mov    %eax,%ecx
   182d9:	83 e1 01             	and    $0x1,%ecx
   182dc:	85 c9                	test   %ecx,%ecx
   182de:	74 0e                	je     182ee <out_char+0x97>
   182e0:	0f b6 0a             	movzbl (%edx),%ecx
   182e3:	88 08                	mov    %cl,(%eax)
   182e5:	83 c0 01             	add    $0x1,%eax
   182e8:	83 c2 01             	add    $0x1,%edx
   182eb:	83 eb 01             	sub    $0x1,%ebx
   182ee:	89 c1                	mov    %eax,%ecx
   182f0:	83 e1 02             	and    $0x2,%ecx
   182f3:	85 c9                	test   %ecx,%ecx
   182f5:	74 0f                	je     18306 <out_char+0xaf>
   182f7:	0f b7 0a             	movzwl (%edx),%ecx
   182fa:	66 89 08             	mov    %cx,(%eax)
   182fd:	83 c0 02             	add    $0x2,%eax
   18300:	83 c2 02             	add    $0x2,%edx
   18303:	83 eb 02             	sub    $0x2,%ebx
   18306:	89 d9                	mov    %ebx,%ecx
   18308:	c1 e9 02             	shr    $0x2,%ecx
   1830b:	89 c7                	mov    %eax,%edi
   1830d:	89 d6                	mov    %edx,%esi
   1830f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
   18311:	89 f2                	mov    %esi,%edx
   18313:	89 f8                	mov    %edi,%eax
   18315:	b9 00 00 00 00       	mov    $0x0,%ecx
   1831a:	89 de                	mov    %ebx,%esi
   1831c:	83 e6 02             	and    $0x2,%esi
   1831f:	85 f6                	test   %esi,%esi
   18321:	74 0b                	je     1832e <out_char+0xd7>
   18323:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
   18327:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
   1832b:	83 c1 02             	add    $0x2,%ecx
   1832e:	83 e3 01             	and    $0x1,%ebx
   18331:	85 db                	test   %ebx,%ebx
   18333:	74 07                	je     1833c <out_char+0xe5>
   18335:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
   18339:	88 14 08             	mov    %dl,(%eax,%ecx,1)
      memset(BASE(24), 0, 160);
   1833c:	bb 00 8f 0b 00       	mov    $0xb8f00,%ebx
   18341:	b8 00 00 00 00       	mov    $0x0,%eax
   18346:	ba 28 00 00 00       	mov    $0x28,%edx
   1834b:	89 df                	mov    %ebx,%edi
   1834d:	89 d1                	mov    %edx,%ecx
   1834f:	f3 ab                	rep stos %eax,%es:(%edi)
    }

#ifndef NDEBUG
  serial_send(value);
   18351:	8b 04 24             	mov    (%esp),%eax
   18354:	e8 c2 fe ff ff       	call   1821b <serial_send>
#endif

  return value;
   18359:	8b 04 24             	mov    (%esp),%eax
}
   1835c:	83 c4 14             	add    $0x14,%esp
   1835f:	5b                   	pop    %ebx
   18360:	5e                   	pop    %esi
   18361:	5f                   	pop    %edi
   18362:	c3                   	ret    

00018363 <out_string>:
/**
 * Output a string.
 */
void
out_string(const char *value)
{
   18363:	83 ec 04             	sub    $0x4,%esp
   18366:	89 04 24             	mov    %eax,(%esp)
  for(; *value; value++)
   18369:	eb 12                	jmp    1837d <out_string+0x1a>
    out_char(*value);
   1836b:	8b 04 24             	mov    (%esp),%eax
   1836e:	0f b6 00             	movzbl (%eax),%eax
   18371:	0f be c0             	movsbl %al,%eax
   18374:	e8 de fe ff ff       	call   18257 <out_char>
 * Output a string.
 */
void
out_string(const char *value)
{
  for(; *value; value++)
   18379:	83 04 24 01          	addl   $0x1,(%esp)
   1837d:	8b 04 24             	mov    (%esp),%eax
   18380:	0f b6 00             	movzbl (%eax),%eax
   18383:	84 c0                	test   %al,%al
   18385:	75 e4                	jne    1836b <out_string+0x8>
    out_char(*value);
}
   18387:	83 c4 04             	add    $0x4,%esp
   1838a:	c3                   	ret    

0001838b <out_hex>:
/**
 * Output a single hex value.
 */
void
out_hex(unsigned value, unsigned bitlen)
{
   1838b:	83 ec 18             	sub    $0x18,%esp
   1838e:	89 44 24 04          	mov    %eax,0x4(%esp)
   18392:	89 14 24             	mov    %edx,(%esp)
  int i;
  for (i=bsr(value | 1<<bitlen) &0xfc; i>=0; i-=4)
   18395:	8b 04 24             	mov    (%esp),%eax
   18398:	ba 01 00 00 00       	mov    $0x1,%edx
   1839d:	89 c1                	mov    %eax,%ecx
   1839f:	d3 e2                	shl    %cl,%edx
   183a1:	89 d0                	mov    %edx,%eax
   183a3:	0b 44 24 04          	or     0x4(%esp),%eax
   183a7:	e8 bc fc ff ff       	call   18068 <bsr>
   183ac:	25 fc 00 00 00       	and    $0xfc,%eax
   183b1:	89 44 24 14          	mov    %eax,0x14(%esp)
   183b5:	eb 34                	jmp    183eb <out_hex+0x60>
    {
      unsigned a = (value >> i) & 0xf;
   183b7:	8b 44 24 14          	mov    0x14(%esp),%eax
   183bb:	8b 54 24 04          	mov    0x4(%esp),%edx
   183bf:	89 c1                	mov    %eax,%ecx
   183c1:	d3 ea                	shr    %cl,%edx
   183c3:	89 d0                	mov    %edx,%eax
   183c5:	83 e0 0f             	and    $0xf,%eax
   183c8:	89 44 24 10          	mov    %eax,0x10(%esp)
      if (a>=10)
   183cc:	83 7c 24 10 09       	cmpl   $0x9,0x10(%esp)
   183d1:	76 05                	jbe    183d8 <out_hex+0x4d>
	a += 7;
   183d3:	83 44 24 10 07       	addl   $0x7,0x10(%esp)
      a+=0x30;
   183d8:	83 44 24 10 30       	addl   $0x30,0x10(%esp)

      out_char(a);
   183dd:	8b 44 24 10          	mov    0x10(%esp),%eax
   183e1:	e8 71 fe ff ff       	call   18257 <out_char>
 */
void
out_hex(unsigned value, unsigned bitlen)
{
  int i;
  for (i=bsr(value | 1<<bitlen) &0xfc; i>=0; i-=4)
   183e6:	83 6c 24 14 04       	subl   $0x4,0x14(%esp)
   183eb:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
   183f0:	79 c5                	jns    183b7 <out_hex+0x2c>
	a += 7;
      a+=0x30;

      out_char(a);
    }
}
   183f2:	83 c4 18             	add    $0x18,%esp
   183f5:	c3                   	ret    

000183f6 <out_description>:
 * Output a string followed by a single hex value, prefixed with a
 * message label.
 */
void
out_description(const char *prefix, unsigned int value)
{
   183f6:	83 ec 08             	sub    $0x8,%esp
   183f9:	89 44 24 04          	mov    %eax,0x4(%esp)
   183fd:	89 14 24             	mov    %edx,(%esp)
  out_string(message_label);
   18400:	a1 b4 8b 01 00       	mov    0x18bb4,%eax
   18405:	e8 59 ff ff ff       	call   18363 <out_string>
  out_string(prefix);
   1840a:	8b 44 24 04          	mov    0x4(%esp),%eax
   1840e:	e8 50 ff ff ff       	call   18363 <out_string>
  out_char(' ');
   18413:	b8 20 00 00 00       	mov    $0x20,%eax
   18418:	e8 3a fe ff ff       	call   18257 <out_char>
  out_hex(value, 0);
   1841d:	8b 04 24             	mov    (%esp),%eax
   18420:	ba 00 00 00 00       	mov    $0x0,%edx
   18425:	e8 61 ff ff ff       	call   1838b <out_hex>
  out_char('\n');
   1842a:	b8 0a 00 00 00       	mov    $0xa,%eax
   1842f:	e8 23 fe ff ff       	call   18257 <out_char>
}
   18434:	83 c4 08             	add    $0x8,%esp
   18437:	c3                   	ret    

00018438 <out_info>:
/**
 * Output a string, prefixed with a message label.
 */
void
out_info(const char *msg)
{
   18438:	83 ec 04             	sub    $0x4,%esp
   1843b:	89 04 24             	mov    %eax,(%esp)
  out_string(message_label);
   1843e:	a1 b4 8b 01 00       	mov    0x18bb4,%eax
   18443:	e8 1b ff ff ff       	call   18363 <out_string>
  out_string(msg);
   18448:	8b 04 24             	mov    (%esp),%eax
   1844b:	e8 13 ff ff ff       	call   18363 <out_string>
  out_char('\n');
   18450:	b8 0a 00 00 00       	mov    $0xa,%eax
   18455:	e8 fd fd ff ff       	call   18257 <out_char>
}
   1845a:	83 c4 04             	add    $0x4,%esp
   1845d:	c3                   	ret    

0001845e <jmp_kernel>:
/**
 * Setup stack, disable protection mode and jump to the linux bootstrap code via lret.
 */
FUNCTION jmp_kernel
	// assemble stack frame
	xor    %ecx, %ecx
   1845e:	31 c9                	xor    %ecx,%ecx
	mov    %edx, %esp
   18460:	89 d4                	mov    %edx,%esp
	push   %eax
   18462:	50                   	push   %eax
	push   %ecx
   18463:	51                   	push   %ecx

	// fix stack pointer
	mov    %esp, %edx
   18464:	89 e2                	mov    %esp,%edx
	movzx  %dx, %esp
   18466:	0f b7 e2             	movzwl %dx,%esp
	xor    %dx, %dx
   18469:	66 31 d2             	xor    %dx,%dx
	shr    $0x4, %edx
   1846c:	c1 ea 04             	shr    $0x4,%edx

	// load cs and ss with 16bit operand size
	lgdt    real_pgdt_desc
   1846f:	0f 01 15 98 84 01 00 	lgdtl  0x18498
	mov	$0x10, %eax
   18476:	b8 10 00 00 00       	mov    $0x10,%eax
	mov	%ax, %ss
   1847b:	8e d0                	mov    %eax,%ss
	ljmp    $0x8, $1f
   1847d:	ea 84 84 01 00 08 00 	ljmp   $0x8,$0x18484
	1:

	// jmp to linux
	.code16
	movl    %ecx, %cr0
   18484:	0f 22 c1             	mov    %ecx,%cr0
	mov	%dx,   %ss
   18487:	8e d2                	mov    %edx,%ss
	mov	%dx,   %ds
   18489:	8e da                	mov    %edx,%ds
	mov	%dx,   %es
   1848b:	8e c2                	mov    %edx,%es
	mov	%dx,   %fs
   1848d:	8e e2                	mov    %edx,%fs
	mov	%dx,   %gs
   1848f:	8e ea                	mov    %edx,%gs
	lretl
   18491:	66 cb                	lretw  
   18493:	66 90                	xchg   %ax,%ax
   18495:	66 90                	xchg   %ax,%ax
   18497:	90                   	nop

00018498 <real_gdt>:
   18498:	17                   	pop    %ss
   18499:	00 98 84 01 00 00    	add    %bl,0x184(%eax)
	...

000184a0 <_gdt_real_cs>:
   184a0:	ff                   	(bad)  
   184a1:	ff 00                	incl   (%eax)
   184a3:	00 00                	add    %al,(%eax)
   184a5:	9f                   	lahf   
   184a6:	8f 00                	popl   (%eax)

000184a8 <_gdt_real_ds>:
   184a8:	ff                   	(bad)  
   184a9:	ff 00                	incl   (%eax)
   184ab:	00 00                	add    %al,(%eax)
   184ad:	93                   	xchg   %eax,%ebx
	...

000184b0 <start_linux>:
 * Starts a linux from multiboot modules. Treats the first module as
 * linux kernel and the optional second module as initrd.
 */
int
start_linux(struct mbi *mbi)
{
   184b0:	57                   	push   %edi
   184b1:	56                   	push   %esi
   184b2:	53                   	push   %ebx
   184b3:	83 ec 20             	sub    $0x20,%esp
   184b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  struct module *m  = (struct module *) (mbi->mods_addr);
   184ba:	8b 44 24 0c          	mov    0xc(%esp),%eax
   184be:	8b 40 18             	mov    0x18(%eax),%eax
   184c1:	89 44 24 18          	mov    %eax,0x18(%esp)
  struct linux_kernel_header *hdr = (struct linux_kernel_header *)(m->mod_start + 0x1f1);
   184c5:	8b 44 24 18          	mov    0x18(%esp),%eax
   184c9:	8b 00                	mov    (%eax),%eax
   184cb:	05 f1 01 00 00       	add    $0x1f1,%eax
   184d0:	89 44 24 14          	mov    %eax,0x14(%esp)

  // sanity checks
  ERROR(-11, ~mbi->flags & MBI_FLAG_MODS, "module flag missing");
   184d4:	8b 44 24 0c          	mov    0xc(%esp),%eax
   184d8:	8b 00                	mov    (%eax),%eax
   184da:	83 e0 08             	and    $0x8,%eax
   184dd:	85 c0                	test   %eax,%eax
   184df:	75 14                	jne    184f5 <start_linux+0x45>
   184e1:	b8 74 8a 01 00       	mov    $0x18a74,%eax
   184e6:	e8 78 fe ff ff       	call   18363 <out_string>
   184eb:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
   184f0:	e8 3a fc ff ff       	call   1812f <__exit>
  ERROR(-12, !mbi->mods_count, "no kernel to start");
   184f5:	8b 44 24 0c          	mov    0xc(%esp),%eax
   184f9:	8b 40 14             	mov    0x14(%eax),%eax
   184fc:	85 c0                	test   %eax,%eax
   184fe:	75 14                	jne    18514 <start_linux+0x64>
   18500:	b8 88 8a 01 00       	mov    $0x18a88,%eax
   18505:	e8 59 fe ff ff       	call   18363 <out_string>
   1850a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
   1850f:	e8 1b fc ff ff       	call   1812f <__exit>
  ERROR(-13, 2 < mbi->mods_count, "do not know what to do with that many modules");
   18514:	8b 44 24 0c          	mov    0xc(%esp),%eax
   18518:	8b 40 14             	mov    0x14(%eax),%eax
   1851b:	83 f8 02             	cmp    $0x2,%eax
   1851e:	76 14                	jbe    18534 <start_linux+0x84>
   18520:	b8 9c 8a 01 00       	mov    $0x18a9c,%eax
   18525:	e8 39 fe ff ff       	call   18363 <out_string>
   1852a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
   1852f:	e8 fb fb ff ff       	call   1812f <__exit>
  ERROR(-14, LINUX_BOOT_FLAG_MAGIC != hdr->boot_flag, "boot flag does not match");
   18534:	8b 44 24 14          	mov    0x14(%esp),%eax
   18538:	0f b7 40 0d          	movzwl 0xd(%eax),%eax
   1853c:	66 3d 55 aa          	cmp    $0xaa55,%ax
   18540:	74 14                	je     18556 <start_linux+0xa6>
   18542:	b8 ca 8a 01 00       	mov    $0x18aca,%eax
   18547:	e8 17 fe ff ff       	call   18363 <out_string>
   1854c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
   18551:	e8 d9 fb ff ff       	call   1812f <__exit>
  ERROR(-15, LINUX_HEADER_MAGIC != hdr->header, "too old linux version?");
   18556:	8b 44 24 14          	mov    0x14(%esp),%eax
   1855a:	8b 40 11             	mov    0x11(%eax),%eax
   1855d:	3d 48 64 72 53       	cmp    $0x53726448,%eax
   18562:	74 14                	je     18578 <start_linux+0xc8>
   18564:	b8 e3 8a 01 00       	mov    $0x18ae3,%eax
   18569:	e8 f5 fd ff ff       	call   18363 <out_string>
   1856e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
   18573:	e8 b7 fb ff ff       	call   1812f <__exit>
  ERROR(-16, 0x202 > hdr->version, "can not start linux pre 2.4.0");
   18578:	8b 44 24 14          	mov    0x14(%esp),%eax
   1857c:	0f b7 40 15          	movzwl 0x15(%eax),%eax
   18580:	66 3d 01 02          	cmp    $0x201,%ax
   18584:	77 14                	ja     1859a <start_linux+0xea>
   18586:	b8 fa 8a 01 00       	mov    $0x18afa,%eax
   1858b:	e8 d3 fd ff ff       	call   18363 <out_string>
   18590:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
   18595:	e8 95 fb ff ff       	call   1812f <__exit>
  ERROR(-17, !(hdr->loadflags & 0x01), "not a bzImage?");
   1859a:	8b 44 24 14          	mov    0x14(%esp),%eax
   1859e:	0f b6 40 20          	movzbl 0x20(%eax),%eax
   185a2:	0f b6 c0             	movzbl %al,%eax
   185a5:	83 e0 01             	and    $0x1,%eax
   185a8:	85 c0                	test   %eax,%eax
   185aa:	75 14                	jne    185c0 <start_linux+0x110>
   185ac:	b8 18 8b 01 00       	mov    $0x18b18,%eax
   185b1:	e8 ad fd ff ff       	call   18363 <out_string>
   185b6:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
   185bb:	e8 6f fb ff ff       	call   1812f <__exit>

  // filling out the header
  hdr->type_of_loader = 0x7;      // fake GRUB here
   185c0:	8b 44 24 14          	mov    0x14(%esp),%eax
   185c4:	c6 40 1f 07          	movb   $0x7,0x1f(%eax)
  hdr->cmd_line_ptr   = REALMODE_STACK;
   185c8:	ba 00 90 04 00       	mov    $0x49000,%edx
   185cd:	8b 44 24 14          	mov    0x14(%esp),%eax
   185d1:	89 50 37             	mov    %edx,0x37(%eax)

  // enable heap
  hdr->heap_end_ptr   = (REALMODE_STACK - 0x200) & 0xffff;
   185d4:	b8 00 90 04 00       	mov    $0x49000,%eax
   185d9:	8d 90 00 fe ff ff    	lea    -0x200(%eax),%edx
   185df:	8b 44 24 14          	mov    0x14(%esp),%eax
   185e3:	66 89 50 33          	mov    %dx,0x33(%eax)
  hdr->loadflags     |= 0x80;
   185e7:	8b 44 24 14          	mov    0x14(%esp),%eax
   185eb:	0f b6 40 20          	movzbl 0x20(%eax),%eax
   185ef:	83 c8 80             	or     $0xffffff80,%eax
   185f2:	89 c2                	mov    %eax,%edx
   185f4:	8b 44 24 14          	mov    0x14(%esp),%eax
   185f8:	88 50 20             	mov    %dl,0x20(%eax)

  // output kernel version string
  if (hdr->kernel_version)
   185fb:	8b 44 24 14          	mov    0x14(%esp),%eax
   185ff:	0f b7 40 1d          	movzwl 0x1d(%eax),%eax
   18603:	66 85 c0             	test   %ax,%ax
   18606:	74 4f                	je     18657 <start_linux+0x1a7>
    {
      ERROR(-18, hdr->setup_sects << 9 < hdr->kernel_version, "version pointer invalid");
   18608:	8b 44 24 14          	mov    0x14(%esp),%eax
   1860c:	0f b6 00             	movzbl (%eax),%eax
   1860f:	0f b6 c0             	movzbl %al,%eax
   18612:	c1 e0 09             	shl    $0x9,%eax
   18615:	89 c2                	mov    %eax,%edx
   18617:	8b 44 24 14          	mov    0x14(%esp),%eax
   1861b:	0f b7 40 1d          	movzwl 0x1d(%eax),%eax
   1861f:	0f b7 c0             	movzwl %ax,%eax
   18622:	39 c2                	cmp    %eax,%edx
   18624:	7d 14                	jge    1863a <start_linux+0x18a>
   18626:	b8 27 8b 01 00       	mov    $0x18b27,%eax
   1862b:	e8 33 fd ff ff       	call   18363 <out_string>
   18630:	b8 ee ff ff ff       	mov    $0xffffffee,%eax
   18635:	e8 f5 fa ff ff       	call   1812f <__exit>
      out_info((char *)(m->mod_start + hdr->kernel_version + 0x200));
   1863a:	8b 44 24 18          	mov    0x18(%esp),%eax
   1863e:	8b 10                	mov    (%eax),%edx
   18640:	8b 44 24 14          	mov    0x14(%esp),%eax
   18644:	0f b7 40 1d          	movzwl 0x1d(%eax),%eax
   18648:	0f b7 c0             	movzwl %ax,%eax
   1864b:	01 d0                	add    %edx,%eax
   1864d:	05 00 02 00 00       	add    $0x200,%eax
   18652:	e8 e1 fd ff ff       	call   18438 <out_info>
    }

  //fix cmdline
  char *cmdline = (char *) m->string;
   18657:	8b 44 24 18          	mov    0x18(%esp),%eax
   1865b:	8b 40 08             	mov    0x8(%eax),%eax
   1865e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  while (*cmdline && *cmdline++ !=' ')
   18662:	90                   	nop
   18663:	8b 44 24 1c          	mov    0x1c(%esp),%eax
   18667:	0f b6 00             	movzbl (%eax),%eax
   1866a:	84 c0                	test   %al,%al
   1866c:	74 12                	je     18680 <start_linux+0x1d0>
   1866e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
   18672:	8d 50 01             	lea    0x1(%eax),%edx
   18675:	89 54 24 1c          	mov    %edx,0x1c(%esp)
   18679:	0f b6 00             	movzbl (%eax),%eax
   1867c:	3c 20                	cmp    $0x20,%al
   1867e:	75 e3                	jne    18663 <start_linux+0x1b3>
    ;
  out_info(cmdline);
   18680:	8b 44 24 1c          	mov    0x1c(%esp),%eax
   18684:	e8 af fd ff ff       	call   18438 <out_info>

  // handle initrd
  if (1 < mbi->mods_count)
   18689:	8b 44 24 0c          	mov    0xc(%esp),%eax
   1868d:	8b 40 14             	mov    0x14(%eax),%eax
   18690:	83 f8 01             	cmp    $0x1,%eax
   18693:	0f 86 19 01 00 00    	jbe    187b2 <start_linux+0x302>
    {
      hdr->ramdisk_size = (m+1)->mod_end - (m+1)->mod_start;
   18699:	8b 44 24 18          	mov    0x18(%esp),%eax
   1869d:	83 c0 10             	add    $0x10,%eax
   186a0:	8b 50 04             	mov    0x4(%eax),%edx
   186a3:	8b 44 24 18          	mov    0x18(%esp),%eax
   186a7:	83 c0 10             	add    $0x10,%eax
   186aa:	8b 00                	mov    (%eax),%eax
   186ac:	29 c2                	sub    %eax,%edx
   186ae:	8b 44 24 14          	mov    0x14(%esp),%eax
   186b2:	89 50 2b             	mov    %edx,0x2b(%eax)
      hdr->ramdisk_image = (m+1)->mod_start;
   186b5:	8b 44 24 18          	mov    0x18(%esp),%eax
   186b9:	83 c0 10             	add    $0x10,%eax
   186bc:	8b 10                	mov    (%eax),%edx
   186be:	8b 44 24 14          	mov    0x14(%esp),%eax
   186c2:	89 50 27             	mov    %edx,0x27(%eax)
      if (hdr->ramdisk_image + hdr->ramdisk_size > hdr->initrd_addr_max)
   186c5:	8b 44 24 14          	mov    0x14(%esp),%eax
   186c9:	8b 50 27             	mov    0x27(%eax),%edx
   186cc:	8b 44 24 14          	mov    0x14(%esp),%eax
   186d0:	8b 40 2b             	mov    0x2b(%eax),%eax
   186d3:	01 c2                	add    %eax,%edx
   186d5:	8b 44 24 14          	mov    0x14(%esp),%eax
   186d9:	8b 40 3b             	mov    0x3b(%eax),%eax
   186dc:	39 c2                	cmp    %eax,%edx
   186de:	0f 86 bb 00 00 00    	jbe    1879f <start_linux+0x2ef>
	{
	  unsigned long dst = (hdr->initrd_addr_max - hdr->ramdisk_size + 0xfff) & ~0xfff;
   186e4:	8b 44 24 14          	mov    0x14(%esp),%eax
   186e8:	8b 50 3b             	mov    0x3b(%eax),%edx
   186eb:	8b 44 24 14          	mov    0x14(%esp),%eax
   186ef:	8b 40 2b             	mov    0x2b(%eax),%eax
   186f2:	29 c2                	sub    %eax,%edx
   186f4:	89 d0                	mov    %edx,%eax
   186f6:	05 ff 0f 00 00       	add    $0xfff,%eax
   186fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
   18700:	89 44 24 10          	mov    %eax,0x10(%esp)
	  out_description("relocating initrd", dst);
   18704:	8b 44 24 10          	mov    0x10(%esp),%eax
   18708:	89 c2                	mov    %eax,%edx
   1870a:	b8 3f 8b 01 00       	mov    $0x18b3f,%eax
   1870f:	e8 e2 fc ff ff       	call   183f6 <out_description>
	  memcpy((char *)dst, (char *)hdr->ramdisk_image, hdr->ramdisk_size);
   18714:	8b 44 24 14          	mov    0x14(%esp),%eax
   18718:	8b 48 2b             	mov    0x2b(%eax),%ecx
   1871b:	8b 44 24 14          	mov    0x14(%esp),%eax
   1871f:	8b 40 27             	mov    0x27(%eax),%eax
   18722:	89 c2                	mov    %eax,%edx
   18724:	8b 44 24 10          	mov    0x10(%esp),%eax
   18728:	89 cb                	mov    %ecx,%ebx
   1872a:	83 fb 04             	cmp    $0x4,%ebx
   1872d:	72 3e                	jb     1876d <start_linux+0x2bd>
   1872f:	89 c1                	mov    %eax,%ecx
   18731:	83 e1 01             	and    $0x1,%ecx
   18734:	85 c9                	test   %ecx,%ecx
   18736:	74 0e                	je     18746 <start_linux+0x296>
   18738:	0f b6 0a             	movzbl (%edx),%ecx
   1873b:	88 08                	mov    %cl,(%eax)
   1873d:	83 c0 01             	add    $0x1,%eax
   18740:	83 c2 01             	add    $0x1,%edx
   18743:	83 eb 01             	sub    $0x1,%ebx
   18746:	89 c1                	mov    %eax,%ecx
   18748:	83 e1 02             	and    $0x2,%ecx
   1874b:	85 c9                	test   %ecx,%ecx
   1874d:	74 0f                	je     1875e <start_linux+0x2ae>
   1874f:	0f b7 0a             	movzwl (%edx),%ecx
   18752:	66 89 08             	mov    %cx,(%eax)
   18755:	83 c0 02             	add    $0x2,%eax
   18758:	83 c2 02             	add    $0x2,%edx
   1875b:	83 eb 02             	sub    $0x2,%ebx
   1875e:	89 d9                	mov    %ebx,%ecx
   18760:	c1 e9 02             	shr    $0x2,%ecx
   18763:	89 c7                	mov    %eax,%edi
   18765:	89 d6                	mov    %edx,%esi
   18767:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
   18769:	89 f2                	mov    %esi,%edx
   1876b:	89 f8                	mov    %edi,%eax
   1876d:	b9 00 00 00 00       	mov    $0x0,%ecx
   18772:	89 de                	mov    %ebx,%esi
   18774:	83 e6 02             	and    $0x2,%esi
   18777:	85 f6                	test   %esi,%esi
   18779:	74 0b                	je     18786 <start_linux+0x2d6>
   1877b:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
   1877f:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
   18783:	83 c1 02             	add    $0x2,%ecx
   18786:	83 e3 01             	and    $0x1,%ebx
   18789:	85 db                	test   %ebx,%ebx
   1878b:	74 07                	je     18794 <start_linux+0x2e4>
   1878d:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
   18791:	88 14 08             	mov    %dl,(%eax,%ecx,1)
	  hdr->ramdisk_image = dst;
   18794:	8b 44 24 14          	mov    0x14(%esp),%eax
   18798:	8b 54 24 10          	mov    0x10(%esp),%edx
   1879c:	89 50 27             	mov    %edx,0x27(%eax)
	}
      out_description("initrd",  hdr->ramdisk_image);
   1879f:	8b 44 24 14          	mov    0x14(%esp),%eax
   187a3:	8b 40 27             	mov    0x27(%eax),%eax
   187a6:	89 c2                	mov    %eax,%edx
   187a8:	b8 51 8b 01 00       	mov    $0x18b51,%eax
   187ad:	e8 44 fc ff ff       	call   183f6 <out_description>
    }

  out_info("copy image");
   187b2:	b8 58 8b 01 00       	mov    $0x18b58,%eax
   187b7:	e8 7c fc ff ff       	call   18438 <out_info>
  memcpy((char *) REALMODE_IMAGE, (char *) m->mod_start, (hdr->setup_sects+1) << 9);
   187bc:	8b 44 24 14          	mov    0x14(%esp),%eax
   187c0:	0f b6 00             	movzbl (%eax),%eax
   187c3:	0f b6 c0             	movzbl %al,%eax
   187c6:	83 c0 01             	add    $0x1,%eax
   187c9:	c1 e0 09             	shl    $0x9,%eax
   187cc:	89 c1                	mov    %eax,%ecx
   187ce:	8b 44 24 18          	mov    0x18(%esp),%eax
   187d2:	8b 00                	mov    (%eax),%eax
   187d4:	89 c2                	mov    %eax,%edx
   187d6:	b8 00 00 04 00       	mov    $0x40000,%eax
   187db:	89 cb                	mov    %ecx,%ebx
   187dd:	83 fb 04             	cmp    $0x4,%ebx
   187e0:	72 3e                	jb     18820 <start_linux+0x370>
   187e2:	89 c1                	mov    %eax,%ecx
   187e4:	83 e1 01             	and    $0x1,%ecx
   187e7:	85 c9                	test   %ecx,%ecx
   187e9:	74 0e                	je     187f9 <start_linux+0x349>
   187eb:	0f b6 0a             	movzbl (%edx),%ecx
   187ee:	88 08                	mov    %cl,(%eax)
   187f0:	83 c0 01             	add    $0x1,%eax
   187f3:	83 c2 01             	add    $0x1,%edx
   187f6:	83 eb 01             	sub    $0x1,%ebx
   187f9:	89 c1                	mov    %eax,%ecx
   187fb:	83 e1 02             	and    $0x2,%ecx
   187fe:	85 c9                	test   %ecx,%ecx
   18800:	74 0f                	je     18811 <start_linux+0x361>
   18802:	0f b7 0a             	movzwl (%edx),%ecx
   18805:	66 89 08             	mov    %cx,(%eax)
   18808:	83 c0 02             	add    $0x2,%eax
   1880b:	83 c2 02             	add    $0x2,%edx
   1880e:	83 eb 02             	sub    $0x2,%ebx
   18811:	89 d9                	mov    %ebx,%ecx
   18813:	c1 e9 02             	shr    $0x2,%ecx
   18816:	89 c7                	mov    %eax,%edi
   18818:	89 d6                	mov    %edx,%esi
   1881a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
   1881c:	89 f2                	mov    %esi,%edx
   1881e:	89 f8                	mov    %edi,%eax
   18820:	b9 00 00 00 00       	mov    $0x0,%ecx
   18825:	89 de                	mov    %ebx,%esi
   18827:	83 e6 02             	and    $0x2,%esi
   1882a:	85 f6                	test   %esi,%esi
   1882c:	74 0b                	je     18839 <start_linux+0x389>
   1882e:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
   18832:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
   18836:	83 c1 02             	add    $0x2,%ecx
   18839:	83 e3 01             	and    $0x1,%ebx
   1883c:	85 db                	test   %ebx,%ebx
   1883e:	74 07                	je     18847 <start_linux+0x397>
   18840:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
   18844:	88 14 08             	mov    %dl,(%eax,%ecx,1)
  memcpy((char *) hdr->cmd_line_ptr, cmdline, strlen(cmdline)+1);
   18847:	8b 44 24 1c          	mov    0x1c(%esp),%eax
   1884b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
   18850:	89 c2                	mov    %eax,%edx
   18852:	b8 00 00 00 00       	mov    $0x0,%eax
   18857:	89 d7                	mov    %edx,%edi
   18859:	f2 ae                	repnz scas %es:(%edi),%al
   1885b:	89 c8                	mov    %ecx,%eax
   1885d:	f7 d0                	not    %eax
   1885f:	83 e8 01             	sub    $0x1,%eax
   18862:	8d 48 01             	lea    0x1(%eax),%ecx
   18865:	8b 44 24 14          	mov    0x14(%esp),%eax
   18869:	8b 40 37             	mov    0x37(%eax),%eax
   1886c:	8b 54 24 1c          	mov    0x1c(%esp),%edx
   18870:	89 cb                	mov    %ecx,%ebx
   18872:	83 fb 04             	cmp    $0x4,%ebx
   18875:	72 3e                	jb     188b5 <start_linux+0x405>
   18877:	89 c1                	mov    %eax,%ecx
   18879:	83 e1 01             	and    $0x1,%ecx
   1887c:	85 c9                	test   %ecx,%ecx
   1887e:	74 0e                	je     1888e <start_linux+0x3de>
   18880:	0f b6 0a             	movzbl (%edx),%ecx
   18883:	88 08                	mov    %cl,(%eax)
   18885:	83 c0 01             	add    $0x1,%eax
   18888:	83 c2 01             	add    $0x1,%edx
   1888b:	83 eb 01             	sub    $0x1,%ebx
   1888e:	89 c1                	mov    %eax,%ecx
   18890:	83 e1 02             	and    $0x2,%ecx
   18893:	85 c9                	test   %ecx,%ecx
   18895:	74 0f                	je     188a6 <start_linux+0x3f6>
   18897:	0f b7 0a             	movzwl (%edx),%ecx
   1889a:	66 89 08             	mov    %cx,(%eax)
   1889d:	83 c0 02             	add    $0x2,%eax
   188a0:	83 c2 02             	add    $0x2,%edx
   188a3:	83 eb 02             	sub    $0x2,%ebx
   188a6:	89 d9                	mov    %ebx,%ecx
   188a8:	c1 e9 02             	shr    $0x2,%ecx
   188ab:	89 c7                	mov    %eax,%edi
   188ad:	89 d6                	mov    %edx,%esi
   188af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
   188b1:	89 f2                	mov    %esi,%edx
   188b3:	89 f8                	mov    %edi,%eax
   188b5:	b9 00 00 00 00       	mov    $0x0,%ecx
   188ba:	89 de                	mov    %ebx,%esi
   188bc:	83 e6 02             	and    $0x2,%esi
   188bf:	85 f6                	test   %esi,%esi
   188c1:	74 0b                	je     188ce <start_linux+0x41e>
   188c3:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
   188c7:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
   188cb:	83 c1 02             	add    $0x2,%ecx
   188ce:	83 e3 01             	and    $0x1,%ebx
   188d1:	85 db                	test   %ebx,%ebx
   188d3:	74 07                	je     188dc <start_linux+0x42c>
   188d5:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
   188d9:	88 14 08             	mov    %dl,(%eax,%ecx,1)
  memcpy((char *) hdr->code32_start, (char *)  m->mod_start + ((hdr->setup_sects+1) << 9), hdr->syssize*16);
   188dc:	8b 44 24 14          	mov    0x14(%esp),%eax
   188e0:	8b 40 03             	mov    0x3(%eax),%eax
   188e3:	c1 e0 04             	shl    $0x4,%eax
   188e6:	89 c1                	mov    %eax,%ecx
   188e8:	8b 44 24 14          	mov    0x14(%esp),%eax
   188ec:	0f b6 00             	movzbl (%eax),%eax
   188ef:	0f b6 c0             	movzbl %al,%eax
   188f2:	83 c0 01             	add    $0x1,%eax
   188f5:	c1 e0 09             	shl    $0x9,%eax
   188f8:	89 c2                	mov    %eax,%edx
   188fa:	8b 44 24 18          	mov    0x18(%esp),%eax
   188fe:	8b 00                	mov    (%eax),%eax
   18900:	01 d0                	add    %edx,%eax
   18902:	89 c2                	mov    %eax,%edx
   18904:	8b 44 24 14          	mov    0x14(%esp),%eax
   18908:	8b 40 23             	mov    0x23(%eax),%eax
   1890b:	89 cb                	mov    %ecx,%ebx
   1890d:	83 fb 04             	cmp    $0x4,%ebx
   18910:	72 3e                	jb     18950 <start_linux+0x4a0>
   18912:	89 c1                	mov    %eax,%ecx
   18914:	83 e1 01             	and    $0x1,%ecx
   18917:	85 c9                	test   %ecx,%ecx
   18919:	74 0e                	je     18929 <start_linux+0x479>
   1891b:	0f b6 0a             	movzbl (%edx),%ecx
   1891e:	88 08                	mov    %cl,(%eax)
   18920:	83 c0 01             	add    $0x1,%eax
   18923:	83 c2 01             	add    $0x1,%edx
   18926:	83 eb 01             	sub    $0x1,%ebx
   18929:	89 c1                	mov    %eax,%ecx
   1892b:	83 e1 02             	and    $0x2,%ecx
   1892e:	85 c9                	test   %ecx,%ecx
   18930:	74 0f                	je     18941 <start_linux+0x491>
   18932:	0f b7 0a             	movzwl (%edx),%ecx
   18935:	66 89 08             	mov    %cx,(%eax)
   18938:	83 c0 02             	add    $0x2,%eax
   1893b:	83 c2 02             	add    $0x2,%edx
   1893e:	83 eb 02             	sub    $0x2,%ebx
   18941:	89 d9                	mov    %ebx,%ecx
   18943:	c1 e9 02             	shr    $0x2,%ecx
   18946:	89 c7                	mov    %eax,%edi
   18948:	89 d6                	mov    %edx,%esi
   1894a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
   1894c:	89 f2                	mov    %esi,%edx
   1894e:	89 f8                	mov    %edi,%eax
   18950:	b9 00 00 00 00       	mov    $0x0,%ecx
   18955:	89 de                	mov    %ebx,%esi
   18957:	83 e6 02             	and    $0x2,%esi
   1895a:	85 f6                	test   %esi,%esi
   1895c:	74 0b                	je     18969 <start_linux+0x4b9>
   1895e:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
   18962:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
   18966:	83 c1 02             	add    $0x2,%ecx
   18969:	83 e3 01             	and    $0x1,%ebx
   1896c:	85 db                	test   %ebx,%ebx
   1896e:	74 07                	je     18977 <start_linux+0x4c7>
   18970:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
   18974:	88 14 08             	mov    %dl,(%eax,%ecx,1)

  out_info("start kernel");
   18977:	b8 63 8b 01 00       	mov    $0x18b63,%eax
   1897c:	e8 b7 fa ff ff       	call   18438 <out_info>
  jmp_kernel(REALMODE_IMAGE / 16 + 0x20, REALMODE_STACK);
   18981:	b8 00 90 04 00       	mov    $0x49000,%eax
   18986:	ba 00 00 04 00       	mov    $0x40000,%edx
   1898b:	c1 ea 04             	shr    $0x4,%edx
   1898e:	8d 4a 20             	lea    0x20(%edx),%ecx
   18991:	89 c2                	mov    %eax,%edx
   18993:	89 c8                	mov    %ecx,%eax
   18995:	e8 c4 fa ff ff       	call   1845e <jmp_kernel>

0001899a <__main>:
/**
 * Start a linux from a multiboot structure.
 */
int
__main(struct mbi *mbi, unsigned flags)
{
   1899a:	83 ec 1c             	sub    $0x1c,%esp
   1899d:	89 44 24 0c          	mov    %eax,0xc(%esp)
   189a1:	89 54 24 08          	mov    %edx,0x8(%esp)
#ifndef NDEBUG
  serial_init();
   189a5:	e8 df f7 ff ff       	call   18189 <serial_init>
#endif
  out_info(VERSION " starts Linux");
   189aa:	b8 70 8b 01 00       	mov    $0x18b70,%eax
   189af:	e8 84 fa ff ff       	call   18438 <out_info>
  ERROR(10, !mbi || flags != MBI_MAGIC, "Not loaded via multiboot");
   189b4:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
   189b9:	74 0a                	je     189c5 <__main+0x2b>
   189bb:	81 7c 24 08 02 b0 ad 	cmpl   $0x2badb002,0x8(%esp)
   189c2:	2b 
   189c3:	74 14                	je     189d9 <__main+0x3f>
   189c5:	b8 85 8b 01 00       	mov    $0x18b85,%eax
   189ca:	e8 94 f9 ff ff       	call   18363 <out_string>
   189cf:	b8 0a 00 00 00       	mov    $0xa,%eax
   189d4:	e8 56 f7 ff ff       	call   1812f <__exit>
  ERROR(11, start_linux(mbi), "start linux failed");
   189d9:	8b 44 24 0c          	mov    0xc(%esp),%eax
   189dd:	e8 ce fa ff ff       	call   184b0 <start_linux>
   189e2:	85 c0                	test   %eax,%eax
   189e4:	74 14                	je     189fa <__main+0x60>
   189e6:	b8 9e 8b 01 00       	mov    $0x18b9e,%eax
   189eb:	e8 73 f9 ff ff       	call   18363 <out_string>
   189f0:	b8 0b 00 00 00       	mov    $0xb,%eax
   189f5:	e8 35 f7 ff ff       	call   1812f <__exit>
  return 12;
   189fa:	b8 0c 00 00 00       	mov    $0xc,%eax
}
   189ff:	83 c4 1c             	add    $0x1c,%esp
   18a02:	c3                   	ret    
   18a03:	65                   	gs
   18a04:	78 69                	js     18a6f <REALMODE_STACK+0x3>
   18a06:	74 28                	je     18a30 <__main+0x96>
   18a08:	29 00                	sub    %eax,(%eax)
   18a0a:	2d 3e 20 4f 4b       	sub    $0x4b4f203e,%eax
   18a0f:	2c 20                	sub    $0x20,%al
   18a11:	72 65                	jb     18a78 <REALMODE_IMAGE+0x8>
   18a13:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   18a16:	74 20                	je     18a38 <__main+0x9e>
   18a18:	6e                   	outsb  %ds:(%esi),(%dx)
   18a19:	6f                   	outsl  %ds:(%esi),(%dx)
   18a1a:	77 21                	ja     18a3d <__main+0xa3>
   18a1c:	0a 00                	or     (%eax),%al
   18a1e:	6e                   	outsb  %ds:(%esi),(%dx)
   18a1f:	6f                   	outsl  %ds:(%esi),(%dx)
   18a20:	20 65 78             	and    %ah,0x78(%ebp)
   18a23:	74 20                	je     18a45 <__main+0xab>
   18a25:	63 70 75             	arpl   %si,0x75(%eax)
   18a28:	69 64 00 6e 6f 20 53 	imul   $0x5653206f,0x6e(%eax,%eax,1),%esp
   18a2f:	56 
   18a30:	4d                   	dec    %ebp
   18a31:	20 73 75             	and    %dh,0x75(%ebx)
   18a34:	70 70                	jo     18aa6 <REALMODE_IMAGE+0x36>
   18a36:	6f                   	outsl  %ds:(%esi),(%dx)
   18a37:	72 74                	jb     18aad <REALMODE_IMAGE+0x3d>
   18a39:	00 6e 6f             	add    %ch,0x6f(%esi)
   18a3c:	20 41 50             	and    %al,0x50(%ecx)
   18a3f:	49                   	dec    %ecx
   18a40:	43                   	inc    %ebx
   18a41:	20 73 75             	and    %dh,0x75(%ebx)
   18a44:	70 70                	jo     18ab6 <REALMODE_IMAGE+0x46>
   18a46:	6f                   	outsl  %ds:(%esi),(%dx)
   18a47:	72 74                	jb     18abd <REALMODE_IMAGE+0x4d>
   18a49:	00 63 6f             	add    %ah,0x6f(%ebx)
   18a4c:	75 6c                	jne    18aba <REALMODE_IMAGE+0x4a>
   18a4e:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
   18a52:	74 20                	je     18a74 <REALMODE_IMAGE+0x4>
   18a54:	65 6e                	outsb  %gs:(%esi),(%dx)
   18a56:	61                   	popa   
   18a57:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
   18a5b:	53                   	push   %ebx
   18a5c:	56                   	push   %esi
   18a5d:	4d                   	dec    %ebp
   18a5e:	00 90 4d 55 4e 49    	add    %dl,0x494e554d(%eax)
   18a64:	43                   	inc    %ebx
   18a65:	48                   	dec    %eax
   18a66:	3a 20                	cmp    (%eax),%ah
   18a68:	00 00                	add    %al,(%eax)
	...

00018a6c <REALMODE_STACK>:
   18a6c:	00 90 04 00                                         ....

00018a70 <REALMODE_IMAGE>:
   18a70:	00 00 04 00 6d 6f 64 75 6c 65 20 66 6c 61 67 20     ....module flag 
   18a80:	6d 69 73 73 69 6e 67 00 6e 6f 20 6b 65 72 6e 65     missing.no kerne
   18a90:	6c 20 74 6f 20 73 74 61 72 74 00 00 64 6f 20 6e     l to start..do n
   18aa0:	6f 74 20 6b 6e 6f 77 20 77 68 61 74 20 74 6f 20     ot know what to 
   18ab0:	64 6f 20 77 69 74 68 20 74 68 61 74 20 6d 61 6e     do with that man
   18ac0:	79 20 6d 6f 64 75 6c 65 73 00 62 6f 6f 74 20 66     y modules.boot f
   18ad0:	6c 61 67 20 64 6f 65 73 20 6e 6f 74 20 6d 61 74     lag does not mat
   18ae0:	63 68 00 74 6f 6f 20 6f 6c 64 20 6c 69 6e 75 78     ch.too old linux
   18af0:	20 76 65 72 73 69 6f 6e 3f 00 63 61 6e 20 6e 6f      version?.can no
   18b00:	74 20 73 74 61 72 74 20 6c 69 6e 75 78 20 70 72     t start linux pr
   18b10:	65 20 32 2e 34 2e 30 00 6e 6f 74 20 61 20 62 7a     e 2.4.0.not a bz
   18b20:	49 6d 61 67 65 3f 00 76 65 72 73 69 6f 6e 20 70     Image?.version p
   18b30:	6f 69 6e 74 65 72 20 69 6e 76 61 6c 69 64 00 72     ointer invalid.r
   18b40:	65 6c 6f 63 61 74 69 6e 67 20 69 6e 69 74 72 64     elocating initrd
   18b50:	00 69 6e 69 74 72 64 00 63 6f 70 79 20 69 6d 61     .initrd.copy ima
   18b60:	67 65 00 73 74 61 72 74 20 6b 65 72 6e 65 6c 00     ge.start kernel.
   18b70:	76 2e 30 2e 34 2e 36 20 73 74 61 72 74 73 20 4c     v.0.4.6 starts L
   18b80:	69 6e 75 78 00 4e 6f 74 20 6c 6f 61 64 65 64 20     inux.Not loaded 
   18b90:	76 69 61 20 6d 75 6c 74 69 62 6f 6f 74 00 73 74     via multiboot.st
   18ba0:	61 72 74 20 6c 69 6e 75 78 20 66 61 69 6c 65 64     art linux failed
	...
