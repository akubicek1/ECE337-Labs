// $Id: $
// File name:   sensor_d.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Dataflow Sensor Error Detector
module sensor_d
(
	input wire [3:0] sensors,
	output wire error
);
	wire midstep [2:0];
	assign midstep[0] = (sensors[1] & sensors[2]) ? 1 : 0;
	assign midstep[1] = (sensors[1] & sensors[3]) ? 1 : 0;
	assign midstep[2] = (midstep[0] | midstep[1]) ? 1 : 0;
	assign error = (sensors[0] | midstep[2]) ? 1 : 0;
endmodule
