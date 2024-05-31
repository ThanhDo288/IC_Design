module ID_EX (
    input clk,
    input reset,
    input Flush_E,
    input RegWrite_D, MemWrite_D, Jump_D, Branch_D, ALUSrc_D,
    input [1:0] ResultSrc_D,
    input [3:0] ALUControl_D,
    input [31:0] RD1_D, RD2_D, Extimm_D, PCplus4_D, PC_D,
    input [31:0] Rs1_D, Rs2_D, Rd_D,
    output reg RegWrite_E, MemWrite_E, Jump_E, Branch_E, ALUSrc_E,
    output reg [1:0] ResultSrc_E,
    output reg [3:0] ALUControl_E,
    output reg [31:0] RD1_E, RD2_E, Extimm_E, PCplus4_E, PC_E,
    output reg [31:0] Rs1_E, Rs2_E, Rd_E
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            RegWrite_E <= 1'b0;
            MemWrite_E <= 1'b0;
            Jump_E <= 1'b0;
            Branch_E <= 1'b0;
            ALUSrc_E <= 1'b0;
            ResultSrc_E <= 2'b00;
            ALUControl_E <= 4'b0000;
            RD1_E <= 32'b0;
            RD2_E <= 32'b0;
            PC_E <= 32'b0;
            Rs1_E <= 32'b0;
            Rs2_E <= 32'b0;
            Rd_E <= 32'b0;
            Extimm_E <= 32'b0;
            PCplus4_E <= 32'b0;
        end else if (!Flush_E) begin
            RegWrite_E <= RegWrite_D;
            MemWrite_E <= MemWrite_D;
            Jump_E <= Jump_D;
            Branch_E <= Branch_D;
            ALUSrc_E <= ALUSrc_D;
            ResultSrc_E <= ResultSrc_D;
            ALUControl_E <= ALUControl_D;
            RD1_E <= RD1_D;
            RD2_E <= RD2_D;
            PC_E <= PC_D;
            Rs1_E <= Rs1_D;
            Rs2_E <= Rs2_D;
            Rd_E <= Rd_D;
            Extimm_E <= Extimm_D;
            PCplus4_E <= PCplus4_D;
        end else begin
            RegWrite_E <= 1'b0;
            MemWrite_E <= 1'b0;
            Jump_E <= 1'b0;
            Branch_E <= 1'b0;
            ALUSrc_E <= 1'b0;
            ResultSrc_E <= 2'b00;
            ALUControl_E <= 4'b0000;
            RD1_E <= 32'b0;
            RD2_E <= 32'b0;
            PC_E <= 32'b0;
            Rs1_E <= 32'b0;
            Rs2_E <= 32'b0;
            Rd_E <= 32'b0;
            Extimm_E <= 32'b0;
            PCplus4_E <= 32'b0;
        end
    end
endmodule
