// Multiplexer

module mux(sel, A, B, mux_out);

input sel;
input [31:0] A, B;
output [31:0] mux_out;

assign mux_out = (sel==1'b0) ? A : B;

endmodule