module EX_MEM
(
	clk_i,
	control_i,
	ALUResult_i,
	RSdata2_i,
	RDaddr_i,
	control_o,
	ALUResult_o,
	RSdata2_o,
	RDaddr_o
);

input				clk_i;
input	[ 3:0]		control_i;	
input	[31:0]		ALUResult_i;
input	[31:0]		RSdata2_i;
input	[ 4:0]		RDaddr_i;
output	reg [ 3:0]		control_o;
output	reg [31:0]		ALUResult_o;
output	reg [31:0]		RSdata2_o;
output	reg [ 4:0]		RDaddr_o;

always @(posedge clk_i) begin
	control_o	<= control_i;
	ALUResult_o	<= ALUResult_i;
	RSdata2_o	<= RSdata2_i;
	RDaddr_o	<= RDaddr_i;
end

endmodule
