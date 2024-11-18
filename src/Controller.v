	
`timescale 1ns/1ps

module Controller (
    input      [6:0] OP,
    input      [6:0] funct77,
    input      [2:0] funct3,
    input            funct7,
	 input				OPb5,
    output reg       MemWriteD,
    output reg       ALUSrcD,
    output reg       RegWriteD,
    output reg       BranchD,
    output reg       JumpD, //PCSrc
	 output reg			JAL_JALR_SELD,
	 output reg			loadimm_selD,
    output reg [1:0] ResultSrcD,
    output reg [4:0] ALUControlD,
    output reg [2:0] ImmSrcD
	 
);
   
	reg [1:0]   ALUOp;
	always @ (*) begin
		casex (OP)
			7'b0000011: begin	//lw
				BranchD    = 0;
            ResultSrcD = 2'b01;
            MemWriteD  = 0;
            ALUSrcD    = 1;
            RegWriteD  = 1;
            ALUOp      = 2'b00;
            ImmSrcD    = 3'b000;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b0;
			end 

			7'b0100011: begin  //sw
				BranchD    = 0;
				ResultSrcD = 2'bxx;
            MemWriteD  = 1;
            ALUSrcD    = 1;
            RegWriteD  = 0;
            ALUOp      = 2'b00;
            ImmSrcD    = 3'b001;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b0;
			end

			7'b0110011: begin  //R-type
				BranchD    = 0;
            ResultSrcD = 2'b00;
            MemWriteD  = 0;
            ALUSrcD    = 0;
            RegWriteD  = 1;
            ALUOp      = 2'b10;
            ImmSrcD    = 3'bxxx;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b0;
			end

			7'b1100011: begin  //branch
				BranchD    = 1;
            ResultSrcD = 2'bxx;
            MemWriteD  = 0;
            ALUSrcD    = 0;
            RegWriteD  = 0;
            ALUOp      = 2'b01;
            ImmSrcD    = 3'b010;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b0;
			end

			7'b0010011: begin  //I-Type
				BranchD    = 0;
            ResultSrcD = 2'b00;
            MemWriteD  = 0;
            ALUSrcD    = 1;
            RegWriteD  = 1;
            ALUOp      = 2'b10;
            ImmSrcD    = 3'b000;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b0;
			end
			
			7'b1101111: begin //j
				BranchD    = 0;
            ResultSrcD = 2'b10;
            MemWriteD  = 0;
            ALUSrcD    = 1'bx;
            RegWriteD  = 1;
            ALUOp      = 2'bxx;
            ImmSrcD    = 3'b011;
            JumpD      = 1;
				JAL_JALR_SELD=1'b0;
				loadimm_selD = 1'b0;
			end
			
			7'b1100111: begin //jalr
				BranchD    = 0;
            ResultSrcD = 2'b10; // edit 22-5
            MemWriteD  = 0;
            ALUSrcD    = 1'b1;
            RegWriteD  = 1;
            ALUOp      = 2'bxx;
            ImmSrcD    = 3'b000;
            JumpD      = 1;
				JAL_JALR_SELD=1'b1;
				loadimm_selD = 1'b0;
			end
         
			7'b0110111:begin //U-type
				BranchD = 0;
            RegWriteD = 1;
            ImmSrcD = 3'b100;
            ALUSrcD = 1;
            MemWriteD = 0;
            ResultSrcD = 0;
            ALUOp = 2'b00;
				JAL_JALR_SELD=1'bx;
				loadimm_selD = 1'b1;
			end  
                
			default: begin
				BranchD    = 0;
            ResultSrcD = 2'b00;
            MemWriteD  = 0;
            ALUSrcD    = 1'bx;
            RegWriteD  = 0;
            ALUOp      = 2'b00;
            ImmSrcD    = 3'b000;
            JumpD      = 0;
				JAL_JALR_SELD=1'bx;
			end 
		endcase
	end
	
	wire RtypeSub;
	assign RtypeSub = funct7 & OPb5; // TRUE for R-type subtract

	always @ (*) begin
		case(ALUOp)
			2'b00: ALUControlD = 5'b00000; // addition // lw
			2'b01: ALUControlD = 5'b00001; // subtraction // beq
			default: 
				case(funct3) // R–type or I–type ALU
					3'b000: if (RtypeSub)
						ALUControlD = 5'b00001; // sub, done
					else
						ALUControlD = 5'b00000; // add, addi , done
					3'b001: ALUControlD = 5'b00100; // sll, slli, done
					3'b010: ALUControlD = 5'b00101; // slt, slti, done
					3'b011: ALUControlD = 5'b01000; // sltu, sltiu
					3'b100: ALUControlD = 5'b01010; // xor, xori, done
					3'b101: if (~funct7)
						ALUControlD = 5'b01110;	// srl, srli , done
					else
						ALUControlD = 5'b00111;  // sra, srai done
					3'b110: ALUControlD = 5'b00011; // or, ori, done
					3'b111: ALUControlD = 5'b00010; // and, andi, done
					default: ALUControlD = 5'bxxxxx; // ???
				endcase
		endcase
	end
endmodule 



