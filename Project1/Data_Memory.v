module Data_Memory (
    clk_i,
    memAddr_i,          // Memory Address
    memData_i,          // Memory Address Contents
    control_i,
    memData_o           // Output of Memory Address Contents
);

input   clk_i;
input   [3:0]  control_i;
input   [31:0]  memAddr_i;
input   [31:0]  memData_i;
output  [31:0]  memData_o;


reg     [7:0]   memory[0:31];  // 32 words of 8-bit memory
wire memRead, memWrite;

assign memRead = ((control_i == 4'b0000))? 1'b0: // or
                 ((control_i == 4'b0001))? 1'b0: // and
                 ((control_i == 4'b0010))? 1'b0: // add
                 ((control_i == 4'b0011))? 1'b0: // sub
                 ((control_i == 4'b0100))? 1'b0: // mul
                 ((control_i == 4'b0101))? 1'b0: // addi
                 ((control_i == 4'b0110))? 1'b1: // lw
                 ((control_i == 4'b0111))? 1'b0: // sw
                 ((control_i == 4'b1000))? 1'b0: // beq
                 {1'b0};

assign memWrite = ((control_i == 4'b0000))? 1'b0: // or
                  ((control_i == 4'b0001))? 1'b0: // and
                  ((control_i == 4'b0010))? 1'b0: // add
                  ((control_i == 4'b0011))? 1'b0: // sub
                  ((control_i == 4'b0100))? 1'b0: // mul
                  ((control_i == 4'b0101))? 1'b0: // addi
                  ((control_i == 4'b0110))? 1'b0: // lw
                  ((control_i == 4'b0111))? 1'b1: // sw
                  ((control_i == 4'b1000))? 1'b0: // beq
                  {1'b0};

// Read Memory
assign memData_o = (memRead)? memory[memAddr_i]:0;

// Write Memory
always @(posedge clk_i) begin
  if (memWrite)
    memory[memAddr_i] <= memData_i;
end

endmodule
