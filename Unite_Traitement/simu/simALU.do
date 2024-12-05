vlib work

vcom -93 ../src/ALU.vhd
vcom -93 ALU_tb.vhd

vsim ALU_tb(Bench)

view signals
add wave *


run -all
wave zoom full