`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 03:18:41 PM
// Design Name: 
// Module Name: RCA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//adder subtractor
module Ripple_Carry_Adder_Sub #(parameter n = 32)(input [n-1:0]x,[n-1:0]y,
input cin, 
output [n-1:0] sum, 
output carry);

wire [n-1:0]temp;
wire [7:0] comp_2s;
wire [n-1:0] num2;
wire [n-1:0] add;

assign num2 = (cin)? (~y): y;  //2 complement

//exp2_nBit_2x1_Mux #(1) inst (comp_2s, y, cin, num2);

FullAdder add1(x[0],num2[0],cin,temp[0],sum[0]);

genvar i;
generate
    for (i=1;i<n-1;i=i+1) begin: loop1
        FullAdder add2(x[i],num2[i],temp[i-1],temp[i],sum[i]);
    end
    endgenerate
    FullAdder add3(x[n-1],num2[n-1],temp[n-2],carry,sum[n-1]);
endmodule
