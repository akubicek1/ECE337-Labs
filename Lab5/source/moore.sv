// $Id: $
// File name:   moore.sv
// Created:     2/24/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Moore machine '1101' detector

module moore
(
    input  logic clk,
    input  logic n_rst,
    input  logic i,
    output logic o
);

    logic [2:0] state, nxt_state;  //000 = IDLE, 001 = 1, 010 = 11, 011 = 110, 100 = 1101

    always_ff @(negedge n_rst, posedge clk) begin : NXT_STATE
        if(!n_rst) begin
            state <= 3'b000;
        end
        else begin
            state <= nxt_state;
        end
    end

    always_comb begin : NXT_LOGIC
        nxt_state = state;
        if(state == 3'b000) begin       //A
            if(i == 1'b1) begin
                nxt_state = 3'b001;
            end
            else begin
                nxt_state = 3'b000;
            end
        end
        else if(state == 3'b001) begin  //B
            if(i == 1'b1) begin
                nxt_state = 3'b010;
            end
            else begin
                nxt_state = 3'b000;
            end
        end
        else if(state == 3'b010) begin  //C
            if(i == 1'b1) begin
                nxt_state = 3'b010;
            end
            else begin
                nxt_state = 3'b011;
            end
        end
        else if(state == 3'b011) begin  //D
            if(i == 1'b1) begin
                nxt_state = 3'b100;
            end
            else begin
                nxt_state = 3'b000;
            end
        end
        else if(state == 3'b100) begin  //E
            if(i == 1'b1) begin
                nxt_state = 3'b010;
            end
            else begin
                nxt_state = 3'b000;
            end
        end
        else begin
            nxt_state = 3'b000;
        end
    end

    always_comb begin : OUT_LOGIC
        o = 1'b0;
        if (state == 3'b100) begin
            o = 1'b1;
        end
    end

endmodule