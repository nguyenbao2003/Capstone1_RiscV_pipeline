`timescale 1ns/1ps

module PCTarget (
    input      [31:0] JAL_JALR,
    input      [31:0] ImmExtE,
    output reg [31:0] PCTargetE
);
	always @ (*) begin
		PCTargetE = JAL_JALR + ImmExtE;        
   end

endmodule