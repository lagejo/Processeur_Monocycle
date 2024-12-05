vlib work

vcom -93 ../src/REGISTERS.vhd
vcom -93 ../src/ALU.vhd
vcom -93 ../src/UNIT_ALU_REG.vhd
vcom -93 UNIT_ALU_REG_tb.vhd

vsim UNIT_ALU_REG_tb(Bench)

view signals
add wave -position insertpoint  \
sim:/unit_alu_reg_tb/UNIT/REG/Banc
add wave *


run -all
wave zoom full