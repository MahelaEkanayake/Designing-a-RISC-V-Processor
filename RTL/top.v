// Top module.

module top(clk, reset);
input clk, reset;

wire [31:0] PC_top, instruction_top, Rd1_top, Rd2_top, Wd_top, ImmExt_top, mux1_top, Sum_out_top, NextoPC_top, PCin_top, address_top, ALU_Mux_out, Adder_out, ALU_Result_top, MemData_out_top;
wire RegWrite_top, ALUSrc_top, zero_top, branch_top, MemRead_top, MemtoReg_top, MemWrite_top, branch_zero_and_out;
wire [1:0] ALUOp_top;
wire [3:0] control_top;

// program counter
Program_Counter PC(.clk(clk), .reset(reset), .PC_in(PCin_top), PC_out(PC_top));

// PC Adder
PCplus4 PC_Adder(.fromPC(PC_top), .NextoPC(NextoPC_top));

// Instruction Memory
Instruction_Memory Inst_Memory(.clk(clk), .reset(reset), .read_address(PC_top), .instruction_out(instruction_top));

// Register File
Reg_File Reg_File(.clk(clk), .reset(reset), .RegWrite(RegWrite_top), .Rs1(instruction_top[19:15]), .Rs2(instruction_top[24:20]), .Rd(instruction_top[11:7]), .Write_data(Wd_top), .read_data1(Rd1_top), .read_data2(Rd2_top));

//Immediate Generator
ImmGen ImmGen(.instruction(instruction_top), .ImmExt(ImmExt_top));

// Control Unit
Control_Unit Control_Unit(.instruction(instruction_top[6:0]), .Branch(branch_top), .MemRead(MemRead_top), .MemtoReg(MemtoReg_top), .ALUOp(ALUOp_top), .MemWrite(MemWrite_top), .ALUSrc(ALUSrc_top), .RegWrite(RegWrite_top));

// ALU Control
ALU_Control ALU_Control(.ALUOp(ALUOp_top), .fun7(instruction_top[30]), .fun3(instruction_top[14:12]), .Control_out(control_top));

// ALU
ALU_unit ALU(.A(Rd1_top), .B(ALU_Mux_out), .Control_in(control_top), .ALU_Result(ALU_Result_top), .zero(zero_top));

//ALU Mux
mux alu_mux(.sel(ALUSrc_top), .A(ImmExt_top), .B(Rd2_top), .mux_out(ALU_Mux_out));

//Mux1
mux mux1(.sel(branch_zero_and_out), .A(Sum_out_top), .B(Adder_out), .mux_out(PCin_top));

// Data Memory
Data_Memory Data_Mem(.clk(clk), .reset(reset), .MemWrite(MemWrite_top), .MemRead(MemRead_top), .read_address(ALU_Result_top), .Write_data(Rd2_top), .MemData_out(MemData_out_top));

//Mux2
mux mux2(.sel(MemtoReg_top), .A(MemData_out_top), .B(ALU_Result_top), .mux_out(Wd_top));

//Adder Sum
Adder Adder(.in_1(PC_top), .in_2(ImmExt_top), .Sum_out(Sum_out_top));

//AND Gate
assign branch_zero_and_out = branch_top & zero_top;

endmodule