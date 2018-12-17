module MEM_WB
(	
	clk_i,
	control_i,
	memData_i,
	ALUResult_i,
	RDaddr_i,
	control_o,
	WB_Data_o,
	RDaddr_o,
	RegWrite_o
);

input				clk_i;
input	[ 3:0]		control_i;	
input	[31:0]		memData_i;
input	[31:0]		ALUResult_i;
input	[ 4:0]		RDaddr_i;
output	reg [ 3:0]		control_o;
output	reg [31:0]		WB_Data_o;
output	reg [ 4:0]		RDaddr_o;
output	reg				RegWrite_o;

always @(posedge clk_i) begin
	control_o	<= control_i;
	WB_Data_o	<= (control_i == 4'b0110)? memData_i:		// lw
				   ALUResult_i;								// others
	RDaddr_o	<= RDaddr_i;
	RegWrite_o  <= (control_i == 4'b0111) ? 0:				// sw
				   (control_i == 4'b1000) ? 0:				// branch
				   (control_i == 4'b1111) ? 0:				// nop
				   1;										// others		
end

endmodule
