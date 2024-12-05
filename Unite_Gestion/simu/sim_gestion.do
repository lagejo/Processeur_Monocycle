vlib work 

vcom -93 ../src/mux_pc.vhd
vcom -93 ../src/pc_extender.vhd
vcom -93 ../src/registre_pc.vhd
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/unite_gestion.vhd
vcom -93 unite_gestion_tb.vhd

vsim unite_gestion_tb(Bench)

view signals
add wave *


run -all
wave zoom full