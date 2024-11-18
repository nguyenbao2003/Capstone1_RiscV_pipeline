module Store_sel (
	input  		[2:0] 	funct3E,
	input  		[31:0] 	WriteDataE,
	output wire [2:0] 	select_store,
	output wire [31:0] 	ST,
	output wire [31:0] 	SH,
	output wire [31:0] 	SB
);
	assign select_store = funct3E;
	assign ST = WriteDataE;
	assign SB = {{24{WriteDataE[7]}}, WriteDataE [7:0]};
	assign SH = {{16{WriteDataE[15]}}, WriteDataE [15:0]};
endmodule