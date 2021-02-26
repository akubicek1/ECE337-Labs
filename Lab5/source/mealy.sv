// $Id: $
// File name:   mealy.sv
// Created:     2/25/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Mealy machine '1101' detector

module mealy
(
    input  logic clk,
    input  logic n_rst,
    input  logic i,
    output logic o
);

    logic [1:0] state, nxt_state;  //00 = IDLE, 01 = 1, 10 = 11, 11 = 110

    always_ff @(negedge n_rst, posedge clk) begin : NXT_STATE
        if(!n_rst) begin
            state <= 2'b00;
        end
        else begin
            state <= nxt_state;
        end
    end

    always_comb begin : NXT_LOGIC
        nxt_state = state;
        if(state == 2'b00) begin       //A
            if(i == 1'b1) begin
                nxt_state = 2'b01;
            end
            else begin
                nxt_state = 2'b00;
            end
        end
        else if(state == 2'b01) begin  //B 1
            if(i == 1'b1) begin
                nxt_state = 2'b10;
            end
            else begin
                nxt_state = 2'b00;
            end
        end
        else if(state == 2'b10) begin  //C 11
            if(i == 1'b1) begin
                nxt_state = 2'b10;
            end
            else begin
                nxt_state = 2'b11;
            end
        end
        else if(state == 2'b11) begin  //D 110
            if(i == 1'b1) begin
                nxt_state = 2'b01;
            end
            else begin
                nxt_state = 2'b00;
            end
        end
        else begin
            nxt_state = 2'b00;
        end
    end

    always_comb begin : OUT_LOGIC
        o = 1'b0;
        if (state == 2'b11) begin
            if(i == 1'b1) begin
                o = 1'b1;
            end
            else begin
                o = 1'b0;
            end
        end
    end

endmodule