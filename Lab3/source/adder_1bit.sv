// $Id: $
// File name:   adder_1bit.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Scalable 1 bit adder
module adder_1bit
(
	input wire a, b, carry_in,
	output wire sum, carry_out
);
	assign sum = carry_in ^ (a ^ b);
	assign carry_out = ((~carry_in) & b & a) | (carry_in & (b | a));
endmodule
