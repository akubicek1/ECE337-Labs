onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_pts_sr_4_msb/tb_test_num
add wave -noupdate /tb_pts_sr_4_msb/tb_test_case
add wave -noupdate -divider {DUT Signals}
add wave -noupdate /tb_pts_sr_4_msb/tb_clk
add wave -noupdate /tb_pts_sr_4_msb/tb_n_rst
add wave -noupdate /tb_pts_sr_4_msb/tb_load_enable
add wave -noupdate /tb_pts_sr_4_msb/tb_shift_enable
add wave -noupdate /tb_pts_sr_4_msb/tb_test_data
add wave -noupdate -divider Output
add wave -noupdate /tb_pts_sr_4_msb/tb_expected_ouput
add wave -noupdate /tb_pts_sr_4_msb/tb_serial_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 256
configure wave -valuecolwidth 188
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
WaveRestoreZoom {0 ps} {857 ps}
