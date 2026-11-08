/*
 * linker.lds -- where to place sections
 */

OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

ENTRY(_start)

PHDRS
{
	reqs PT_LOAD FLAGS(4);
	text PT_LOAD FLAGS(5);
	rodata PT_LOAD FLAGS(4);
	data PT_LOAD FLAGS(6);
}

SECTIONS
{
	. = 0xffffffff80000000;
	_kernel_start = .;
	.limine_requests :
	{
		KEEP(*(.limine_requests_start))
		KEEP(*(.limine_requests))
		KEEP(*(.limine_requests_end))
	} :requests

	. = ALIGN(0x1000);

	.text :
	{
		__text_start = .;
		*(.text .text.*)
		__text_end = .;
	} :text

	. = ALIGN(0x1000);

	.rodata :
	{
		__rodata_start = .;
		*(.rodata .rodata.*)
		*(.srodata .srodata.*)
		__rodata_end = .;
	} :rodata

	. = ALIGN(0x1000);
	.data :
	{
		__data_start = .;

		*(.data .data.*)
		*(.sdata .sdata.*)
		*(.got .got.*)

		KEEP(*(.init_array .init_array.*))
		KEEP(*(.fini_array .fini_array.*))

		__data_end = .;
	} :data

	. = ALIGN(0x1000);

	.bss (NOLOAD) :
	{
		__bss_start = .;
		*(COMMON)
		*(.bss .bss.*)
		*(.sbss .sbss.*)
		. = ALIGN(0x1000);
		__bss_end = .;
	}

	_kernel_end = .;

	/DISCARD/ :
	{
		*(.eh_frame*)
		*(.note .note.*)
		*(.comment)
		*(.llvm_addrsig)
	}
}

