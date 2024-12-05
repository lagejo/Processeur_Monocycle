vlib work

vcom -93 ../src/REGISTERS.vhd
vcom -93 REGISTERS_tb.vhd

vsim REGISTERS_tb(Bench)

view signals
add wave *


run -all
wave zoom full