module ALU
(
	data1_i,
	data2_i,
	ALUCtrl_i,
	data_o,
	Zero_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[2:0]		ALUCtrl_i;
output	[31:0]		data_o;
output				Zero_o;

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

assign	data_o		= (ALUCtrl_i==3'b000) ? cal_or:
					  (ALUCtrl_i==3'b001) ? cal_and:
					  (ALUCtrl_i==3'b010) ? cal_add:
					  (ALUCtrl_i==3'b011) ? cal_sub:
					  (ALUCtrl_i==3'b100) ? cal_mul:
					  {32{1'bx}};

assign Zero_o		= 0;

endmodule