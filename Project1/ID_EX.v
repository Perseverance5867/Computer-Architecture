module ID_EX
(	
	clk_i,
	control_i,
	RSdata1_i,
	RSdata2_i,
	immediate_i,
	RSaddr1_i,
	RSaddr2_i,
	RDaddr_i,
	hazard_i,
	base_control_o,
	control_o,
	RSdata1_o,
	RSdata2_o,
	immediate_o,
	RSaddr1_o,
	RSaddr2_o,
	RDaddr_o
);

input				clk_i;
input	[ 3:0]		control_i;	
input	[31:0]		RSdata1_i, RSdata2_i, immediate_i;
input	[ 4:0]		RSaddr1_i, RSaddr2_i, RDaddr_i;
input				hazard_i;
output	reg [ 3:0]		control_o, base_control_o;
output	reg [31:0]		RSdata1_o, RSdata2_o, immediate_o;
output	reg [4:0]		RSaddr1_o, RSaddr2_o, RDaddr_o;


always @(posedge clk_i) begin
	control_o	<= (hazard_i) ? 4'b1111 : control_i;
//	control_o 	<= control_i;
	base_control_o <= control_i;
	RSdata1_o	<= RSdata1_i;
	RSdata2_o	<= RSdata2_i;
	immediate_o	<= immediate_i;
	RSaddr1_o	<= RSaddr1_i;
	RSaddr2_o	<= RSaddr2_i;
	RDaddr_o	<= RDaddr_i;
end

endmodule
