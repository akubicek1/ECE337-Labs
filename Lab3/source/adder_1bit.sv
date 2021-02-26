// $Id: $
// File name:   adder_1bit.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Adds 2 bits + carry_in

`timescale 1ns / 100ps

module adder_1bit
(
	input wire a, b, carry_in,
	output wire sum, carry_out
);
	always @(a) begin
		assert((a == 1'b1) || (a == 1'b0))
		else $error("Input 'a' is not a 1 bit value (adder_1bit)");
	end
	always @(b) begin
		assert((b == 1'b1) || (b == 1'b0))
		else $error("Input 'b' is not a 1 bit value (adder_1bit)");
	end
	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((~carry_in) & b & a) | (carry_in & (b | a));
endmodule
