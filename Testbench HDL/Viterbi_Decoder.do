onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_decoder/test/clk
add wave -noupdate /test_decoder/test/input
add wave -noupdate /test_decoder/test/output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {942831 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 178
configure wave -valuecolwidth 47
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
WaveRestoreZoom {0 ps} {526413 ps}
