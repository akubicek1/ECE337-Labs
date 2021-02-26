onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Orange /tb_adder_16bit/tb_test_case
add wave -noupdate -color Orange /tb_adder_16bit/tb_test_case_stage
add wave -noupdate -divider {DUT Signals}
add wave -noupdate -expand -group Inputs -color Gold /tb_adder_16bit/tb_a
add wave -noupdate -expand -group Inputs -color Gold /tb_adder_16bit/tb_b
add wave -noupdate -expand -group Inputs -color Khaki /tb_adder_16bit/tb_carry_in
add wave -noupdate -expand -group {Outputs: Real vs. Ideal} -color Turquoise /tb_adder_16bit/tb_overflow
add wave -noupdate -expand -group {Outputs: Real vs. Ideal} -color Turquoise /tb_adder_16bit/tb_sum
add wave -noupdate -expand -group {Outputs: Real vs. Ideal} -color {Lime Green} /tb_adder_16bit/tb_expected_overflow
add wave -noupdate -expand -group {Outputs: Real vs. Ideal} -color {Lime Green} /tb_adder_16bit/tb_expected_sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 248
configure wave -valuecolwidth 142
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
WaveRestoreZoom {0 ps} {6027 ps}
