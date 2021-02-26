// $Id: $
// File name:   adder_nbit.sv
// Created:     2/11/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Scalable n bit adder

module adder_16bit
(
	input wire [15:0] a,
	input wire [15:0] b,
	input wire carry_in,
	output wire [15:0] sum,
	output wire overflow
);

	adder_nbit #(.BIT_WIDTH(16)) ADD(.a(a[15:0]), .b(b[15:0]), .carry_in(carry_in), .sum(sum[15:0]), .overflow(overflow));
	// STUDENT: Fill in the correct port map with parameter override syntax for using your n-bit ripple carry adder design to be an 8-bit ripple carry adder design

	//Input assertions
	always @(carry_in) begin
		assert((carry_in == 1'b1) || (carry_in == 1'b0))
		else $error("Input 'carry_in' is not a 1 bit value (adder_nbit)");
	end
	always @(a) begin
		assert((a >= 1'b0) && (a < (2 ** 16)))
		else $error("Input 'a' is not a 16 bit value (adder_nbit)");
	end
	always @(b) begin
		assert((b >= 1'b0) && (b < (2 ** 16)))
		else $error("Input 'b' is not a 16 bit value (adder_nbit)");
	end
endmodule
