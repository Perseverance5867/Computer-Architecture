module Decide_Branch
(
	control_i,
	data1_i,
	data2_i,
	data_o
);

input	[ 3:0]		control_i;
input	[31:0]		data1_i;
input	[31:0]		data2_i;
output	[ 1:0]		data_o;

assign	data_o		= ((control_i == {4'b1000}) && (data1_i == data2_i)) ? {2'b10}:				// same, branch
					  {2'b00};									// diff, not branch

endmodule