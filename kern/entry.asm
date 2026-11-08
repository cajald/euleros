;
; entry.asm -- entry point
;

format ELF64

section '.text' executable

extrn kmain
public _start

_start:
	call kmain

.helloworld:
	mov dx, 0x3F8
	mov al, 'a'
	out dx, al
	mov al, 'r'
	out dx, al
	mov al, 'g'
	out dx, al
	mov al, 'o'
	out dx, al
	mov al, 'n'
	out dx, al

	mov al, 0x0A
	out dx, al

.halt:
	cli
	hlt
	jmp .halt

