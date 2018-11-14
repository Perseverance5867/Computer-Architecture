module Control
(
	Op_i,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o
);

input	[6:0]		Op_i;
output	[1:0]		ALUOp_o;
output				ALUSrc_o;
output				RegWrite_o;

wire	[3:0]		temp;

assign	temp 		= (Op_i==7'b0110011) ? {4'b1001}:	// R-format 10
					  (Op_i==7'b0010011) ? {4'b1111}:	// I-format 11
					  0;

assign	ALUOp_o[1]	= temp[3];
assign	ALUOp_o[0]	= temp[2];
assign	ALUSrc_o	= temp[1];
assign	RegWrite_o	= temp[0];

endmodule