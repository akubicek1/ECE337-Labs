onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sync_high/tb_test_num
add wave -noupdate /tb_sync_high/tb_test_case
add wave -noupdate -divider {DUT Signals}
add wave -noupdate /tb_sync_high/tb_clk
add wave -noupdate /tb_sync_high/tb_n_rst
add wave -noupdate /tb_sync_high/tb_async_in
add wave -noupdate /tb_sync_high/tb_sync_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 246
configure wave -valuecolwidth 212
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {891 ps}
