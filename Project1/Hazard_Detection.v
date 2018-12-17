module Hazard_Detection (
	IFID_RSaddr1_i,
	IFID_RSaddr2_i,
	IDEX_control_i,
	IDEX_RDaddr_i,
	PCWrite_o,
	IFIDWrite_o,
	ZeroCtrl_o
);

input [4:0] IFID_RSaddr1_i;
input [4:0] IFID_RSaddr2_i;
input [3:0] IDEX_control_i;     //yo
input [4:0]	IDEX_RDaddr_i;
output [1:0] PCWrite_o;
output IFIDWrite_o;
output ZeroCtrl_o;



reg hazard;
wire IDEX_MemRead;

assign IDEX_MemRead = (IDEX_control_i == 4'b0000) ? 0: // or
                 	  (IDEX_control_i == 4'b0001) ? 0: // and
                 	  (IDEX_control_i == 4'b0010) ? 0: // add
                 	  (IDEX_control_i == 4'b0011) ? 0: // sub
                 	  (IDEX_control_i == 4'b0100) ? 0: // mul
                 	  (IDEX_control_i == 4'b0101) ? 0: // addi
                 	  (IDEX_control_i == 4'b0110) ? 1: // lw
                 	  (IDEX_control_i == 4'b0111) ? 0: // sw
                 	  (IDEX_control_i == 4'b1000) ? 0: // beq
                 	  {1'b0};


always@ (*) begin
	// Hazard detection
	if (IDEX_MemRead && ((IDEX_RDaddr_i == IFID_RSaddr1_i) || (IDEX_RDaddr_i == IFID_RSaddr2_i)))
		hazard = 2'b1;
	else
		hazard = 2'b0;
end

assign PCWrite_o = (hazard)? {2'b01}: {2'b00};
assign IFIDWrite_o = (hazard)? 0: 1;
assign ZeroCtrl_o = (hazard)? 1: 0;

endmodule
