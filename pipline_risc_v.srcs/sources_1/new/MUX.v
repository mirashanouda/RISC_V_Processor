`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2022 03:20:51 PM
// Design Name: 
// Module Name: exp2_nBit_2x1_Mux
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
module MUX #(parameter n = 8) ( 
input [n-1: 0] x1,
input [n-1: 0] x2,
input sel,
output [n-1: 0] y
 );
 
 genvar i; 
 generate 
    for(i = 0; i < n; i = i+1) begin: loop 
       assign y[i] = (sel == 1)? x1[i] : x2[i];  
    end
 endgenerate 
 
endmodule