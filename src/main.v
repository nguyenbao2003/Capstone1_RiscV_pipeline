`timescale 1ns/1ps

module main (
    input clk_i,
	 input rst_ni,
    // I/O Peripheral ports
    input [31:0] io_sw_i,  // 18-bit io_sw_iitch inputs
    output [6:0] io_hex0_o,  // 7-segment LED outputs
    output [6:0] io_hex1_o,
    output [6:0] io_hex2_o,
    output [6:0] io_hex3_o,
    output [6:0] io_hex4_o,
    output [6:0] io_hex5_o,
    output [6:0] io_hex6_o,
    output [6:0] io_hex7_o,
    output [31:0] io_ledg_o,  // 8-bit LED outputs
    output [31:0] io_ledr_o,
    output [7:0] io_lcd_o,  // 8-bit LCD data
    output LCD_RS, LCD_RW, LCD_EN,  // LCD control signals

    // checkx1 ... upto checkx6 are used to check the contents of RF register
    // for example: x1, x2 upto x6.
    // If you simulator has a support to see contents of RF and DM then
    // you can remove all of the following outputs
    // Like QuetaSim can help you see the contents of RF and DM
   output wire [31:0] checkx1,
   output wire [31:0] checkx2,
   output wire [31:0] checkx3,
   output wire [31:0] checkx4,
   output wire [31:0] checkx5,
   output wire [31:0] checkx6,PCcheck,
	output wire [31:0] checkx7,
	output wire [31:0] checkx20,
	output wire [31:0] checkx21,
   output wire [31:0] DM0,
   output wire [31:0] instruction
);
    wire [31:0] PCF;
	 
    wire [31:0] PCPlus4F, instrD, PCD, PCPlus4D, SrcAE;
	 wire [31:0] JAL_JALR;
    wire [4:0]  A1, A2, RdD, RdW, RdE, RdM, Rs1E, Rs2E, Rs1D, Rs2D;
    wire [6:0]  OP;
    wire [2:0]  funct3, funct3E, funct3M, select_load, select_store;
    wire        funct7;
    wire        WE3;
	 wire 		 OPb5;
    wire        RegWriteW;
    wire        RegWriteD;
    wire        MemWriteD;
    wire        JumpD;
    wire        BranchD;
    wire        ALUSrcD;
    wire        ZeroE;
    wire        RegWriteE;
	 wire 		 JAL_JALR_SELD, JAL_JALR_SELE;
    wire        MemWriteE, JumpE, BranchE, ALUSrcE, PCSrcE;
	 wire 		 loadimm_selD, loadimm_selE, loadimm_selM;

    wire [24:0] Imm;
    wire [6:0]  funct77;
    wire [31:0] ResultW, RD1, RD2;
    wire [31:0] ImmExtD, ImmExtM; 
    wire [2:0]  ImmSrcD;
    wire [1:0]  ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
    wire [4:0]  ALUControlD, ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    wire [31:0] PCTargetE;
    wire [31:0] SrcBE;
    wire [31:0] ALUResult, ALUResultM, ALUResultW, ALUResultM1;
    wire [31:0] WriteDataM, PCPlus4M, PCPlus4W;
	 wire [31:0] LW, LB, LH, LHU, LBU,ST, SH, SB, RD;
    wire        CarryOut, RegWriteM, MemWriteM;
    wire [31:0] ReadData, ReadDataW, WriteDataE, WriteDataE_store ;
    wire [1:0]  ForwardAE, ForwardBE;
    wire        StallF, StallD, FlushE, FlushD;
                //multiple signals at one line are just to reduce the space


	

    Adress_Generator i_ag (
        .rst      (rst_ni   ),
        .clk      (clk_i   ),
        .PCSrcE   (PCSrcE   ),
        .StallF   (StallF   ),
        .PCPlus4F (PCPlus4F ),
        .PCTargetE(PCTargetE),
		  .PCcheck(PCcheck),
        .PCF      (PCF      )
    );

    Instruction_Memory i_im (
        .PCF        (PCF        ),
        .instruction(instruction)
    );
	 

    first_register i_1 (
        .clk        (clk_i      ),
        .rst        (rst_ni),
        .StallD     (StallD     ),
        .FlushD     (FlushD     ),
        .instruction(instruction),
        .PCF        (PCF        ),
        .PCPlus4F   (PCPlus4F   ),
        .instrD     (instrD     ),
        .PCD        (PCD        ),
        .PCPlus4D   (PCPlus4D   )
    );

    PCPlus4 i_pcp4 (
        .PCF     (PCF     ),
        .PCPlus4F(PCPlus4F)
    );

    Instruction_Fetch i_iff (
        .instrD (instrD ),
        .A1     (A1     ),
        .A2     (A2     ),
        .RdD    (RdD    ),
        .Rs1D   (Rs1D   ),
        .Rs2D   (Rs2D   ),
        .OP     (OP     ),
        .funct3 (funct3 ),
        .funct7 (funct7 ),
		  .OPb5   (OPb5   ),
        .Imm    (Imm    ),
        .funct77(funct77)
    );

    Register_File i_rf (
        .A1       (A1       ),
        .A2       (A2       ),
        .RdW      (RdW      ),
        .ResultW  (ResultW  ),
        .clk      (clk_i   ),
        .RegWriteW(RegWriteW),
        .rst      (rst_ni   ),
        .RD1      (RD1      ),
        .RD2      (RD2      ),
        .checkx1  (checkx1  ),
        .checkx2  (checkx2  ),
        .checkx3  (checkx3  ),
        .checkx4  (checkx4  ),
        .checkx5  (checkx5  ),
		  .checkx6  (checkx6  ),
        .checkx7  (checkx7  ),
		  .checkx20  (checkx20  ),
		  .checkx21  (checkx21  )
    );

    sign_extend i_se (
        .Imm    (Imm    ),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    Second_register i_2 (
        .PCD         (PCD        ),
        .ImmExtD     (ImmExtD    ),
        .PCPlus4D    (PCPlus4D   ),
        .RD1         (RD1        ),
        .RD2         (RD2        ),
        .RdD         (RdD        ),
        .Rs1D        (Rs1D       ),
        .Rs2D        (Rs2D       ),
        .funct3      (funct3     ),
        .rst         (rst_ni     ),
        .clk         (clk_i    ),
        .RegWriteD   (RegWriteD  ),
        .MemWriteD   (MemWriteD  ),
		  .loadimm_selD (loadimm_selD),
        .JumpD       (JumpD      ),
        .BranchD     (BranchD    ),
        .ALUSrcD     (ALUSrcD    ),
        .ZeroE       (ZeroE      ),
        .FlushE      (FlushE     ),
        .ResultSrcD  (ResultSrcD ),
        .ALUControlD (ALUControlD),
		  .JAL_JALR_SELD(JAL_JALR_SELD),
        .RegWriteE   (RegWriteE  ),
        .MemWriteE   (MemWriteE  ),
        .JumpE       (JumpE      ),
        .BranchE     (BranchE    ),
        .ALUSrcE     (ALUSrcE    ),
        .PCSrcE      (PCSrcE     ),
        .ResultSrcE  (ResultSrcE ),
        .ALUControlE (ALUControlE),
        .PCE         (PCE        ),
        .ImmExtE     (ImmExtE    ),
        .PCPlus4E    (PCPlus4E   ),
        .RD1E        (RD1E       ),
        .RD2E        (RD2E       ),
        .funct3E     (funct3E    ),
        .RdE         (RdE        ),
        .Rs1E        (Rs1E       ),
		  .loadimm_selE (loadimm_selE),
		  .JAL_JALR_SELE(JAL_JALR_SELE),
        .Rs2E        (Rs2E       )
    );
	 mux_jal_jalr #(32) muxxxxxxxx (
        .PCE      (PCE      ),
        .RD1E   (RD1E   ),
        .JAL_JALR_SELE(JAL_JALR_SELE),
        .JAL_JALR(JAL_JALR)
    );
    PCTarget i_pct (
        .JAL_JALR  (JAL_JALR ),
        .ImmExtE   (ImmExtE  ),
        .PCTargetE (PCTargetE)
    );

    mux2_alu #(32) mux_scrb (
        .WriteDataE (WriteDataE),
        .ImmExtE    (ImmExtE   ),
        .ALUSrcE    (ALUSrcE   ),
        .SrcBE      (SrcBE     )
    );

    alu i_alu (
        .SrcAE       (SrcAE      ),
        .SrcBE       (SrcBE      ),
        .ALUControlE (ALUControlE),
        .funct3E     (funct3E    ),
        .ALUResult   (ALUResult  ),
        .CarryOut    (CarryOut   ),
        .ZeroE       (ZeroE      )
    );

    third_register i_3 (
        .WriteDataE_store (WriteDataE_store),
        .ALUResult  (ALUResult ),
        .PCPlus4E   (PCPlus4E  ),
        .RdE        (RdE       ),
		  .funct3E     (funct3E  ),
		  .loadimm_selE (loadimm_selE),
        .clk        (clk_i    ),
        .rst        (rst_ni    ),
        .RegWriteE  (RegWriteE ),
        .MemWriteE  (MemWriteE ),
		  .ImmExtE 		  (ImmExtE),
        .ResultSrcE (ResultSrcE),
        .ALUResultM1 (ALUResultM1),
        .WriteDataM (WriteDataM),
        .PCPlus4M   (PCPlus4M  ),
        .RdM        (RdM       ),
		  .funct3M     (funct3M  ),
		  .ImmExtM 		  (ImmExtM),
        .RegWriteM  (RegWriteM ),
        .MemWriteM  (MemWriteM ),
		  .loadimm_selM (loadimm_selM),
        .ResultSrcM (ResultSrcM)
    );

    Data_Memory i_dm (
        .WriteDataM (WriteDataM),
        .ALUResultM (ALUResultM),
        .clk        (clk_i    ),
        .MemWriteM  (MemWriteM ),
        .rst        (rst_ni    ),
        .ReadData   (ReadData  ),
        .DM0        (DM0       ),

        // I/O Peripheral ports
        .SW         (io_sw_i   ),
        .HEX0      (io_hex0_o  ),
        .HEX1        (io_hex1_o ),
        .HEX2       (io_hex2_o      ),
        .HEX3        (io_hex3_o      ),
        .HEX4        (io_hex4_o      ),
        .HEX5        (io_hex5_o      ),
        .HEX6       (io_hex6_o      ),
        .HEX7        (io_hex7_o      ),
        .LEDG      (io_ledg_o      ),
        .LEDR      (io_ledr_o     ),
        .LCD_DATA   (io_lcd_o  ),
        .LCD_RS     (LCD_RS    ),
        .LCD_RW     (LCD_RW    ),
        .LCD_EN     (LCD_EN    )
    );
	 
	 Load_sel load_1(
			.funct3M     (funct3M), 
			.ReadData	 (ReadData),
			.select_load (select_load),
			.LW			 (LW),
			.LB			 (LB),
			.LH			 (LH),
			.LBU			 (LBU),
			.LHU			 (LHU)
	 );

	 mux_load mux_l1(
			.LB			 (LB),
			.LH			 (LH),
			.LW			 (LW),
			.LBU			 (LBU),
			.LHU			 (LHU),
			.select_load (select_load),
			.RD			 (RD)
	 );
	 
    fourth_register i_4 (
        .ALUResultM (ALUResultM),
        .ReadData   (RD  		 ),
        .PCPlus4M   (PCPlus4M  ),
        .RdM        (RdM       ),
        .rst        (rst_ni    ),
        .clk        (clk_i    ),
        .RegWriteM  (RegWriteM ),
        .ResultSrcM (ResultSrcM),
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW ),
        .PCPlus4W   (PCPlus4W  ),
        .RdW        (RdW       ),
        .ResultSrcW (ResultSrcW),
        .RegWriteW  (RegWriteW )
    );
    mux3 #(32) mux1 (
        .ALUResultW (ALUResultW),
        .ReadDataW  (ReadDataW ),
        .PCPlus4W   (PCPlus4W  ),
        .ResultSrcW (ResultSrcW),
        .ResultW    (ResultW   )
    );

    Controller i_c (
        .OP          (OP         ),
        .funct77     (funct77    ),
        .funct3      (funct3     ),
        .funct7      (funct7     ),
        .OPb5        (OPb5       ),
        .MemWriteD   (MemWriteD  ),
        .ALUSrcD     (ALUSrcD    ),
        .RegWriteD   (RegWriteD  ),
        .BranchD     (BranchD    ),
        .JumpD       (JumpD      ),
        .ResultSrcD  (ResultSrcD ),
        .ALUControlD (ALUControlD),
		  .JAL_JALR_SELD(JAL_JALR_SELD),
		  .loadimm_selD (loadimm_selD),
        .ImmSrcD     (ImmSrcD    )
    );

    hazard_unit i_hu (
        .Rs1E      (Rs1E      ),
        .Rs2E      (Rs2E      ),
        .RdM       (RdM       ),
        .RdW       (RdW       ),
        .Rs1D      (Rs1D      ),
        .Rs2D      (Rs2D      ),
        .RdE       (RdE       ),
        .ResultSrcE(ResultSrcE),
        .RegWriteM (RegWriteM ),
        .RegWriteW (RegWriteW ),
        .PCSrcE    (PCSrcE    ),
        .StallF    (StallF    ),
        .StallD    (StallD    ),
        .FlushE    (FlushE    ),
        .FlushD    (FlushD    ),
        .ForwardAE (ForwardAE ),
        .ForwardBE (ForwardBE )
    );

    mux5 #(32) muxxx (
        .RD1E      (RD1E      ),
        .ResultW   (ResultW   ),
        .ALUResultM(ALUResultM),
        .ForwardAE (ForwardAE ),
        .SrcAE     (SrcAE     )
    );

    mux4 #(32) muxxxxx (
        .RD2E      (RD2E      ),
        .ResultW   (ResultW   ),
        .ALUResultM(ALUResultM),
        .ForwardBE (ForwardBE ),
        .WriteDataE(WriteDataE)
    );
	 
	 Store_sel store_sel(
		  .funct3E			(funct3E		),
		  .WriteDataE		(WriteDataE),
		  .select_store	(select_store),
		  .ST					(ST			),
		  .SH					(SH			),
		  .SB					(SB			)
	 );
	 
	 mux_store mux_store1(
		  .SB				(SB),
		  .SH				(SH),
		  .ST				(ST),
		  .select_store	(select_store),
		  .WriteDataE_store (WriteDataE_store)
	);
		 mux_alu_imm muxaluorimm(
		  .ALUResultM1				(ALUResultM1),
		  .ALUResultM			(ALUResultM),
		  .ImmExtM				(ImmExtM),
		  .loadimm_selM	(loadimm_selM)
	);
	
endmodule