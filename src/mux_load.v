module mux_load (
	input  [31:0] LB,
   input  [31:0] LH,
   input  [31:0] LW,
   input  [31:0] LBU,
   input  [31:0] LHU,
   input  [2:0] select_load,
   output reg [31:0] RD
);

	always @ (*) begin
		case (select_load)
			3'b000: RD = LB;
         3'b001: RD = LH;
         3'b010: RD = LW;
         3'b100: RD = LBU;
         3'b101: RD = LHU;
         default: RD = 32'hxxxx_xxxx; // Handle invalid select value
      endcase
	end

endmodule
