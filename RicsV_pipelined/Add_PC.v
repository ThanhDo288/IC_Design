///////////////////////////// Add- PC //////////////////////
module Add_PC(
    input [31:0] PC_E,
    input [31:0] Extimm_E,
    output [31:0] PCSum_out
);
    assign PCSum_out= PC_E+Extimm_E;
endmodule