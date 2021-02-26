// $Id: $
// File name:   flex_counter.sv
// Created:     2/17/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Flex counter with rollover

module flex_counter
#(
	parameter NUM_CNT_BITS = 4
)
(
    input logic clk, n_rst, clear, count_enable,
    input logic [(NUM_CNT_BITS-1):0] rollover_val,
    output logic [(NUM_CNT_BITS-1):0] count_out,
    output logic rollover_flag
);

logic [(NUM_CNT_BITS-1):0] next_count;
logic next_rollover;

always_ff @(posedge clk, negedge n_rst) begin : nextCount
    if(n_rst == 1'b0) begin
        count_out <= 0;
        rollover_flag <= 1'b0;
    end
    else begin
        count_out <= next_count;
        rollover_flag <= next_rollover;
    end
end

always_comb begin : nextCount_logic
    next_count = count_out;
    next_rollover = rollover_flag;
    if(count_enable && !clear) begin
        if(rollover_flag == 1'b0) begin
            next_count = count_out + 1;     //counter increased
        end
        else begin
            next_count = 1'b1;              //roll count over
        end

        if(next_count == rollover_val)
            next_rollover = 1'b1;           //rollover flag SET
        else begin
            next_rollover = 1'b0;           //rollover reset
        end
    end

    else if(clear == 1'b1) begin
        next_count = 0;                     //count cleared
        next_rollover = 1'b0; 
    end
end
    

endmodule