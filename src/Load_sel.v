module Load_sel (
	input  		[2:0] 	funct3M,
	input  		[31:0] 	ReadData,
	output wire [2:0] 	select_load,
	output wire [31:0] 	LW,
	output wire [31:0] 	LB,
	output wire [31:0] 	LH,
	output wire [31:0] 	LBU,
	output wire [31:0] 	LHU
);
	assign select_load = funct3M;
	assign LW = ReadData;
	assign LBU = {24'b0, ReadData[7:0]};
	assign LHU = {16'b0, ReadData[15:0]};
	assign LB = {{24{ReadData[7]}}, ReadData [7:0]};
	assign LH = {{16{ReadData[15]}}, ReadData [15:0]};
endmodule