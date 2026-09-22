;
; util.asm -- utilities for C
;
; TCC doesn't have inline ASM, so yeah here is nop, outb, inb, ...
;

	format ELF64
	use64

	section '.text' executable

	public noop
	public halt
	public inb
	public outb
	public inw
	public outw

; void nop(void) -- do nothing and waste a CPU cycle
noop:
	nop
	ret

; void halt(void) -- halt until an interrupt is given
halt:
	hlt
	ret

; uint8_t inb(uint16_t port) -- get data from a port
inb:
	mov dx, di
	in al, dx
	ret

; void outb(uint16_t port, uint8_t byte) -- write data to a port
outb:
	mov dx, di
	mov al, sil
	out dx, al
	ret

; uint16_t inw(uint16_t port) -- get data from a port; but now 16 bits
inw:
	mov dx, di
	in ax, dx
	ret

; void outw(uint16_t port, uint16_t word) -- write data to a port; but now 16
; bits
outw:
	mov dx, di
	mov ax, si
	out dx, ax
	ret

