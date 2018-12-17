module MUX_ForwardingA
(
	data1_i,
	data2_i,
	data3_i,
	data4_i,
	select_i,
	control_i,
	data_o
);

input	[ 4:0]		data1_i;
input	[31:0]		data2_i;	
input	[31:0]		data3_i;
input	[31:0]		data4_i;
input	[ 1:0]		select_i;
input	[ 3:0]		control_i;
output	[31:0]		data_o;

assign	data_o		= //(control_i == 4'b0110) ? data1_i:	//don't need this because it is pointer + offset
					  //(control_i == 4'b0111) ? data1_i:
					  (select_i == 2'b00) ? data2_i:	// 00 register data
					  (select_i == 2'b01) ? data3_i:	// 01 MEM hazard (input from MEMWB)
					  (select_i == 2'b10) ? data4_i:	// 10 EX hazard (input from EXMEM)
					  0;

endmodule
