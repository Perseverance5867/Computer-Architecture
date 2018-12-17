module Control		// func7 func3 opcode
(
	data_i,
	RSdata1_i,
	RSdata2_i,
	data_o	
);

input	[16:0]		data_i;
input	[31:0]		RSdata1_i, RSdata2_i;
output	[3:0]		data_o;

wire 	[9:0]		store;
wire 	[6:0]		branch;

assign  store       = {data_i[9:0]};
assign  branch      = {data_i[6:0]};

assign	data_o		= (data_i == {17'b00000001100110011}) ? {4'b0000}:	// or
					  (data_i == {17'b00000001110110011}) ? {4'b0001}:	// and
					  (data_i == {17'b00000000000110011}) ? {4'b0010}:	// add
					  (data_i == {17'b01000000000110011}) ? {4'b0011}:	// sub
					  (data_i == {17'b00000010000110011}) ? {4'b0100}:	// mul
					  (data_i == {17'b00000000000010011}) ? {4'b0101}:	// addi
					  (data_i == {17'b00000000100000011}) ? {4'b0110}:	// lw
					  (store == {10'b0100100011}) ? {4'b0111}:	// sw
					  (branch == {7'b1100011}) ? {4'b1000}:	// beq
					  {4'b1111};

endmodule
