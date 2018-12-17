module CPU
(
	clk_i, 
	rst_i,
	start_i
);
// where to input clk_i QAQ   		add in each long reg(X  maybe need to add always@(posedge clk_i) in each file(unfinish)
// flush QAQ 		maybe(?) finish

// consider different situation when sign extending
// consider different possibilities when choosing ALU source
// clk reference: https://stackoverflow.com/questions/1641184/verilog-can-you-put-assign-statements-within-always-or-begin-end-statements
// input clk in every middle reg (delete clk of data memory????)


// Ports
input				clk_i;
input				rst_i;
input				start_i;

wire 				tmp_RegWrite_o;
wire 	[31:0]		tmp_SignExtend_data_o;
reg					reg_RegWrite_o = 1'b0;
reg 	[31:0]		reg_SignExtend_data_o = 32'b0;

always @(tmp_RegWrite_o) begin
	reg_RegWrite_o <= tmp_RegWrite_o;
end
always @(tmp_SignExtend_data_o) begin
	reg_SignExtend_data_o <= tmp_SignExtend_data_o;
end

Control Control(
	.data_i			({IF_ID.inst_o[31:25], IF_ID.inst_o[14:12], IF_ID.inst_o[6:0]}),
	.RSdata1_i		(Registers.RSdata1_o),
	.RSdata2_i		(Registers.RSdata2_o),
	.data_o			()
);

Adder_PC Adder_PC(
	.data1_i		(PC.pc_o),
	.data2_i		(32'd4),
	.data_o			()
);

PC PC(
	.clk_i			(clk_i),
	.rst_i			(rst_i),
	.start_i		(start_i),
	.pc_i			(Mux_PC.data_o),
	.pc_o			()
);

Mux_PC Mux_PC(
	.data1_i		(Adder_PC.data_o),
	.data2_i		(PC.pc_o),
	.data3_i		(Adder_Branch.data_o),
	.select1_i		(Hazard_Detection.PCWrite_o),
	.select2_i		(Decide_Branch.data_o),
	.data_o			()
);

Adder_Branch Adder_Branch(
	.data1_i		(reg_SignExtend_data_o),
	.data2_i		(IF_ID.pc_o),	
	.data_o			()
);

Instruction_Memory Instruction_Memory(
	.addr_i			(PC.pc_o),
	.inst_o			()
);

IF_ID IF_ID(
	.clk_i			(clk_i),						// to be modified DONE
	.pc_i 			(PC.pc_o),
	.base_pc_i 		(IF_ID.pc_o),
	.inst_i 		(Instruction_Memory.inst_o),
	.base_inst_i	(IF_ID.inst_o),
	.hazard_i 		(Hazard_Detection.ZeroCtrl_o),
	.branch_i 		(Decide_Branch.data_o),
	.pc_o 			(),
	.inst_o 		()
);

/////////////////////////////////////////////////////

Registers Registers(
	.clk_i			(clk_i),
	.RSaddr1_i		(IF_ID.inst_o[19:15]),
	.RSaddr2_i		(IF_ID.inst_o[24:20]),
	.RDaddr_i		(MEM_WB.RDaddr_o), 
	.RDdata_i		(MEM_WB.WB_Data_o),
	.RegWrite_i		(reg_RegWrite_o), 
	.RSdata1_o		(), 
	.RSdata2_o		() 
);

Decide_Branch Decide_Branch(
	.control_i 		(Control.data_o),
	.data1_i		(Registers.RSdata1_o),
	.data2_i		(Registers.RSdata2_o),	
	.data_o			()
);

Sign_Extend Sign_Extend(							// to be modified DONE
	.data_i			(IF_ID.inst_o),
	.control_i 		(Control.data_o),
	.data_o			(tmp_SignExtend_data_o)
);

Hazard_Detection Hazard_Detection(
	.IFID_RSaddr1_i 		(IF_ID.inst_o[19:15]),
	.IFID_RSaddr2_i 		(IF_ID.inst_o[24:20]),
	.IDEX_control_i 		(ID_EX.base_control_o),
	.IDEX_RDaddr_i 			(ID_EX.RDaddr_o),
	.PCWrite_o 				(),
	.IFIDWrite_o 			(),
	.ZeroCtrl_o				()
);

/////////////////////////////////////////////////////

ID_EX ID_EX(
	.clk_i			(clk_i),						// to be modified DONE
	.control_i 		(Control.data_o),
	.RSdata1_i 		(Registers.RSdata1_o),
	.RSdata2_i 		(Registers.RSdata2_o),
	.immediate_i	(reg_SignExtend_data_o),
	.RSaddr1_i 		(IF_ID.inst_o[19:15]),
	.RSaddr2_i 		(IF_ID.inst_o[24:20]),
	.RDaddr_i 		(IF_ID.inst_o[11:7]),
	.hazard_i 		(Hazard_Detection.ZeroCtrl_o),
	.base_control_o	(),
	.control_o 		(),
	.RSdata1_o 		(),
	.RSdata2_o 		(),
	.immediate_o 	(),
	.RSaddr1_o 		(),
	.RSaddr2_o 		(),
	.RDaddr_o 		()
);

/////////////////////////////////////////////////////

MUX_ForwardingA MUX_ForwardA(
	.data1_i 		(ID_EX.RSaddr1_o),		// when R format
	.data2_i 		(ID_EX.RSdata1_o),		// when I format and S format
	.data3_i 		(MEM_WB.WB_Data_o),
	.data4_i 		(EX_MEM.ALUResult_o),
	.select_i 		(Forwarding.ForwardA_o),
	.control_i 		(ID_EX.control_o),
	.data_o 		()
);

MUX_ForwardingB MUX_ForwardB(
	.data1_i		(ID_EX.immediate_o),	// when I format and S format
	.data2_i 		(ID_EX.RSdata2_o),		// when R format
	.data3_i 		(MEM_WB.WB_Data_o),
	.data4_i 		(EX_MEM.ALUResult_o),
	.select_i 		(Forwarding.ForwardB_o),
	.control_i 		(ID_EX.control_o),
	.data_o 		()
);

Forwarding Forwarding(
	.IDEX_RSaddr1_i 	(ID_EX.RSaddr1_o),
	.IDEX_RSaddr2_i 	(ID_EX.RSaddr2_o),
	.EXMEM_RDaddr_i 	(EX_MEM.RDaddr_o),
	.MEMWB_RDaddr_i 	(MEM_WB.RDaddr_o),
	.EXMEM_control_i 	(EX_MEM.control_o),
	.MEMWB_control_i 	(MEM_WB.control_o),
	.ForwardA_o 		(),
	.ForwardB_o 		()
);

ALU ALU(
	.data1_i 		(MUX_ForwardA.data_o),
	.data2_i 		(MUX_ForwardB.data_o),
	.control  		(ID_EX.control_o),
	.data_o 		(),
	.zero_o 		()
);

/////////////////////////////////////////////////////

EX_MEM EX_MEM(
	.clk_i			(clk_i),					  // to be modified DONE
	.control_i 		(ID_EX.control_o),
	.ALUResult_i 	(ALU.data_o),
	.RSdata2_i	 	(ID_EX.RSdata2_o),
	.RDaddr_i 		(ID_EX.RDaddr_o),
	.control_o	 	(),
	.ALUResult_o	(),
	.RSdata2_o		(),
	.RDaddr_o		()
);

/////////////////////////////////////////////////////

Data_Memory Data_Memory(
	.clk_i 			(clk_i),
    .memAddr_i 		(EX_MEM.ALUResult_o),
    .memData_i 		(EX_MEM.RSdata2_o),
    .control_i 		(EX_MEM.control_o),
    .memData_o 		()
);

/////////////////////////////////////////////////////

MEM_WB MEM_WB(
	.clk_i			(clk_i),				  // to be modified DONE
	.control_i 		(EX_MEM.control_o),
	.memData_i 		(Data_Memory.memData_o),
	.ALUResult_i 	(EX_MEM.ALUResult_o),
	.RDaddr_i 		(EX_MEM.RDaddr_o),
	.control_o 		(),
	.WB_Data_o 		(),
	.RDaddr_o		(),
	.RegWrite_o		(tmp_RegWrite_o)
);

endmodule
