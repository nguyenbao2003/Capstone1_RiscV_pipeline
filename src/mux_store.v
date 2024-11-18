module mux_store (
	input  [31:0] SB,
   input  [31:0] SH,
   input  [31:0] ST,
   input  [2:0] select_store,
   output reg [31:0] WriteDataE_store
);

	always @(*) begin
		case (select_store)
			3'b000: WriteDataE_store = SB;
			3'b001: WriteDataE_store = SH;
			3'b010: WriteDataE_store = ST;
         default: WriteDataE_store = 32'hxxxx_xxxx; // Handle invalid select value
      endcase
	end

endmodule
