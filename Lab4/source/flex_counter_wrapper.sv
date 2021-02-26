// $Id: $
// File name:   flex_counter_wrapper.sv
// Created:     2/18/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Wrapper file for flex counter

module flex_counter_wrapper
(
    input logic clk, n_rst, clear, count_enable,
    input logic [7:0] rollover_val,
    output logic [7:0] count_out,
    output logic rollover_flag
);

tb_flex_counter #(.NUM_CNT_BITS(8)) COUNT(.clk(clk), .n_rst(n_rst), .clear(clear), .count_enable(count_enable), .rollover_val(rollover_val), .count_out(count_out), .rollover_flag(rollover_flag));

endmodule