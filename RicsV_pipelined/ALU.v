////////////////////////////// ALU //////////////////////

module ALU #(
    parameter ADD_ALU = 4'b0000,
    parameter SUB_ALU = 4'b0001,
    parameter AND_ALU = 4'b0010,
    parameter OR_ALU = 4'b0011,
    parameter XOR_ALU = 4'b0100,
    parameter SLT_ALU = 4'b0101,
    parameter SHL_ALU = 4'b0110,
    parameter SHR_ALU = 4'b0111,
    parameter SGTe_ALU = 4'b1000,
    parameter EQUAL_ALU = 4'b1001,
    parameter NOT_EQUAL_ALU = 4'b1010


)(
    input [31:0] SrcA_E, SrcB_E, // SrcB_E<= Mux_Register_out
    input [3:0] ALUControl_E,
    output wire Zero_E,
    output reg [31:0] ALUResult_E
);
    assign Zero_E = (ALUControl_E == 32'b0);
    always @(ALUControl_E or SrcA_E or SrcB_E )
    begin
        case (ALUControl_E)
		// ADD
		ADD_ALU: ALUResult_E = SrcA_E + SrcB_E; 
		// SUB
		SUB_ALU: ALUResult_E = SrcA_E - SrcB_E;
		// OR
		OR_ALU: ALUResult_E = SrcA_E | SrcB_E;
		// AND 
		AND_ALU: ALUResult_E = SrcA_E & SrcB_E;
		// XOR
		XOR_ALU: ALUResult_E = SrcA_E ^ SrcB_E;
		// SLT
		SLT_ALU: ALUResult_E = (SrcA_E < SrcB_E) ? 1 : 0;
		// SHL
		SHL_ALU: ALUResult_E = SrcA_E << SrcB_E;
		// SHR
		SHR_ALU: ALUResult_E = SrcA_E >> SrcB_E;
		// SGTe
		SGTe_ALU: ALUResult_E = (SrcA_E >= SrcB_E) ? 1 : 0;
		// EQUAL
		EQUAL_ALU: ALUResult_E = (SrcA_E == SrcB_E) ? 1 : 0;
		// NOT_EQUAL
		NOT_EQUAL_ALU: ALUResult_E = (SrcA_E != SrcB_E) ? 1 : 0;

		default: ALUResult_E = 0;
        endcase
    end
endmodule