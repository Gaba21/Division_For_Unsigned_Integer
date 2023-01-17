quit -sim
vlib work
vmap work work
vdel -all -lib work
vlib work
vmap work work

############################################################################
# source
############################################################################

vcom -work work  ../../src/restoring_division.vhd

vcom -work work  ./restoring_division_tb.vhd

############################################################################
# run simulation
############################################################################

vsim -gui -voptargs="+acc" work.restoring_division_tb
