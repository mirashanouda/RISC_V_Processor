`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 03:43:52 PM
// Design Name: 
// Module Name: MUX4
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



//module representing a n-bit 2x1 multiplexer.
//an array of 2x1 multiplexers. use generate loop
module MUX4 #(parameter n = 32) ( 
input [n-1: 0] x0,
input [n-1: 0] x1,
input [n-1: 0] x2,
input [n-1: 0] x3,
input [1:0] sel,

output reg [n-1: 0] y);

always @(*) begin  
    if (sel == 2'b00)
        y = x0; 
    else if (sel == 2'b01)
        y = x1;
    else if (sel == 2'b10)
        y = x2;
    else 
        y = x3; 
 end 
 
endmodule
