module ALU
(
	data1_i,
	data2_i,
	control,
	data_o,
	zero_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[3:0]		control;
output	[31:0]		data_o;
output				zero_o;

wire	[31:0]		cal_or;
wire	[31:0]		cal_and;
wire	[31:0]		cal_add;
wire	[31:0]		cal_sub;
wire	[31:0]		cal_mul;

assign	cal_or		= data1_i | data2_i;
assign	cal_and		= data1_i & data2_i;
assign	cal_add		= data1_i + data2_i;
assign	cal_sub		= data1_i - data2_i;
assign	cal_mul		= data1_i * data2_i;

assign	data_o		= (control == 4'b0000) ? cal_or:		// or
					  (control == 4'b0001) ? cal_and:		// and
					  (control == 4'b0010) ? cal_add:		// add
					  (control == 4'b0011) ? cal_sub:		// sub
					  (control == 4'b0100) ? cal_mul:		// mul
					  (control == 4'b0101) ? cal_add:		// addi
					  (control == 4'b0110) ? cal_add:		// ld
					  (control == 4'b0111) ? cal_add:		// sd
					  {32{1'b0}};							// others

assign zero_o		= (control == 4'b1000) ? 1:				// beq
					  0;									// others

endmodule
