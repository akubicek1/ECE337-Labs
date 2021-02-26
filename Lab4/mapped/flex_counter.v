/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Thu Feb 18 18:42:06 2021
/////////////////////////////////////////////////////////////


module flex_counter ( clk, n_rst, clear, count_enable, rollover_val, count_out, 
        rollover_flag );
  input [3:0] rollover_val;
  output [3:0] count_out;
  input clk, n_rst, clear, count_enable;
  output rollover_flag;
  wire   n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57,
         n58;

  DFFSR \count_out_reg[0]  ( .D(n34), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[0]) );
  DFFSR \count_out_reg[1]  ( .D(n33), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[1]) );
  DFFSR \count_out_reg[2]  ( .D(n32), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[2]) );
  DFFSR rollover_flag_reg ( .D(n30), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        rollover_flag) );
  DFFSR \count_out_reg[3]  ( .D(n31), .CLK(clk), .R(n_rst), .S(1'b1), .Q(
        count_out[3]) );
  OAI22X1 U34 ( .A(n35), .B(n36), .C(n37), .D(n38), .Y(n34) );
  OAI22X1 U35 ( .A(n36), .B(n39), .C(n38), .D(n40), .Y(n33) );
  OAI22X1 U36 ( .A(n36), .B(n41), .C(n42), .D(n38), .Y(n32) );
  INVX1 U37 ( .A(count_out[2]), .Y(n41) );
  OAI22X1 U38 ( .A(n36), .B(n43), .C(n44), .D(n38), .Y(n31) );
  INVX1 U39 ( .A(count_out[3]), .Y(n43) );
  OAI22X1 U40 ( .A(n36), .B(n45), .C(n46), .D(n47), .Y(n30) );
  NAND2X1 U41 ( .A(n48), .B(n49), .Y(n47) );
  XOR2X1 U42 ( .A(n44), .B(rollover_val[3]), .Y(n49) );
  XOR2X1 U43 ( .A(n50), .B(n51), .Y(n44) );
  NOR2X1 U44 ( .A(n52), .B(n53), .Y(n51) );
  NAND2X1 U45 ( .A(count_out[3]), .B(n45), .Y(n50) );
  XOR2X1 U46 ( .A(n42), .B(rollover_val[2]), .Y(n48) );
  XNOR2X1 U47 ( .A(n52), .B(n53), .Y(n42) );
  NAND2X1 U48 ( .A(count_out[2]), .B(n45), .Y(n53) );
  NAND3X1 U49 ( .A(n54), .B(n55), .C(n56), .Y(n46) );
  XOR2X1 U50 ( .A(n40), .B(rollover_val[1]), .Y(n56) );
  OAI21X1 U51 ( .A(n37), .B(n57), .C(n52), .Y(n40) );
  NAND2X1 U52 ( .A(n37), .B(count_out[1]), .Y(n52) );
  NOR2X1 U53 ( .A(rollover_flag), .B(n39), .Y(n57) );
  INVX1 U54 ( .A(count_out[1]), .Y(n39) );
  XOR2X1 U55 ( .A(rollover_val[0]), .B(n37), .Y(n55) );
  NOR2X1 U56 ( .A(n35), .B(rollover_flag), .Y(n37) );
  INVX1 U57 ( .A(count_out[0]), .Y(n35) );
  INVX1 U58 ( .A(n38), .Y(n54) );
  INVX1 U59 ( .A(rollover_flag), .Y(n45) );
  NAND2X1 U60 ( .A(n38), .B(n58), .Y(n36) );
  NAND2X1 U61 ( .A(count_enable), .B(n58), .Y(n38) );
  INVX1 U62 ( .A(clear), .Y(n58) );
endmodule

