`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 03:52:17 PM
// Design Name: 
// Module Name: n_bit_register
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


module Register #(parameter n = 4)(
input clk,
input rst, 
input load, //as select 
input [n-1: 0] D,
output [n-1: 0] Q
);

wire [n-1: 0] w;
genvar i; 
generate 
    for(i = 0; i < n; i = i+1)begin: loop  
        FlipFlop FF (clk, rst, w[i],Q[i]);
        MUX #(1) mux (D[i],Q[i],load,w[i]); //1 bit mux
    end

endgenerate


endmodule
