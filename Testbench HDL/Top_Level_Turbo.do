onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_turbo/test/clk
add wave -noupdate /test_turbo/test/rstb
add wave -noupdate /test_turbo/test/input
add wave -noupdate /test_turbo/test/output
add wave -noupdate -expand /test_turbo/test/CE1_Out
add wave -noupdate /test_turbo/test/VD1_Out
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
WaveRestoreZoom {1487550 ps} {2511550 ps}
