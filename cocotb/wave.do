#--------------------------------------------------------------------
add wave -noupdate -divider -height 47   division_module                  
add wave -noupdate              -group   division_module 
#--------------------------------------------------------------------
add wave -position 2 sim:/restoring_division/*
#--------------------------------------------------------------------
add wave -noupdate -divider -height 47 end
#--------------------------------------------------------------------

onerror {resume}
quietly WaveActivateNextPane {} 0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
run 500 ns
WaveRestoreZoom {0 ps} {500 ns}
