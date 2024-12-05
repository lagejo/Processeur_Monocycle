vlib work

vcom -93 ../src/MEMOIRE.vhd
vcom -93 MEMOIRE_tb.vhd

vsim MEMOIRE_tb(bench)

view signals
add wave *


run -all
wave zoom full