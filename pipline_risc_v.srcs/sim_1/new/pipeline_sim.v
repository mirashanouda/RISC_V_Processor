`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2022 05:39:42 PM
// Design Name: 
// Module Name: Processor_test
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


module pipeline_sim();
reg clk, rst;

piplined_risc_v processor (clk, rst);
initial begin
clk = 0;
rst = 1;
#10;
rst = 0;
#80 //4* number of instructions + 12
$finish;
end

always 
#2  clk =  ! clk; 
endmodule
