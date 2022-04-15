`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2022 03:19:21 PM
// Design Name: 
// Module Name: Forward_Unit
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


module Forward_Unit(
input [4:0] ID_EX_Rs1, ID_EX_Rs2, MEM_WB_Rd,EX_MEM_Rd,
input MEM_WB_regWrite, EX_MEM_regWrite, 
output reg [1:0] forwardA, forwardB);

always @(*)begin 

forwardA = 2'b0;
    if ( MEM_WB_regWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1))
        forwardA = 2'b01;
    //else if ( MEM_WB_regWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1) )
    //  && !( EX_MEM_regWrite && (EX_MEM_Rd != 0) &&(EX_MEM_Rd == ID_EX_Rs1)) )
     // forwardA = 2'b01;
    //else 
    //forwardA = 2'b0;
        
forwardB = 2'b0;       
    if ( MEM_WB_regWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2))
        forwardB = 2'b01;
    
 //   else if ( MEM_WB_regWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2))
//        && !( EX_MEM_regWrite && (EX_MEM_Rd != 0) &&(EX_MEM_Rd == ID_EX_Rs2)) )
 //        forwardB = 2'b01;
     //else 
     //   forwardB = 2'b0;
end
endmodule
