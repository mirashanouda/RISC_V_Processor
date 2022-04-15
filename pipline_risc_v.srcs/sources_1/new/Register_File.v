`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 03:43:46 PM
// Design Name: 
// Module Name: register_file
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


module Register_File #(parameter n=32)(
    input clk, input rst, 
    input [4:0] read_reg1, input [4:0] read_reg2, input [4:0] write_reg,
    input [n-1:0] write_data, input write_signal,
    output [n-1:0] read_data1, output [n-1:0]read_data2
    );
    
    wire [31:0] load_reg;
    wire [n-1:0] out_reg[0:31];
    
    //Generating Registers
    Register #(n) x0 (.clk(clk), .rst(rst), .load(0), .D(0), .Q(out_reg[0]));

    generate
    genvar i;
    for(i=1;i<32;i=i+1) 
    begin
    Register #(n) x (.clk(clk), .rst(rst), .load(load_reg[i]), .D(write_data), .Q(out_reg[i]));
    //Generating the decoder in a smarter way
    assign load_reg[i] = (write_reg == i) & write_signal;
    end
    assign load_reg[0] = 0;
    endgenerate 
    
    //Generating two 32*1 muxes in a smarter way
    assign read_data1=out_reg[read_reg1];
    assign read_data2=out_reg[read_reg2];

    
endmodule
