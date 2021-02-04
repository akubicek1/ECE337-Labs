// $Id: $
// File name:   sensor_b.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Behavioral Sensor Error Detector
module sensor_b
(
	input wire [3:0] sensors,
	output reg error
);
	always_comb
	begin
		error = 0;
		if(sensors[0])
			error = 1;
		if(sensors[1] & sensors[2])
			error = 1;
		if(sensors[1] & sensors[3])
			error = 1;
	end
endmodule
