module MEM_WB (
    input clk,
    input reset,
    input RegWrite_M,
    input [1:0] ResultSrc_M,
    input [31:0] ALUResult_M, ReadData_M, PCPlus4_M,
    input [31:0] Rd_M,   

    output reg RegWrite_W,
    output reg [1:0] ResultSrc_W,
    output reg [31:0] ALUResult_W, ReadData_W, PCPlus4_W,
    output reg [31:0] Rd_W
);
   always @(posedge clk or negedge reset) begin
        if (!reset) begin
            RegWrite_W <= 1'b0;
            ResultSrc_W <= 2'b00;
            ALUResult_W <= 32'b0;
            ReadData_W <= 32'b0;
            Rd_W <= 32'b0;
            PCPlus4_W <= 32'b0;
        end else begin
            RegWrite_W <= RegWrite_M;
            ResultSrc_W <= ResultSrc_M;
            ALUResult_W <= ALUResult_M;
            ReadData_W <= ReadData_M;
            Rd_W <= Rd_M;
            PCPlus4_W <= PCPlus4_M;
        end
    end
endmodule
