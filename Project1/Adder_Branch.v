module Adder_Branch
(
	data1_i,	// immediate to shift 1
	data2_i,	// program counter now
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
output	[31:0]		data_o;

assign	data_o		= (data1_i << 1) + data2_i;

endmodule