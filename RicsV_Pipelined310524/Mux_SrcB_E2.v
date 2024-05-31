module Mux_SrcB_E2(
    input ALUSrc_E,
    input [31:0] Mux_RD2E_out,
    input [31:0] Extimm_E,
    output reg [31:0] SrcB_E
);
    always @(ALUSrc_E or Mux_RD2E_out or Extimm_E) begin
        case (ALUSrc_E)
            1'b0: SrcB_E <= Mux_RD2E_out;
            1'b1: SrcB_E <= Extimm_E;
            default: SrcB_E <= Mux_RD2E_out;
        endcase
    end
endmodule
