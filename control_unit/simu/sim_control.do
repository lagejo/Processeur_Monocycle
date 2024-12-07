vlib work

vcom -93 ../src/decoder.vhd
vcom -93 ../src/psr_register.vhd
vcom -93 control_unit_tb.vhd

vsim control_unit_tb(Bench)

add wave -position insertpoint  \
sim:/control_unit_tb/decoder/instr_courante
view signals
add wave *


run -all
wave zoom full