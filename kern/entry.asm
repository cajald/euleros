;
; entry.asm -- entry
;

format ELF64

section '.text' executable

extrn kmain
public _start

_start:
	call kmain
.halt:
	cli
	hlt
	jmp .halt

