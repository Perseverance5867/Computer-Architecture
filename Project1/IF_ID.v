module IF_ID
(
	clk_i,
	pc_i,
	base_pc_i, 
	inst_i,
	base_inst_i,
	hazard_i,
	branch_i,
	pc_o,
	inst_o
);

input				clk_i;
input	[31:0]		pc_i;
input	[31:0]		base_pc_i;
input	[31:0]		inst_i;
input	[31:0]		base_inst_i;
input				hazard_i;
input	[ 1:0]		branch_i;
output reg  [31:0]		pc_o;
output reg  [31:0]		inst_o;

always @(posedge clk_i) begin
	pc_o	<= (hazard_i) ? base_pc_i: pc_i;
	inst_o	<= (branch_i == 2) ? 0 : (hazard_i) ? base_inst_i : inst_i;
end

endmodule
