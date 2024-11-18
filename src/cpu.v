module cpu(
    input  wire                 CLOCK_50,			// system clock signal
																// reset signal
	 input  wire [31:0]			  SW,			// ready signal, pause cpu when low

//	 output wire [31:0]          LCD_DATA,  // 32-bit data to drive LCD
//	 output wire [31:0]          LEDG, //32-bit data to drive green LEDs
//	 output wire [31:0]          LEDR, // 32-bit data to drive red LEDs.
//	 
	 output wire [31:0]          HEX0, // 8 32-bit data to drive 7-segment LEDs.
	 output wire [31:0]          HEX1,
	 output wire [31:0]          HEX2,
	 output wire [31:0]          HEX3,
//	 output wire [31:0]          HEX4,
//	 output wire [31:0]          HEX5,
//	 output wire [31:0]          HEX6,
	 output wire [31:0]          HEX7,
	 
	 output wire [31:0]          checkx1,
    output wire [31:0] 			  checkx2,
    output wire [31:0] 			  checkx3,
    output wire [31:0] 			  checkx4,
	 output wire [31:0] 			  checkx5,
//   output wire [31:0] 			  checkx6,
//	 output wire [31:0] 			  checkx7,
//	 output wire [31:0] 			  checkx20,
//	 output wire [31:0] 			  checkx21,
    
	 output wire [31:0] 			  DM0, PCcheck,
    output wire [31:0] 			  instruction
   // output 							  LCD_RS, LCD_RW, LCD_EN  // LCD control signals
);
	 wire [6:0] io_hex0_o;  // 7-segment LED wires
    wire [6:0] io_hex1_o;    
	 wire [6:0] io_hex2_o;
    wire [6:0] io_hex3_o;
    wire [6:0] io_hex4_o;
    wire [6:0] io_hex5_o;
    wire [6:0] io_hex6_o;
    wire [6:0] io_hex7_o;
	main main0(
		 .clk_i(CLOCK_50),
		 .io_sw_i(SW),
		 .DM0(DM0),
		 .instruction(instruction),
		 .io_hex0_o(io_hex0_o),
		 .io_hex1_o(io_hex1_o),
		 .io_hex2_o(io_hex2_o),
		 .io_hex3_o(io_hex3_o),
		 .io_hex4_o(io_hex4_o),
		 .io_hex5_o(io_hex5_o),
		 .io_hex6_o(io_hex6_o),
		 .io_hex7_o(io_hex7_o),
		 .io_ledg_o(LEDG),
		 .io_ledr_o(LEDR),
		 .checkx1(checkx1),
		 .checkx2(checkx2),
		 .checkx3(checkx3),
		 .checkx4(checkx4),
		 .checkx5(checkx5),
		 .checkx6(checkx6),
		 .checkx7(checkx7),
		 .checkx20(checkx20),
		 .checkx21(checkx21),
		 .io_lcd_o(LCD_DATA),
		 .rst_ni (SW[17]),
		 .LCD_RS(LCD_RS),
		 .LCD_RW(LCD_RW),
		 .PCcheck(PCcheck),
		 .LCD_EN(LCD_EN)
	);

	seven_led abc(
	.io_hex0_o (io_hex0_o),
	.io_hex1_o (io_hex1_o),
	.io_hex2_o (io_hex2_o),
	.io_hex3_o (io_hex3_o),
	.io_hex4_o (io_hex4_o),
	.io_hex5_o (io_hex5_o),
	.io_hex6_o (io_hex6_o),
	.io_hex7_o (io_hex7_o),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.HEX6(HEX6),
	.HEX7(HEX7)
	);
endmodule