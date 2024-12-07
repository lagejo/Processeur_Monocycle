vlib work 

vcom -93 ../src/mux_pc.vhd
vcom -93 ../src/pc_extender.vhd
vcom -93 ../src/PC_register.vhd
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/management_unit.vhd
vcom -93 management_unit_tb.vhd

vsim management_unit_tb(Bench)

view signals
add wave *


run -all
wave zoom full