;
; entry.asm -- entry
;

	format ELF64
	use64

;;; equations ;;;
MULTIBOOT_PAGE_ALIGN	    equ (1 shl 0)
MULTIBOOT_MEMORY_INFO	    equ (1 shl 1)
MULTIBOOT_AOUT_KLUDGE	    equ (1 shl 16)
MULTIBOOT_HEADER_MAGIC	    equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS	    equ MULTIBOOT_PAGE_ALIGN or MULTIBOOT_MEMORY_INFO
MULTIBOOT_CHECKSUM          equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

	section '.text' executable

;;; multiboot shit ;;;
dd MULTIBOOT_HEADER_MAGIC
dd MULTIBOOT_HEADER_FLAGS
dd MULTIBOOT_CHECKSUM

	public _start
	extrn kmain
_start:
	call kmain
@@: ; halt
	jmp @b
