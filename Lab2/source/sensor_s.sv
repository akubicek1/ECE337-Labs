// $Id: $
// File name:   sensor_s.sv
// Created:     2/3/2021
// Author:      Adam Kubicek
// Lab Section: 337-008
// Version:     1.0  Initial Design Entry
// Description: Structural Sensor Error Detector
module sensor_s
(
	input wire [3:0] sensors,
	output wire error
);
	wire midstep [2:0];
	AND2X1 r1(.A(sensors[1]), .B(sensors[2]), .Y(midstep[0]));
	AND2X1 r2(.A(sensors[1]), .B(sensors[3]), .Y(midstep[1]));
	OR2X1 a1(.A(midstep[0]), .B(midstep[1]), .Y(midstep[2]));
	OR2X1 a2(.A(sensors[0]), .B(midstep[2]), .Y(error));
endmodule
