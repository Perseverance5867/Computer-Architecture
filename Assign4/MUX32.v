module MUX32
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input	[31:0]		data1_i;	// register data
input	[31:0]		data2_i;	// immediate data
input				select_i;
output	[31:0]		data_o;

assign	data_o		= (select_i==0) ? data1_i:
					  (select_i==1) ? data2_i:
					  0;

endmodule