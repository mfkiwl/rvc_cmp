# Compile source
echo "Linker with RV32i"
riscv32-unknown-elf-gcc  -O3  -march=rv32i -T./ss_rvc_link.common.ld -nostartfiles -D__riscv__ ./$1.S -o $1.elf
#creates readable elf file
riscv32-unknown-elf-objdump -gd $1.elf > $1_elf.txt
#creates the instruction verilog file 
riscv32-unknown-elf-objcopy --srec-len 1 --output-target=verilog $1.elf $1_inst_mem.sv 

if [ ! -d "../verif/tests/$1" ];then
    mkdir ../verif/tests/$1
fi
mv $1.S             ../verif/tests/$1
mv $1.elf           ../verif/tests/$1
mv $1_elf.txt       ../verif/tests/$1
mv $1_inst_mem.sv   ../verif/tests/$1
exit 1


