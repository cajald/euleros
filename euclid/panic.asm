;
; abort.asm -- kernel panic
;
; This file implements kernel panics, for now just kinda hangs
;

	format ELF64
	use64

	section '.text' executable

	public panic

panic:
	cli
haltloop:
	hlt
	jmp haltloop
	; doesn't return

