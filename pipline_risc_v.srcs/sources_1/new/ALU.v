`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 03:41:16 PM
// Design Name: 
// Module Name: exp1_N-bit_ALU
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

//addition,subtraction, ANDing, and ORing
//e 0010, 0110, 0000, and 0001
module ALU #(parameter n = 32)(
input [4:0] sel,
input [n-1: 0] A,
input [n-1: 0] B,
input [n-1: 0] PC,
output reg [n-1: 0] out,
output reg zero_flag
);

/*
localparam ADD = 4'b0010;
localparam SUB = 4'b0110;
localparam AND = 4'b0000;
localparam OR  = 4'b0001;

*/
wire [n-1: 0] rcas_out;
wire carry_out;
wire carry_ignore;
wire carry_ignore1;
wire [n-1: 0] PC_updated;
wire [n-1: 0] auipc_out;
wire cin; 
assign cin = sel[2];
Ripple_Carry_Adder_Sub #(n) inst_rcas (A, B, cin, rcas_out, carry_out);
Ripple_Carry_Adder_Sub #(n) pc_count (PC, 4, 0, PC_updated, carry_ignore);
Ripple_Carry_Adder_Sub #(n) auipc (B, PC, 0, auipc_out, carry_ignore1);

wire [31:0] op_b;
wire sf, vf;
    
assign op_b = (~B);
assign sf = rcas_out[31];
assign vf = (A[31] ^ (op_b[31]) ^ rcas_out[31] ^ carry_out);
   
//wire shift;
//shifter shifter0(A, B, sel[1:0], shift);

always @(*)begin 
    case (sel) 
        5'b00000: out = A & B;//and
        5'b00001: out = A | B;//or
        5'b00010: out = rcas_out;//add
        5'b00110: out = rcas_out;//sub
        5'b00011: out = A << B; //SLL (left logicl) 
        5'b00100: out = A >> B; //SRL (Rgiht logical)
        5'b00101: out = {31'b0,(sf != vf)}; //SLT less than
        5'b00111: out = {31'b0,(~carry_out)};//SLTU less than unsigned 
        5'b01000: out = A ^ B; //XOR
        5'b01001: out = A >>> B; //SRA (Rgiht arithmatic)
        5'b01010: zero_flag = (A == B) ? 1 : 0;//BEQ
        5'b01011: zero_flag = (A != B) ? 1 : 0;//BNE
        5'b01100: zero_flag = (sf != vf) ? 1 : 0;//BLT
        5'b01101: zero_flag = (sf == vf) ? 1 : 0;//BGE ??????????????
        5'b01110: zero_flag = ~carry_out;//BLTU
        5'b01111: zero_flag = carry_out; //BGEU 
        5'b10000: begin //JAL
                  zero_flag = 1;
                  out = PC_updated;
                  end 
        5'b10001: begin //JALR
                  zero_flag = 0;
                  out = rcas_out;
                  end
        5'b10010: out = B;
        5'b10011: out = auipc_out;
                  
    default: begin 
        out = 0;
        zero_flag = 0;
    end
    endcase
end 



endmodule
