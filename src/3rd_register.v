`timescale 1ns/1ps

module third_register (
    input      [31:0] WriteDataE_store,
    input      [31:0] ALUResult, ImmExtE,
    input      [31:0] PCPlus4E,
    input      [4:0]  RdE,
	 input 		[2:0]  funct3E,
    input             clk,
    input             rst,
    input             RegWriteE,
    input             MemWriteE,loadimm_selE,
    input      [1:0]  ResultSrcE,
    output reg [31:0] ALUResultM1,ImmExtM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,
    output reg [4:0]  RdM,
	 output reg [2:0]  funct3M,
    output reg        RegWriteM,loadimm_selM,
    output reg        MemWriteM,
    output reg [1:0]  ResultSrcM
);
    always @(posedge clk) begin
        if (!rst) begin
           RegWriteM  <= 0;
           MemWriteM  <= 0;
           ResultSrcM <= 2'b00;
           ALUResultM1 <= 32'd0;
           WriteDataM <= 32'd0;
           RdM        <= 5'd0;
			  funct3M    <= 3'd0;
           PCPlus4M   <= 32'd0;
			  ImmExtM		<= 32'd0;
			  loadimm_selM <= 1'd0;
        end
        else begin
           RegWriteM  <= RegWriteE;
           MemWriteM  <= MemWriteE;
           ResultSrcM <= ResultSrcE;
           ALUResultM1 <= ALUResult;
           WriteDataM <= WriteDataE_store;
           RdM        <= RdE;
			  funct3M    <= funct3E;
           PCPlus4M   <= PCPlus4E;
			  ImmExtM <= ImmExtE;
			  loadimm_selM <= loadimm_selE;
        end
    end
    
endmodule