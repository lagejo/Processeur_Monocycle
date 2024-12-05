vlib work

vcom -93 ../src/REGISTERS.vhd
vcom -93 ../src/EXT_SIGN.vhd
vcom -93 ../src/MULTI2.vhd
vcom -93 ../src/ALU.vhd
vcom -93 ../src/MEMOIRE.vhd
vcom -93 ../src/UNIT_TRAITEMENT.vhd
vcom -93 UNIT_TRAITEMENT_tb.vhd

vsim UNIT_TRAITEMENT_tb(Bench)

view signals
add wave -position insertpoint  \
sim:/unit_traitement_tb/traitement/REG/Banc
add wave -position insertpoint  \
sim:/unit_traitement_tb/traitement/memory/Banc_data
add wave *


run -all
wave zoom full