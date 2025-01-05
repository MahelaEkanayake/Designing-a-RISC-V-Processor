// Immediate Generator

module ImmGen(Opcode, instruction, ImmExt);

input [6:0] Opcode;
input [31:0] instruction;
output [31:0] ImmExt;

always @(*)
begin
    case(Opcode)
        7'b0000011 : ImmExt = {{19{instruction[31]}}, instruction[31:20]};  // lw - I-type
        7'b0100011 : ImmExt = {{19{instruction[31]}}, instruction[31:25], instruction[11:7]};   // sw - S-type
        7'b1100011 : ImmExt = {{18{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:6], 1'b0};    // beq - SB-type
    endcase
end
endmodule