module mux_alu_imm 
(
	input [31:0]  ALUResultM1,
   input [31:0]  ImmExtM,
   input         loadimm_selM,
   output [31:0] ALUResultM
);
	assign ALUResultM = loadimm_selM ?  ImmExtM:ALUResultM1;
endmodule