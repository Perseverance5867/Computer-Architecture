module Registers
(
	clk_i,
	RSaddr1_i,
	RSaddr2_i,
	RDaddr_i, 
	RDdata_i,
	RegWrite_i, 
	RSdata1_o, 
	RSdata2_o 
);

// Ports
input				clk_i;
input	[ 4:0]		RSaddr1_i;
input	[ 4:0]		RSaddr2_i;
input	[ 4:0]		RDaddr_i;
input	[31:0]		RDdata_i;
input				RegWrite_i;
output	[31:0]		RSdata1_o; 
output	[31:0]		RSdata2_o;

// Register File
reg		[31:0]		register	[0:31];

// Read Data
assign RSdata1_o = (RegWrite_i && (RDaddr_i == RSaddr1_i)) ? RDdata_i: register[RSaddr1_i];
assign RSdata2_o = (RegWrite_i && (RDaddr_i == RSaddr2_i)) ? RDdata_i: register[RSaddr2_i];

// Write Data
always@(posedge clk_i) begin
	if (RegWrite_i)
		register[RDaddr_i] = RDdata_i;
	
end

endmodule 
