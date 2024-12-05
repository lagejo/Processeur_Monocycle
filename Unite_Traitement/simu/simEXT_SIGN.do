vlib work

vcom -93 ../src/EXT_SIGN.vhd
vcom -93 EXT_SIGN_tb.vhd

vsim EXT_SIGN_tb(Bench)

view signals
add wave *


run -all
wave zoom full