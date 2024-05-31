module EX_MEM (
    input clk,
    input reset,
    input RegWrite_E, MemWrite_E,
    input [1:0] ResultSrc_E,    
    input [31:0] ALUResult_E, Mux_RD2E_out, PCPlus4_E,
    input [31:0] Rd_E,
    output reg RegWrite_M, MemWrite_M,
    output reg [1:0] ResultSrc_M,
    output reg [31:0] ALUResult_M, WriteData_M, PCPlus4_M,
    output reg [31:0] Rd_M
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            RegWrite_M <= 1'b0;
            MemWrite_M <= 1'b0;
            ResultSrc_M <= 2'b00;
            ALUResult_M <= 32'b0;
            WriteData_M <= 32'b0;
            Rd_M <= 32'b0;
            PCPlus4_M <= 32'b0;
        end else begin
            RegWrite_M <= RegWrite_E;
            MemWrite_M <= MemWrite_E;
            ResultSrc_M <= ResultSrc_E;
            ALUResult_M <= ALUResult_E;
            WriteData_M <= Mux_RD2E_out;
            Rd_M <= Rd_E;
            PCPlus4_M <= PCPlus4_E;
        end
    end
endmodule
