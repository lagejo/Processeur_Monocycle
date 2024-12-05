vlib work


vcom -93 ../../unite_gestion/src/mux_pc.vhd
vcom -93 ../../unite_gestion/src/pc_extender.vhd
vcom -93 ../../unite_gestion/src/registre_pc.vhd
vcom -93 ../../unite_gestion/src/instruction_memory.vhd
vcom -93 ../../unite_gestion/src/unite_gestion.vhd

vcom -93 ../../unite_controle/src/decodeur.vhd
vcom -93 ../../unite_controle/src/registrePSR.vhd

vcom -93 ../../unite_traitement/src/REGISTERS.vhd
vcom -93 ../../unite_traitement/src/EXT_SIGN.vhd
vcom -93 ../../unite_traitement/src/MULTI2.vhd
vcom -93 ../../unite_traitement/src/ALU.vhd
vcom -93 ../../unite_traitement/src/MEMOIRE.vhd
vcom -93 ../../unite_traitement/src/UNIT_TRAITEMENT.vhd

vcom -93 ../src/seven_seg.vhd
vcom -93 ../src/processeur.vhd
vcom -93 processeur_tb.vhd
vsim processeur_tb(Bench)


add wave -position insertpoint  \
sim:/processeur_tb/proc/unite_de_traitement/busW
add wave -position insertpoint  \
sim:/processeur_tb/proc/unite_de_traitement/busB
add wave -position insertpoint  \
sim:/processeur_tb/proc/unite_de_traitement/busA
view signals
add wave -position insertpoint  \
sim:/processeur_tb/proc/decodeur/ALUCtr
add wave -position insertpoint  \
sim:/processeur_tb/proc/decodeur/instruction
add wave -position insertpoint  \
sim:/processeur_tb/proc/decodeur/instr_courante
add wave -position insertpoint  \
sim:/processeur_tb/proc/unite_de_gestion/registre/out_Adrr
add wave -position insertpoint  \
sim:/processeur_tb/proc/unite_de_traitement/REG/Ra
add wave *


run -all
wave zoom full