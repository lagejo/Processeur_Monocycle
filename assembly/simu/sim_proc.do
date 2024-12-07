vlib work


vcom -93 ../../management_unit/src/mux_pc.vhd
vcom -93 ../../management_unit/src/pc_extender.vhd
vcom -93 ../../management_unit/src/PC_register.vhd
vcom -93 ../../management_unit/src/instruction_memory.vhd
vcom -93 ../../management_unit/src/management_unit.vhd

vcom -93 ../../control_unit/src/decoder.vhd
vcom -93 ../../control_unit/src/psr_register.vhd

vcom -93 ../../processing_unit/src/REGISTERS.vhd
vcom -93 ../../processing_unit/src/EXT_SIGN.vhd
vcom -93 ../../processing_unit/src/MULTI2.vhd
vcom -93 ../../processing_unit/src/ALU.vhd
vcom -93 ../../processing_unit/src/memory.vhd
vcom -93 ../../processing_unit/src/processing_unit.vhd

vcom -93 ../src/seven_seg.vhd
vcom -93 ../src/processor.vhd
vcom -93 processor_tb.vhd
vsim processor_tb(Bench)


add wave -position insertpoint  \
sim:/processor_tb/proc/unite_de_traitement/busW
add wave -position insertpoint  \
sim:/processor_tb/proc/unite_de_traitement/busB
add wave -position insertpoint  \
sim:/processor_tb/proc/unite_de_traitement/busA
view signals
add wave -position insertpoint  \
sim:/processor_tb/proc/decoder/ALUCtr
add wave -position insertpoint  \
sim:/processor_tb/proc/decoder/instruction
add wave -position insertpoint  \
sim:/processor_tb/proc/decoder/instr_courante
add wave -position insertpoint  \
sim:/processor_tb/proc/unite_de_gestion/registre/out_Adrr
add wave -position insertpoint  \
sim:/processor_tb/proc/unite_de_traitement/REG/Ra
add wave *


run -all
wave zoom full