// $Id: $
// File name:   flex_stp_sr.sv
// Created:     2/21/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: flexible serial to parallel shift register

module flex_stp_sr
#(
	parameter NUM_BITS  = 4,
    parameter SHIFT_MSB = 1
)
(
    input logic clk,
    input logic n_rst,
    input logic serial_in,
    input logic shift_enable,
    output logic [(NUM_BITS-1):0] parallel_out
);

    logic [(NUM_BITS-1):0] nxt_parallel_out;

    always_ff @( posedge clk, negedge n_rst ) begin : NXT_REG
        if (!n_rst) begin
            parallel_out <= '1;
        end
        else begin
            parallel_out <= nxt_parallel_out;
        end
    end

    always_comb begin : NXT_LOGIC
        if (shift_enable) begin
            if (SHIFT_MSB) begin
                nxt_parallel_out = {parallel_out[(NUM_BITS-2):0], serial_in};
            end
            else begin
                nxt_parallel_out = {serial_in, parallel_out[(NUM_BITS-1):1]};
            end
        end  
        else begin
            nxt_parallel_out = parallel_out;
        end          
    end
endmodule
