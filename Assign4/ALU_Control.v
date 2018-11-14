module ALU_Control
(
	funct_i,
	ALUOp_i,
	ALUCtrl_o
);

input	[9:0]		funct_i;
input	[1:0]		ALUOp_i;
output	[2:0]		ALUCtrl_o;

wire	[2:0]		temp;

assign	temp		= (funct_i==10'b0000000110) ? {3'b000}:	// or
					  (funct_i==10'b0000000111) ? {3'b001}:	// and
					  (funct_i==10'b0000000000) ? {3'b010}:	// add
					  (funct_i==10'b0100000000) ? {3'b011}:	// sub
					  (funct_i==10'b0000001000) ? {3'b100}:	// mul
					  3'bxxx;

assign	ALUCtrl_o	= (ALUOp_i==2'b10) ? temp:
					  (ALUOp_i==2'b11) ? {3'b010}:
					  3'bxxx;

endmodule