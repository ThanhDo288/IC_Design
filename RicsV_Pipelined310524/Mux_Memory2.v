module Mux_Memory2 (
    input [31:0] ALUResult_W,
    input [31:0] ReadData_W,
    input [31:0] PCPlus4_W,
    input [1:0] ResultSrc_W,
    output reg [31:0] Result_W
);
     always @(ALUResult_W or ReadData_W or PCPlus4_W or ResultSrc_W) begin
        case (ResultSrc_W)
            2'b00: Result_W <= ALUResult_W;
            2'b01: Result_W <= ReadData_W;
            2'b10: Result_W <= PCPlus4_W;
            default: Result_W <= ALUResult_W;
        endcase
    end
endmodule
