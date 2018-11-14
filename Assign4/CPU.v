module CPU
(
	clk_i, 
	rst_i,
	start_i
);

// Ports
input				clk_i;
input				rst_i;
input				start_i;

wire	[31:0]		inst_addr, inst;

Control Control(
	.Op_i			(inst[6:0]),
	.ALUOp_o		(),
	.ALUSrc_o		(),
	.RegWrite_o		()
);

Adder Add_PC(
	.data1_i		(inst_addr),
	.data2_i		(32'd4),
	.data_o			()
);

PC PC(
	.clk_i			(clk_i),
	.rst_i			(rst_i),
	.start_i		(start_i),
	.pc_i			(Add_PC.data_o),
	.pc_o			(inst_addr)
);

Instruction_Memory Instruction_Memory(
	.addr_i			(inst_addr),
	.instr_o		(inst)
);

Registers Registers(
	.clk_i			(clk_i),
	.RSaddr_i		(inst[19:15]),
	.RTaddr_i		(inst[24:20]),
	.RDaddr_i		(inst[11:7]), 
	.RDdata_i		(ALU.data_o),
	.RegWrite_i		(Control.RegWrite_o), 
	.RSdata_o		(), 
	.RTdata_o		() 
);

MUX32 MUX_ALUSrc(
	.data1_i		(Registers.RTdata_o),
	.data2_i		(Sign_Extend.data_o),
	.select_i		(Control.ALUSrc_o),
	.data_o			()
);

Sign_Extend Sign_Extend(
	.data_i			(inst[31:20]),
	.data_o			()
);

ALU ALU(
	.data1_i		(Registers.RSdata_o),
	.data2_i		(MUX_ALUSrc.data_o),
	.ALUCtrl_i		(ALU_Control.ALUCtrl_o),
	.data_o			(),
	.Zero_o			()
);

ALU_Control ALU_Control(
	.funct_i		({inst[31:25], inst[14:12]}),
	.ALUOp_i		(Control.ALUOp_o),
	.ALUCtrl_o		()
);

endmodule