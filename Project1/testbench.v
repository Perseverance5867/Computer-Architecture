`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset),
    .start_i(Start)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("Fibonacci_instruction.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 1;
    Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    Reset = 1;
    Start = 1;
        
    
end
  
always@(posedge Clk) begin
    if(counter == 30)    // stop after 30 cycles
        $stop;

    // put in your own signal to count stall and flush
    // if(CPU.HazzardDetection.mux8_o == 1 && CPU.Control.Jump_o == 0 && CPU.Control.Branch_o == 0)stall = stall + 1;
    // if(CPU.HazzardDetection.Flush_o == 1)flush = flush + 1;  
    
/*
    // tests
    $display("----------------------------------------------------------------");
    $display("Count %d, Clk %d, Start %d",counter, Clk, Start);
    $display("[CPU]: clk_i=%d, start_i=%d",CPU.clk_i, CPU.start_i);
    $display("[PC]: clk_i=%d, start_i=%d, pc_i=%d, pc_o=%d",CPU.PC.clk_i, CPU.PC.start_i, CPU.PC.pc_i, CPU.PC.pc_o);
    $display("[IF_ID]: pc_i=%d, inst_i=%b (hazard_i=%d)", CPU.IF_ID.pc_i, CPU.IF_ID.inst_i, CPU.IF_ID.hazard_i);
    $display("----------------------------------------------------------------");
    $display("[CONTROL]: %b", CPU.Control.data_o);
    $display("[IF_ID]: pc_o=%d, inst_o=%b, branch_i=%d", CPU.IF_ID.pc_o, CPU.IF_ID.inst_o, CPU.IF_ID.branch_i);
    $display("[Registers]: RSaddr1_i=%d, RSaddr2_i=%d, RDaddr_i=%d, RDdata_i=%d, RegWrite_i=%d, RSdata1_o=%d, RSdata2_o=%d",CPU.Registers.RSaddr1_i, CPU.Registers.RSaddr2_i, CPU.Registers.RDaddr_i, CPU.Registers.RDdata_i, CPU.Registers.RegWrite_i, CPU.Registers.RSdata1_o, CPU.Registers.RSdata2_o);
    $display("[Decide Branch]: data_o=%b", CPU.Decide_Branch.data_o);
    $display("[Adder Branch]: data1_i=%b, data2_i=%d, data_o=%b", CPU.Adder_Branch.data1_i, CPU.Adder_Branch.data2_i, CPU.Adder_Branch.data_o);
    $display("[MuxPC]: data_o=%b", CPU.Mux_PC.data_o);
    $display("[ID_EX]: immediate_i=%b", CPU.ID_EX.immediate_i);
    $display("----------------------------------------------------------------");
    $display("[CONTROL]: %b", CPU.ID_EX.control_o);
    $display("[ID_EX]: immediate_o=%b", CPU.ID_EX.immediate_o);
    $display("[ALU]: data1_i=%d, data2_i=%d, data_o=%d, zero_o=%d", CPU.ALU.data1_i, CPU.ALU.data2_i, CPU.ALU.data_o, CPU.ALU.zero_o);
    $display("[Hazard]: RESULT=%b", CPU.Hazard_Detection.ZeroCtrl_o);
    $display("[ForwardA]: RESULT=%d", CPU.Forwarding.ForwardA_o);
    $display("[ForwardB]: RESULT=%d", CPU.Forwarding.ForwardB_o);
    $display("[EX_MEM]: ALUResult_i=%d, RSdata2_i=%d, RDaddr_i=%d", CPU.EX_MEM.ALUResult_i, CPU.EX_MEM.RSdata2_i, CPU.EX_MEM.RDaddr_i);
    $display("----------------------------------------------------------------");
    $display("[CONTROL]: %b", CPU.EX_MEM.control_o);
    $display("[EX_MEM]: ALUResult_o=%d, RSdata2_o=%d, RDaddr_o=%d", CPU.EX_MEM.ALUResult_o, CPU.EX_MEM.RSdata2_o, CPU.EX_MEM.RDaddr_o);
    $display("[Data Memory]: addr: %b, data: %d", CPU.Data_Memory.memAddr_i, CPU.Data_Memory.memData_i);
    $display("----------------------------------------------------------------");
    // $display("[MEM_WB]: WB_Data_i=%d, RDaddr_o=%d, RegWrite_o=%d, control_i=%o", CPU.MEM_WB.WB_Data_o, CPU.MEM_WB.RDaddr_o, CPU.MEM_WB.RegWrite_o, CPU.MEM_WB.control_o);
    $display("[CONTROL]: %b", CPU.MEM_WB.control_o);
    $display("[MEM_WB]: WB_Data_o=%d, RDaddr_o=%d, RegWrite_o=%d", CPU.MEM_WB.WB_Data_o, CPU.MEM_WB.RDaddr_o, CPU.MEM_WB.RegWrite_o);
    $display("----------------------------------------------------------------");
*/

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    if (CPU.Hazard_Detection.hazard == 1) stall = stall + 1;
    if (CPU.Decide_Branch.data_o == 2) flush = flush + 1;
end

  
endmodule
