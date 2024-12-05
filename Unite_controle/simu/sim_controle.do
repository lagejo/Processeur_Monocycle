vlib work

vcom -93 ../src/decodeur.vhd
vcom -93 ../src/registrePSR.vhd
vcom -93 unite_controle_tb.vhd

vsim unite_controle_tb(Bench)

add wave -position insertpoint  \
sim:/unite_controle_tb/decodeur/instr_courante
view signals
add wave *


run -all
wave zoom full