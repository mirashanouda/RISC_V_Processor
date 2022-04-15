`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2022 03:40:41 PM
// Design Name: 
// Module Name: immediate
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

module Imm_Gen ( input [31:0] inst, output reg [31:0] gen_out); 

//LW SW BEQ
wire [5:0] flag;
assign flag = inst[6:2]; 
always @(*) begin
	case (flag)
5'b01101   :    gen_out = {inst[31:12], 12'd0}; //LUI
5'b00101   :    gen_out = {inst[31:12], 12'd0}; //AUIPC
5'b11011   : 	gen_out = { {13{inst[31]}}, inst[19: 12], inst[20] ,inst[30:21]}; //JAL
5'b11001   : 	gen_out = { {21{inst[31]}}, inst[30:20]}; //JALR
5'b00000   : 	gen_out = { {21{inst[31]}}, inst[30:20]}; //I-type
5'b00100   : 	
        begin if (inst[14:12] == 3'b001 || inst[14:12] == 3'b101)
            gen_out = inst[24:20]; //Shift amount
        else
            gen_out = { {21{inst[31]}}, inst[30:20]}; //I-type
        end 
5'b01000   :    gen_out = { {21{inst[31]}}, inst[30:25], inst[11:7] }; //S-type
5'b11000   :    gen_out = { {21{inst[31]}}, inst[7], inst[30:25], inst[11:8]}; //B-type

default    :    gen_out = 32'b0;
	endcase 
end

endmodule
