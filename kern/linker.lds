/*
 * linker.lds -- where to place sections
 */

OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)

KERNEL_VMA = 0xffffffff80000000;
KERNEL_LMA = 0x100000;

PHDRS
{
    reqs   PT_LOAD FLAGS(4);
    text   PT_LOAD FLAGS(5);
    rodata PT_LOAD FLAGS(4);
    data   PT_LOAD FLAGS(6);
}

SECTIONS
{
    . = KERNEL_VMA;
    _kernel_start = .;

    .limine_requests : AT(KERNEL_LMA)
    {
        KEEP(*(.limine_requests_start))
        KEEP(*(.limine_requests))
        KEEP(*(.limine_requests_end))
    } :reqs

    . = ALIGN(0x1000);

    .text : AT(KERNEL_LMA + (ADDR(.text) - KERNEL_VMA))
    {
        __text_start = .;
        KEEP(*(.text.entry))
        *(.text .text.*)
        __text_end = .;
    } :text

    . = ALIGN(0x1000);

    .rodata : AT(KERNEL_LMA + (ADDR(.rodata) - KERNEL_VMA))
    {
        __rodata_start = .;
        *(.rodata .rodata.*)
        *(.srodata .srodata.*)
        __rodata_end = .;
    } :rodata

    . = ALIGN(0x1000);

    .data : AT(KERNEL_LMA + (ADDR(.data) - KERNEL_VMA))
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

    .bss (NOLOAD) : AT(KERNEL_LMA + (ADDR(.bss) - KERNEL_VMA))
    {
        __bss_start = .;
        *(COMMON)
        *(.bss .bss.*)
        *(.sbss .sbss.*)
        . = ALIGN(0x1000);
        __bss_end = .;
    } :data

    _kernel_end = .;

    /DISCARD/ :
    {
        *(.eh_frame*)
        *(.note .note.*)
        *(.comment)
        *(.llvm_addrsig)
    }
}

