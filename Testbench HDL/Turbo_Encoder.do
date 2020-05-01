onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_encoder/test/clk
add wave -noupdate /test_encoder/test/rstb
add wave -noupdate /test_encoder/test/input
add wave -noupdate /test_encoder/test/output
add wave -noupdate /test_encoder/test/DF1_out
add wave -noupdate /test_encoder/test/DF2_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1999068 ps} {2000050 ps}
