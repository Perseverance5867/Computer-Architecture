module Forwarding (
	IDEX_RSaddr1_i,
	IDEX_RSaddr2_i,
	EXMEM_RDaddr_i,
	MEMWB_RDaddr_i,
	EXMEM_control_i,
	MEMWB_control_i,
	ForwardA_o,
	ForwardB_o
);

input 	[4:0] 	IDEX_RSaddr1_i;
input	[4:0]	IDEX_RSaddr2_i;
input	[4:0]	EXMEM_RDaddr_i;
input	[4:0]	MEMWB_RDaddr_i;
input 	[3:0]	EXMEM_control_i;
input	[3:0]	MEMWB_control_i; 
output 	[1:0] 	ForwardA_o;
output	[1:0]	ForwardB_o;

reg 	[1:0] 	ForwardA, ForwardB;
wire 	EXMEM_RegWrite, MEMWB_RegWrite;

assign EXMEM_RegWrite = ((EXMEM_control_i == 4'b0000))? 1:	// or
						((EXMEM_control_i == 4'b0001))? 1:	// and
						((EXMEM_control_i == 4'b0010))? 1:	// add
						((EXMEM_control_i == 4'b0011))? 1:	// sub
						((EXMEM_control_i == 4'b0100))? 1:	// mul
						((EXMEM_control_i == 4'b0101))? 1:	// addi
						((EXMEM_control_i == 4'b0110))? 1:	// lw
						((EXMEM_control_i == 4'b0111))? 0:	// sw
						((EXMEM_control_i == 4'b1000))? 0:	// beq
						{1'bx};

assign MEMWB_RegWrite = ((MEMWB_control_i == 4'b0000))? 1:	// or
						((MEMWB_control_i == 4'b0001))? 1:	// and
						((MEMWB_control_i == 4'b0010))? 1:	// add
						((MEMWB_control_i == 4'b0011))? 1:	// sub
						((MEMWB_control_i == 4'b0100))? 1:	// mul
						((MEMWB_control_i == 4'b0101))? 1:	// addi
						((MEMWB_control_i == 4'b0110))? 1:	// lw
						((MEMWB_control_i == 4'b0111))? 0:	// sw
						((MEMWB_control_i == 4'b1000))? 0:	// beq
						{1'bx};

always@ (*) begin
	// Forward A
	if (EXMEM_RegWrite && (EXMEM_RDaddr_i == IDEX_RSaddr1_i))
		ForwardA = 2'b10;	// EX hazard of rs1
	else if (MEMWB_RegWrite && (MEMWB_RDaddr_i == IDEX_RSaddr1_i))
		ForwardA = 2'b01;	// MEM hazard of rs1
	else
		ForwardA = 2'b00;	// no hazard

	// Forward B
	if (EXMEM_RegWrite && (EXMEM_RDaddr_i == IDEX_RSaddr2_i))
		ForwardB = 2'b10;	// EX hazard of rs2
	else if (MEMWB_RegWrite && (MEMWB_RDaddr_i == IDEX_RSaddr2_i))
		ForwardB = 2'b01;	// MEM hazard of rs2
	else
		ForwardB = 2'b00;	// no hazard
end
assign ForwardA_o = ForwardA;
assign ForwardB_o = ForwardB;

endmodule
