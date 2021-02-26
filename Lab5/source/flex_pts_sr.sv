// $Id: $
// File name:   flex_pts_sr.sv
// Created:     2/21/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: flexible parallel to serial shift register


module flex_pts_sr
#(
	parameter NUM_BITS = 4,
    parameter SHIFT_MSB = 1
)
(
    input logic clk,
    input logic n_rst,
    input logic shift_enable,
    input logic load_enable,
    input logic [(NUM_BITS-1):0] parallel_in,
    output logic serial_out 
);

    logic [(NUM_BITS-1):0] serial_package, nxt_serial_package;

    always_ff @( posedge clk, negedge n_rst ) begin : NXT_REG
        if (!n_rst) begin
            serial_package <= '1;
        end
        else begin
            serial_package <= nxt_serial_package;
        end
    end

    always_comb begin : NXT_LOGIC
        if(load_enable) begin
            nxt_serial_package = parallel_in;
        end
        else begin
            if (shift_enable) begin
                if (SHIFT_MSB) begin
                    nxt_serial_package = {serial_package[(NUM_BITS-2):0], 1'b1};
                end
                else begin
                    nxt_serial_package = {1'b1, serial_package[(NUM_BITS-1):1]};
                end
            end
            else begin
                nxt_serial_package = serial_package;
            end
        end
    end

    always_comb begin : OUT_LOGIC
        if (SHIFT_MSB) begin
            serial_out = serial_package[NUM_BITS-1];
        end
        else begin
            serial_out = serial_package[0];
        end
    end

endmodule