module IF_ID (
    input clk,
    input reset,
    input Stall_D,
    input [31:0] Instr,
    input [31:0] PCplus4_out,
    input [31:0] PC_out,
    output reg [31:0] Instruction_D,
    output reg [31:0] PCplus4_D,
    output reg [31:0] PC_D
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            Instruction_D <= 32'b0;
            PCplus4_D <= 32'b0;
            PC_D <= 32'b0;
        end else begin
            if (!Stall_D) begin
                Instruction_D <= Instr;
                PCplus4_D <= PCplus4_out;
                PC_D <= PC_out;
            end
        end
    end
endmodule
