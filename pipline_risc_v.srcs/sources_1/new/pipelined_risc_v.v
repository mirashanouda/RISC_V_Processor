//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2022 04:34:00 PM
// Design Name: 
// Module Name: RISC_V_Processor
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


module piplined_risc_v (input clk, input rst ,input [3:0] ssdSel, input [1:0] ledSel, input ssdclk, 
                         output reg [15:0] leds, output [3:0] Anode, output [6:0] LED_out );
//PC Register
wire [31:0] PC_addr;
wire [31:0] PC_new;
wire [31:0] Pre_PC_new;
wire [5:0] PC_part; 
wire carry_ignore1;
wire [31:0] second_sum; // PC+4
wire [31:0] IF_ID_second_sum;

//Instruction Memory
reg [31:0] instruction;

//Extra definitions
wire [31:0] EX_MEM_BranchAddOut;
wire [31:0] EX_MEM_ALU_out, EX_MEM_ReadR2, new_instruction;
wire EX_MEM_branch, EX_MEM_memRead, EX_MEM_memToReg, EX_MEM_memWrite, EX_MEM_regWrite, EX_MEM_JALR, EX_MEM_WB; 
wire AND_out;
wire PC_sel;  
wire [6:0] opcode;
                

assign PC_part = PC_addr[7:2];
Ripple_Carry_Adder_Sub #(32) Second_add (4, PC_addr, 0, second_sum, carry_ignore1);
MUX #(32) MUX_new_PC (EX_MEM_BranchAddOut, second_sum, AND_out, Pre_PC_new);
MUX #(32) MUX_new_PC2 (EX_MEM_ALU_out, Pre_PC_new, EX_MEM_JALR, PC_new); //////////////////////////////////// Another mux to update PC with alu_out (in jal) 

//MemInst memory_Instruction (PC_part, instruction); //this is the instruciton
wire [5:0] ALU_out_part, mem_addr;
wire [31:0] mem_out_data;
wire [2:0] EX_MEM_Func3;
wire [31:0] ID_EX_PC, ID_EX_ReadR1, ID_EX_ReadR2, ID_EX_Imm;
wire [31:0] alu1, alu2;
wire [31:0] EX_MEM_second_sum, EX_MEM_alu2;

MUX #(6) mem_address (PC_part, ALU_out_part, clk, mem_addr);
singleMem memory_instruction (clk, EX_MEM_Func3, EX_MEM_memRead, EX_MEM_memWrite, mem_addr, EX_MEM_alu2, mem_out_data);

reg [31:0] mem_out;
always @(*)
begin 
if (clk)
    instruction = mem_out_data;
else 
    mem_out = mem_out_data; 
end

assign PC_sel = (instruction[20] == 1 && opcode == 7'b1110011)? 0 : 1; //(for EBREAK)
Register #(32) PC (clk, rst, PC_sel, PC_new, PC_addr);


//singleMem memory_instruction (clk2, 3'b111, 1'b1, 0, PC_part, 0, instruction); 
 
//Mux for NOP:
MUX #(32) flushing (32'b0000000_00000_00000_000_00000_0110011, instruction, AND_out, new_instruction);

//IF_ID register  
wire [31:0] IF_ID_PC, IF_ID_Inst;  
Register #(96) ifid (~clk, rst,1, {PC_addr, new_instruction, second_sum} ,{IF_ID_PC,IF_ID_Inst, IF_ID_second_sum});

////////////////////////////////////////////Decoding/////////////////////////////////////////////////
wire [4:0] MEM_WB_Rd; //Extra definition
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
assign opcode = IF_ID_Inst [6:0]; 
assign rs1    = IF_ID_Inst [19:15]; 
assign rs2    = IF_ID_Inst [24:20]; 
assign rd     = IF_ID_Inst [11:7]; 
 
//Immediate Generator:
wire [31:0] Imm; 
Imm_Gen Immediate_Generator (IF_ID_Inst, Imm); 

//Control Unit:
wire branch, memRead, memToReg; 
wire [3:0] ALUop;
wire memWrite, ALUsrc, regWrite, JALR, WB;
Control_Unit Signals (opcode [6:2], branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite, JALR, WB);

//Register File:
wire [31:0] read_rs1;
wire [31:0] read_rs2;
wire [31:0] WriteData;
wire MEM_WB_regWrite;
Register_File #(32) RF (~clk, rst, rs1, rs2, MEM_WB_Rd, WriteData, MEM_WB_regWrite, read_rs1, read_rs2);

wire inst30; 
wire [2:0] func3; 
assign inst30 = IF_ID_Inst[30];
assign func3 = IF_ID_Inst[14:12]; 

wire [11:0] ID_EX_Ctrl;
wire [2:0] ID_EX_Func3;
wire ID_EX_inst30;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
wire [31:0] ID_EX_second_sum;
wire ID_EX_branch, ID_EX_memRead, ID_EX_memToReg;
wire [3:0] ID_EX_ALUop;
wire ID_EX_memWrite, ID_EX_ALUsrc, ID_EX_regWrite, ID_EX_JALR, ID_EX_WB;

//ID_EX
Register #(191) ID_EX (clk,rst,1'b1, 
{{branch, memRead, memToReg, ALUop, memWrite, ALUsrc, regWrite, JALR, WB}, //12 
IF_ID_PC,read_rs1, read_rs2, Imm, func3, inst30, rs1, rs2, rd, IF_ID_second_sum}, //32+32+32+32+3+1+5+5+5+32
{ID_EX_branch, ID_EX_memRead, ID_EX_memToReg, ID_EX_ALUop, ID_EX_memWrite, ID_EX_ALUsrc, ID_EX_regWrite, ID_EX_JALR, ID_EX_WB,
ID_EX_PC,ID_EX_ReadR1,ID_EX_ReadR2, ID_EX_Imm, ID_EX_Func3, ID_EX_inst30,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_second_sum} );

////////////////////////////////////////////Executing/////////////////////////////////////////////////  
//MUX for the immediate or read_rs2:

//ALU control:
wire [4:0] ALU_sel;
ALU_Control control (ID_EX_ALUop,ID_EX_Func3, ID_EX_inst30, ALU_sel);
//input [1:0] ALUOp, input [2:0] inst1, input inst2, output reg [3:0] ALU_sel


wire [1:0] forwardA, forwardB;
wire [4:0] EX_MEM_Rd;

//Forwarding Unit
Forward_Unit fu (ID_EX_Rs1, ID_EX_Rs2,MEM_WB_Rd, EX_MEM_Rd, MEM_WB_regWrite, EX_MEM_regWrite,
                forwardA, forwardB);
                
//Forwarding MUXs before the ALU:
MUX4 #(32) muxRS1(ID_EX_ReadR1, WriteData, EX_MEM_ALU_out, 32'b0, forwardA, alu1);
MUX4 #(32) muxRS2 (ID_EX_ReadR2, WriteData, EX_MEM_ALU_out, 32'b0, forwardB, alu2);

//edit this wire 
wire [31:0] ALU_2nd_input; 
MUX #(32) mux_ALU_2nd_input (ID_EX_Imm, alu2, ID_EX_ALUsrc, ALU_2nd_input);

//ALU
wire [31:0] ALU_out;
wire zero_flag;
ALU #(32) ALU_Proc (ALU_sel, alu1, ALU_2nd_input,ID_EX_PC, ALU_out, zero_flag);

//Shift_Left_1
wire [31:0] imm_shifted;
Shift_Left_1 #(32) shifting (ID_EX_Imm, imm_shifted);

//Adder to add the imm
wire carry_ignore;
wire [31:0] branchAddOut;
Ripple_Carry_Adder_Sub #(32) First_add (imm_shifted, ID_EX_PC, 0, branchAddOut, carry_ignore);


wire EX_MEM_Zero;
assign AND_out = ID_EX_branch & zero_flag;

//signals
 Register #(176) EX_MEM (~clk,rst,1'b1, //7, 32,1, 32, 32, 5+32+3+32
 {ID_EX_branch, ID_EX_memRead, ID_EX_memToReg, ID_EX_memWrite, ID_EX_regWrite, ID_EX_JALR, ID_EX_WB,
 branchAddOut, zero_flag, ALU_out, ID_EX_ReadR2, ID_EX_Rd, ID_EX_second_sum, ID_EX_Func3, alu2},
 
 {EX_MEM_branch, EX_MEM_memRead, EX_MEM_memToReg, EX_MEM_memWrite, EX_MEM_regWrite, EX_MEM_JALR, EX_MEM_WB, 
 EX_MEM_BranchAddOut, EX_MEM_Zero, EX_MEM_ALU_out, EX_MEM_ReadR2, EX_MEM_Rd, EX_MEM_second_sum, EX_MEM_Func3, EX_MEM_alu2} );
 
 
////////////////////////////////////////////Memory/////////////////////////////////////////////////  
//Data Memory: 
//MUX to choose the new PC
//assign AND_out = EX_MEM_branch & EX_MEM_Zero;
assign ALU_out_part = EX_MEM_ALU_out[7:2];
//MemData Memory_Data(clk, EX_MEM_Func3, EX_MEM_memRead, EX_MEM_memWrite, ALU_out_part, EX_MEM_ReadR2,mem_out);

wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
wire MEM_WB_memToReg, MEM_WB_WB;
wire [31:0] MEM_WB_second_sum;
 Register #(104) MEM_WB (clk,rst,1'b1, //3+32+32+5+32
{EX_MEM_memToReg, EX_MEM_regWrite, EX_MEM_WB, mem_out, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_second_sum},
{MEM_WB_memToReg, MEM_WB_regWrite, MEM_WB_WB, MEM_WB_Mem_out, MEM_WB_ALU_out,
 MEM_WB_Rd, MEM_WB_second_sum}); 


////////////////////////////////////////////Write Back/////////////////////////////////////////////////  
wire [31:0] preWriteData;
//MUX for the memory data or ALU data:

MUX #(32) MUX_write_data (MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_memToReg, preWriteData); /////////////////////////////// There is another mux to choose between it and PC+4 (in jalr)
MUX #(32) MUX_write_data1 (preWriteData, MEM_WB_second_sum, MEM_WB_WB, WriteData);



reg [12:0] ssd;
always @(*)begin 
case (ssdSel)
4'b0000: ssd = PC_addr       [12:0];
4'b0001: ssd = second_sum    [12:0];
4'b0010: ssd = branchAddOut  [12:0];
4'b0011: ssd = PC_new        [12:0];
4'b0100: ssd = read_rs1      [12:0];
4'b0101: ssd = read_rs2      [12:0];
4'b0110: ssd = WriteData     [12:0];
4'b0111: ssd = Imm           [12:0];
4'b1000: ssd = imm_shifted   [12:0];
4'b1001: ssd = ALU_2nd_input [12:0];
4'b1010: ssd = ALU_out       [12:0];
4'b1011: ssd = mem_out       [12:0];
default: ssd = 0;
endcase 

case (ledSel)
2'b00: leds = instruction [15:0];
2'b01: leds = instruction [31:16];
2'b10: leds = {1'b0, ALUop, branch, memRead, memToReg, memWrite, ALUsrc, regWrite ,ALU_sel, zero_flag, AND_out};
default: leds = 0; 
endcase 
end

Four_Digit_Seven_Segment_Driver BCD (ssdclk, ssd, Anode, LED_out); 

endmodule
