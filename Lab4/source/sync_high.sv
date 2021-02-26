// $Id: $
// File name:   sync_high.sv
// Created:     2/17/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Reset to high ff syncronizer

module sync_high
(
    input logic clk, n_rst, async_in,
    output logic sync_out
);

    logic nxt_data;

    always_ff @(posedge clk, negedge n_rst) begin : synchronizer
        if(n_rst == 1'b0) begin
            sync_out <= 1'b1;
            nxt_data <= 1'b1;
        end
        else begin
            if(async_in == 1'b1) begin
                nxt_data <= 1'b1;
                sync_out <= nxt_data;
            end
            else if(async_in == 1'b0) begin
                nxt_data <= 1'b0;
                sync_out <= nxt_data;
            end
            else begin
                nxt_data <= 1'b1;
                sync_out <= 1'b1;
            end
        end
    end

endmodule