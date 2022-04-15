`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2022 05:33:53 PM
// Design Name: 
// Module Name: single_mem
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


module singleMem(
input clk, 
input [2:0] func3,
input memRead, //enable  
input memWrite,//enable  
input [5:0] addr, 
input [31:0] data_in, 
output reg [31:0] data_out
 );
    
 reg [31:0] mem [0:63]; 

initial begin 
//mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0  
// //added to be skipped since PC starts with 4 after reset
//mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)        PC = 4 --- x1 = 17
//mem[2]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)        PC = 8 --- x2 = 9
//mem[3]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)        PC = 12 --- x3 = 25
//mem[4]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2      PC = 16 --- x4 = 25
//mem[5]=32'h00320863;                               //beq x4, x3, 16     PC = 20 --- PC = 36 
//mem[6]=32'b0000000_00010_00001_000_00111_0110011 ; //add x7, x1, x2     PC = 24 --- x7 = 26 (ignore)
//mem[7]=32'b000000001100_00000_010_00011_0000011 ;  //lw x3, 12(x0)      PC = 28 --- x3 = 30
//mem[8]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2    PC = 32 --- x5 = 39 (forwarding)
//mem[9]=32'b0000000_00001_00011_000_00110_0110011 ; //add x6, x3, x1    PC = 36 --- x6 = 42 (forwarding)
//mem[10]=32'b0000000_00110_00000_010_01100_0100011; //sw x6, 12(x0)     PC = 40 --- 12(0) = 42
////mem[11]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0   
////mem[12]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//mem[11]=32'b000000001100_00000_010_00111_0000011 ; //lw x7, 12(x0)     PC = 44 --- x7 = 42
//mem[12]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//mem[13]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0 
    
//mem[50]=32'd17;
//mem[51]=32'd9;
//mem[52]=32'd25;
//mem[53]=32'd30;


//mem[0]=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
//    //added to be skipped since PC starts with 4 after reset
//mem[1]=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)      PC = 4 --- x1 = 17  
//mem[2]=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)      PC = 8 --- x2 = 9   
//mem[3]=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)      PC = 12 --- x3 = 25 
//mem[4]=32'b0000000_00010_00001_110_00100_0110011 ; //or x4, x1, x2    PC = 16 --- x4 = 25
//mem[5]=32'h00320863;                               //beq x4, x3, 16   PC = 20 --- PC = 36 
//mem[6]=32'b0000000_00010_00001_000_00011_0110011 ; //add x3, x1, x2   PC = 24
//mem[7]=32'b0000000_00010_00011_000_00101_0110011 ; //add x5, x3, x2   PC = 28
//mem[8]=32'b0000000_00101_00000_010_01100_0100011; //sw x5, 12(x0)     PC = 32
//mem[9]=32'b000000001100_00000_010_00110_0000011 ; //lw x6, 12(x0)     PC = 36 
//mem[10]=32'b0000000_00001_00110_111_00111_0110011 ; //and x7, x6, x1  PC = 40
//mem[11]=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2  PC = 44
//mem[12]=32'b0000000_00010_00001_000_00000_0110011 ; //add x0, x1, x2  PC = 48
//mem[13]=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1  PC = 52
//mem[14]=32'b00000000000100000000000001110011; //Ebreak 
//mem[15]=32'b000000000000_00000_010_00001_0000011 ; 
//mem[16]=32'b000000000100_00000_010_00010_0000011 ; 
//mem[17]=32'b000000001000_00000_010_00011_0000011 ; 
//mem[18]=32'b0000000_00010_00001_110_00100_0110011;   
end 
   
   //synchronous writing: writiting with the clock 
//   always @(posedge clk)begin 
//       if(memWrite == 1)
//       begin 
//           case(func3)
//               3'b000: mem[addr+50] = { {25{data_in[7]}}, data_in[6:0]};
//               3'b001: mem[addr+50] = { {17{data_in[15]}}, data_in[14:0]};
//               3'b010: mem[addr+50] = data_in;
//               default: mem[addr+50] = 0;
//           endcase
//       end
//   end 
   
//    assign reading = memRead || clk; 
//   always @(*)begin 
//       if(reading == 1)
//       begin 
//           if (clk)
//                data_out = mem[addr];
//           else begin
//           case(func3)
//               3'b000: data_out = { {25{mem[addr+50][7]}}, mem[addr+50][6:0]};
//               3'b001: data_out = { {17{mem[addr+50][15]}}, mem[addr+50][14:0]};
//               3'b010: data_out = mem[addr+50];
//               3'b100: data_out = { 25'd0, mem[addr+50][6:0]};
//               3'b101: data_out = { 17'd0, mem[addr+50][14:0]};
//               default: data_out = 0;
//           endcase
//           end
//       end
//       else
//           data_out = 0;
//   end 

wire reading; 
assign reading = memRead || clk; 
   always @(*)begin 
       if(~clk & memWrite)//removed: //  write first  
       begin 
           case(func3)
               3'b000: mem[addr+50] = { {25{data_in[7]}}, data_in[6:0]};
               3'b001: mem[addr+50] = { {17{data_in[15]}}, data_in[14:0]};
               3'b010: mem[addr+50] = data_in;
               //default: mem[addr+50] = 0;
           endcase
       end
   
   if(reading == 1)
   begin 
       if (clk)
            data_out = mem[addr];
       else begin
       case(func3)
           3'b000: data_out = { {25{mem[addr+50][7]}}, mem[addr+50][6:0]};
           3'b001: data_out = { {17{mem[addr+50][15]}}, mem[addr+50][14:0]};
           3'b010: data_out = mem[addr+50];
           3'b100: data_out = { 25'd0, mem[addr+50][6:0]};
           3'b101: data_out = { 17'd0, mem[addr+50][14:0]};
           default: data_out = 0;
       endcase
       end
   end
   else
       data_out = 0;
   end 
endmodule
