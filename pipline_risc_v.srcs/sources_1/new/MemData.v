`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2022 03:02:34 PM
// Design Name: 
// Module Name: dataMem
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


/*
 a word addressable data memory with a maximum capacity of 64 words with 6 address bits
 ALU computes the byte address, we must divide it by 4 -- (discard the least significant 2 bits)  before connecting it
to the address input of the data memory to convert it to a word address.

we don't need data initialization 
*/
//MemData Memory_Data(clk, func3, memRead, memWrite, ALU_out_part, read_rs2,mem_out);

module MemData
(input clk, 
input [2:0] func3,
input memRead, //enable  
input memWrite,//enable  
input [5:0] addr, 
input [31:0] data_in, 
output reg [31:0] data_out);

reg [31:0] mem [0:63]; //64 words of size 32 bits 

initial begin
 mem[0]=32'd17;
 mem[1]=32'd9;
 mem[2]=32'd25;
 mem[3]=32'd30; 
// mem[0]=32'd0;
// mem[1]=32'd5;
// mem[2]=32'd1;
 end 

//synchronous writing: writiting with the clock 
always @(posedge clk)begin 
    if(memWrite == 1)
    begin 
        case(func3)
            3'b000: mem[addr] = { {25{data_in[7]}}, data_in[6:0]};
            3'b001: mem[addr] = { {17{data_in[15]}}, data_in[14:0]};
            3'b010: mem[addr] = data_in;
            default: mem[addr] = 0;
        endcase
    end
end 

 
always @(*)begin 
    if(memRead == 1)
    begin 
        case(func3)
            3'b000: data_out = { {25{mem[addr][7]}}, mem[addr][6:0]};
            3'b001: data_out = { {17{mem[addr][15]}}, mem[addr][14:0]};
            3'b010: data_out = mem[addr];
            3'b100: data_out = { 25'd0, mem[addr][6:0]};
            3'b101: data_out = { 17'd0, mem[addr][14:0]};
            default: data_out = 0;
        endcase
    end
    else
        data_out = 0;
end 

endmodule
