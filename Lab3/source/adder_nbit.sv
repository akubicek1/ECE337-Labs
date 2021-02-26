// $Id: $
// File name:   adder_nbit.sv
// Created:     2/4/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Scalable n bit adder

`timescale 1ns / 100ps

module adder_nbit
#(
	parameter BIT_WIDTH = 4
)
(
	input wire [(BIT_WIDTH-1):0] a,
	input wire [(BIT_WIDTH-1):0] b,
	input wire carry_in,
	output wire [(BIT_WIDTH-1):0] sum,
	output wire overflow
);

	wire [BIT_WIDTH:0] carrys;
	genvar i;
	assign carrys[0] = carry_in;
	assign overflow = carrys[BIT_WIDTH];
	generate
		for(i = 0; i <= (BIT_WIDTH-1); i = i + 1)
		begin
			adder_1bit ADDX(.a(a[i]), .b(b[i]), .carry_in(carrys[i]), .sum(sum[i]), .carry_out(carrys[i+1]));
		end
	endgenerate

	//input assertions
	always @(a) begin
		assert((a >= 1'b0) && (a < (2 ** BIT_WIDTH)))
		else $error("Input 'a' is not an n-bit value (adder_nbit)");
	end
	always @(b) begin
		assert((b >= 1'b0) && (b < (2 ** BIT_WIDTH)))
		else $error("Input 'b' is not an n-bit value (adder_nbit)");
	end
	always @(carry_in) begin
		assert((carry_in == 1'b1) || (carry_in == 1'b0))
		else $error("Input 'carry_in' is not a 1 bit value (adder_nbit)");
	end
			
	//output assertions
	genvar m;
	for (m=0; m<16; m = m + 1) begin
		always @(a[m], b[m], carrys[m]) begin
			#(2) assert(((a[m] + b[m] + carrys[m]) % 2) == sum[m])
			else $error("Output 'sum[%d]' of 1 bit adder is wrong (adder_nbit)", m);
		end
	end
	
	genvar k;
	for (k=0; k<16; k = k + 1) begin
		always @(a[k], b[k], carrys[k]) begin
			#(2) assert((((~carrys[k]) & b[k] & a[k]) | (carrys[k] & (b[k] | a[k]))) == carrys[k+1])
			else $error("Output 'carrys[%d]' of 1 bit adder is wrong (adder_nbit)", k);
		end
	end

endmodule
