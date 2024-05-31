module Mux_SrcA_E (
    input [31:0] RD1_E,
    input [31:0] Result_W,
    input [31:0] ALUResult_M,
    input [1:0] ForwardA_E,
    output reg [31:0] SrcA_E
);
    always @(RD1_E or Result_W or ALUResult_M or ForwardA_E) begin
        case (ForwardA_E)
            2'b00: SrcA_E <= RD1_E;
            2'b01: SrcA_E <= Result_W;
            2'b10: SrcA_E <= ALUResult_M;
            default: SrcA_E <= RD1_E;
        endcase
    end
endmodule
