`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2022 01:43:34 PM
// Design Name: 
// Module Name: exp3_control_unit
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


module Control_Unit(
input [4:0] inst, //5 bits 
output reg branch, memRead, memToReg, 
output reg [3:0] ALUop, 
output reg memWrite, ALUsrc, regWrite, JALR, WB
);

localparam R   = 5'b01100;
localparam I   = 5'b00100;
localparam L  =  5'b00000;
localparam S   = 5'b01000;
localparam B =   5'b11000;
localparam UJ =  5'b11011;
localparam RJ =  5'b11001;
localparam LUI =  5'b01101;
localparam AUIPC =  5'b00101;

always @(*) begin 
    case(inst)
    R: begin 
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0010;
        memWrite = 0; 
        ALUsrc   = 0;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end 
    
    I: begin 
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0011;
        memWrite = 0; 
        ALUsrc   = 1;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end 
            
    L: begin     
        branch   = 0;
        memRead  = 1;
        memToReg = 1;
        ALUop    = 4'b0000;
        memWrite = 0; 
        ALUsrc   = 1;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end
    
    
    S: begin     
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0001;
        memWrite = 1; 
        ALUsrc   = 1;
        regWrite = 0;
        JALR = 0;
        WB = 1;
        end
        
    B: begin     
        branch   = 1;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0100;
        memWrite = 0; 
        ALUsrc   = 0;
        regWrite = 0;
        JALR = 0;
        WB = 1;
        end 
    
    UJ: begin     
        branch   = 1;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0101;
        memWrite = 0; 
        ALUsrc   = 0;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end 
        
    RJ: begin     
        branch   = 1;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0110;
        memWrite = 0;
        ALUsrc   = 0;
        regWrite = 1;
        JALR = 1;
        WB = 0;
        end 
        
        
     LUI: begin     
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b1000;
        memWrite = 0;
        ALUsrc   = 1;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end 
     
     AUIPC: begin     
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b1001;
        memWrite = 0;
        ALUsrc   = 1;
        regWrite = 1;
        JALR = 0;
        WB = 1;
        end 
     
     
     default: begin   //NOP
        branch   = 0;
        memRead  = 0;
        memToReg = 0;
        ALUop    = 4'b0111;
        memWrite = 0;
        ALUsrc   = 0;
        regWrite = 0;
        JALR = 0;
        WB = 1;
        end 
     
    endcase
end 
endmodule
