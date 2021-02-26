// $Id: $
// File name:   adder_4bit.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Scalable 4 bit adder

module adder_4bit
(
	input [3:0] a, [3:0] b,
	input carry_in,
	output [3:0] sum,
	output overflow
);
	wire [4:0] carrys;
	genvar i;
	assign carrys[0] = carry_in;
	generate
		for(i = 0; i <= 3; i = i + 1)
		begin
			adder_1bit ADDX(.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		end
	endgenerate
	assign overflow = carrys[4];
endmodule
