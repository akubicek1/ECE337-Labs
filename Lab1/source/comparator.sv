// Verilog for ECE337 Lab 1
// The Following code is used to compare 2 16-bit quantites, a and b. The code 
// determines whether or not:
// a is greater than b, gt = 1, lt = 0, eq = 0
// a is less than b, gt = 0, lt = 1, eq = 0
// a is equal to b, gt = 0, lt = 0, eq = 1

// Use a tab size of 2 spaces for best viewing results


module comparator
(
	input wire [15:0] a,
	input wire [15:0] b,
	output wire gt,
	output wire lt,
	output wire eq
);

	reg gte, lte;
	reg gto, lto, eqo;
	
	assign gt = gto; //assigning regs to output wires
	assign lt = lto;
	assign eq = eqo;

	always @ (a, b) begin: COM 
		if (a < b) begin //comparing inputs
			lte = 1;
			gte = 0;
		end else if (a > b) begin
			gte = 1;
			lte = 0;
		end else begin
			gte = 0;
			lte = 0;
		end

		if (gte == 1'b1) begin //setting regs
			gto = 1'b1;
			lto = 1'b0;
			eqo = 1'b0;
		end else if (lte == 1'b1) begin
			gto = 1'b0;
			lto = 1'b1;
			eqo = 1'b0;
		end else begin
			gto = 1'b0;
			lto = 1'b0;
			eqo = 1'b1;
		end
	end
	
endmodule 