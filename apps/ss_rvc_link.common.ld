SEARCH_DIR(.)
__DYNAMIC  =  0;

MEMORY
{
    i_mem          : ORIGIN = 0x00000000, LENGTH = 0x00010000
    global_data    : ORIGIN = 0x00010000, LENGTH = 0x00010000
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.start);
        *(.text);
        /*. = ORIGIN(i_mem) + LENGTH(i_mem) - 1;*/
        /*BYTE(0);*/
    }  > i_mem

    .data : {
        . = ALIGN(4);
        *(.rodata);
        *(.sdata);
        *(.sbss);
    } > global_data
    .bss : {} > global_data
}

