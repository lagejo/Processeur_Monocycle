vlib work

vcom -93 ../src/MULTI2.vhd
vcom -93 MULTI2_tb.vhd

vsim MULTI2_tb(bench)

view signals
add wave *


run -all
wave zoom full