module Sign_Extend
(
	data_i,
	control_i,
	data_o
);

input	[31:0]		data_i;
input	[ 3:0]		control_i;
output	[31:0]		data_o;

wire	[11:0]		which;

assign	which		= (control_i == 4'b0111) ? {data_i[31:25], data_i[11:7]}:
					  (control_i == 4'b1000) ? {data_i[31], data_i[7], data_i[30:25], data_i[11:8]}:
					  data_i[31:20];

assign	data_o		= { {20{which[11]}}, which};

endmodule