module mux_jal_jalr #
(
	parameter WIDTH = 8
)
(
   input [WIDTH-1:0]  RD1E,
   input [WIDTH-1:0]  PCE,
   input              JAL_JALR_SELE,
   output [WIDTH-1:0] JAL_JALR
);
	assign JAL_JALR = ~JAL_JALR_SELE ?  PCE:RD1E;
endmodule