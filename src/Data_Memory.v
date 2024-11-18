module Data_Memory (
    input 		[31:0]	WriteDataM,
    input 		[31:0] 	ALUResultM,
    input 					clk,
    input 					MemWriteM,
    input 					rst,
    output reg [31:0] 	ReadData,
    output reg [31:0] 	DM0,

    // I/O Peripheral ports
    input 		[31:0] 	SW,  // 18-bit switch inputs
    output reg [6:0] 	HEX0,  // 7-segment LED outputs
    output reg [6:0] 	HEX1,
    output reg [6:0] 	HEX2,
    output reg [6:0] 	HEX3,
    output reg [6:0] 	HEX4,
    output reg [6:0] 	HEX5,
    output reg [6:0] 	HEX6,
    output reg [6:0] 	HEX7,
    output reg [31:0] 	LEDG,  // 8-bit LED outputs
    output reg [31:0] 	LEDR,
    output reg [7:0] 	LCD_DATA,  // 8-bit LCD data
    output reg 			LCD_RS, LCD_RW, LCD_EN  // LCD control signals
);

	reg [31:0] Data_Mem [20:0]; // 2D array for data memory
	reg [31:0] 	SW_ADDR,  
					HEX0_ADDR,
					HEX1_ADDR,
					HEX2_ADDR, 
					HEX3_ADDR ,
					HEX4_ADDR ,
					HEX5_ADDR ,
					HEX6_ADDR ,
					HEX7_ADDR,
					LEDG_ADDR ,
					LEDR_ADDR,
					LCD_DATA_ADDR , 
					LCD_CTRL_ADDR;
				 
	integer i;
	
	always @(*) begin
	// Assign memory-mapped I/O registers to specific addresses
		SW_ADDR = 32'h0x900;  	 // Switch register address
		HEX0_ADDR = 32'h0x800;  // HEX0 register address
		HEX1_ADDR = 32'h0x810;  // HEX1 register address
		HEX2_ADDR = 32'h0x820;  // HEX2 register address
		HEX3_ADDR = 32'h0x830;  // HEX3 register address
		HEX4_ADDR = 32'h0x840;  // HEX4 register address
		HEX5_ADDR = 32'h0x850;  // HEX5 register address
		HEX6_ADDR = 32'h0x860;  // HEX6 register address
		HEX7_ADDR = 32'h0x870;  // HEX7 register address
		LEDG_ADDR = 32'h0x890;  // LEDG register address
		LEDR_ADDR = 32'h0x880;  // LEDR register address
		LCD_DATA_ADDR = 32'h0x8A0;  // LCD data register address
		LCD_CTRL_ADDR = 32'h0x8B0;  // LCD control register address
	end
	
	always @(*) begin
	// Read from memory-mapped I/O registers
		if (ALUResultM == SW_ADDR) ReadData = {14'b0, SW};
		 else if (ALUResultM == HEX0_ADDR) ReadData = {25'b0, HEX0};
		 else if (ALUResultM == HEX1_ADDR) ReadData = {25'b0, HEX1};
		 else if (ALUResultM == HEX2_ADDR) ReadData = {25'b0, HEX2};
		 else if (ALUResultM == HEX3_ADDR) ReadData = {25'b0, HEX3};
		 else if (ALUResultM == HEX4_ADDR) ReadData = {25'b0, HEX4};
		 else if (ALUResultM == HEX5_ADDR) ReadData = {25'b0, HEX5};
		 else if (ALUResultM == HEX6_ADDR) ReadData = {25'b0, HEX6};
		 else if (ALUResultM == HEX7_ADDR) ReadData = {25'b0, HEX7};
		 else if (ALUResultM == LEDG_ADDR) ReadData = {24'b0, LEDG};
		 else if (ALUResultM == LEDR_ADDR) ReadData = {14'b0, LEDR};
		 else if (ALUResultM == LCD_DATA_ADDR) ReadData = {24'b0, LCD_DATA};
		 else if (ALUResultM == LCD_CTRL_ADDR) ReadData = {23'b0, LCD_RS, LCD_RW, LCD_EN};
		 else
		 // Asynchronous read from Data Memory
			ReadData = Data_Mem[ALUResultM];
			DM0 = ReadData;
	end

	always @(posedge clk) begin
		if (!rst) begin
			for(i = 0; i < 20; i = i + 1) begin
				Data_Mem[i] <= 32'd0;
			end
			HEX0 <= 7'b0;
			HEX1 <= 7'b0;
			HEX2 <= 7'b0;
			HEX3 <= 7'b0;
			HEX4 <= 7'b0;
			HEX5 <= 7'b0;
			HEX6 <= 7'b0;
			HEX7 <= 7'b0;
			LEDG <= 8'b0;
			LEDR <= 8'b0;
			LCD_DATA <= 8'b0;
			LCD_RS <= 1'b0;
			LCD_RW <= 1'b0;
			LCD_EN <= 1'b0;
		end else if (MemWriteM) begin
			  Data_Mem[ALUResultM] <= WriteDataM;
			  // Write to memory-mapped I/O registers
			  if (ALUResultM == HEX0_ADDR) HEX0 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX1_ADDR) HEX1 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX2_ADDR) HEX2 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX3_ADDR) HEX3 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX4_ADDR) HEX4 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX5_ADDR) HEX5 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX6_ADDR) HEX6 <= WriteDataM[6:0];
			  else if (ALUResultM == HEX7_ADDR) HEX7 <= WriteDataM[6:0];
			  else if (ALUResultM == LEDG_ADDR) LEDG <= WriteDataM[7:0];
			  else if (ALUResultM == LEDR_ADDR) LEDR <= WriteDataM[17:0];
			  else if (ALUResultM == LCD_DATA_ADDR) LCD_DATA <= WriteDataM[7:0];
			  else if (ALUResultM == LCD_CTRL_ADDR) begin
					LCD_RS <= WriteDataM[0];
					LCD_RW <= WriteDataM[1];
					LCD_EN <= WriteDataM[2];
			  end
		 end
	end

endmodule