module Mux_PC
(
	data1_i,
	data2_i,
	data3_i,
	select1_i,
	select2_i,
	data_o
);

input	[31:0]		data1_i;
input	[31:0]		data2_i;
input	[31:0]		data3_i;
input	[ 1:0]		select1_i;
input	[ 1:0]		select2_i;
output	[31:0]		data_o;

reg		[ 1:0]		select_i = 0;

always @(*) begin
	if (select1_i == 1) begin
		select_i = 1;
	end
	else if(select2_i == 2) begin
		select_i = 2;
	end
	else begin
		select_i = 0;
	end
end

/*
assign	data_o		= (select_i == 0) ? data1_i:			// next PC
					  (select_i == 1) ? data2_i:			// same PC
					  (select_i == 2) ? data3_i:			// branch PC
					  0;
*/

assign	data_o		= (select_i == 1) ? data2_i:			// same PC
					  (select_i == 2) ? data3_i:			// branch PC
					  data1_i;



//assign data_o = data1_i;
endmodule
