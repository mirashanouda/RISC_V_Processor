//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 05:40:32 PM
// Design Name: 
// Module Name: ALU_control
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


module ALU_Control(           //func3      //inst[30]
input [3:0] ALUOp, input [2:0] inst1, input inst2, output reg [4:0] ALU_sel);

 always @(*) begin
       casex ({ALUOp, inst1, inst2})
            //R-type
            8'b0010_1110: ALU_sel= 5'b00000;//and 
            8'b0010_1100: ALU_sel= 5'b00001;//or 
            8'b0010_0000: ALU_sel= 5'b00010;//add 
            8'b0010_0001: ALU_sel= 5'b00110;//sub 
            8'b0010_0010: ALU_sel= 5'b00011;//SLL
            8'b0010_1010: ALU_sel= 5'b00100;//SRL
            8'b0010_0100: ALU_sel= 5'b00101;//SLT
            8'b0010_0110: ALU_sel= 5'b00111;//SLTU
            8'b0010_1000: ALU_sel= 5'b01000;//XOR
            8'b0010_1011: ALU_sel= 5'b01001;//SRA
                                  
            //I-type                 
            8'b0011_111x: ALU_sel= 5'b00000;//and i
            8'b0011_110x: ALU_sel= 5'b00001;//or i
            8'b0011_000x: ALU_sel= 5'b00010;//add i
            8'b0011_0010: ALU_sel= 5'b00011;//SLL i
            8'b0011_1010: ALU_sel= 5'b00100;//SRL i
            8'b0011_010x: ALU_sel= 5'b00101;//SLT i
            8'b0011_011x: ALU_sel= 5'b00111;//SLTU i
            8'b0011_100x: ALU_sel= 5'b01000;//XOR i
            8'b0011_1011: ALU_sel= 5'b01001;//SRA i
               
                                    
            //I-type                
            8'b0000_xxxx: ALU_sel= 5'b00010;//load
            //S-type                 
            8'b0001_xxxx: ALU_sel= 5'b00010;//store
            //B-type                 
            8'b0100_000x: ALU_sel= 5'b01010;//BEQ
            8'b0100_001x: ALU_sel= 5'b01011;//BNE
            8'b0100_100x: ALU_sel= 5'b01100;//BLT
            8'b0100_101x: ALU_sel= 5'b01101;//BGE
            8'b0100_110x: ALU_sel= 5'b01110;//BLTU
            8'b0100_111x: ALU_sel= 5'b01111;//BGEU
              
            //Jump
            8'b0101_xxxx: ALU_sel= 5'b10000;//JAL
            8'b0110_xxxx: ALU_sel= 5'b10001;//JALR
               
            //LUI
            8'b1000_xxxx: ALU_sel = 5'b10010;
            8'b1001_xxxx: ALU_sel = 5'b10011;

         default: ALU_sel= 5'b11111;
        endcase
 end
 endmodule
