////////////////////////////// immediate generator //////////////////////
// tao gia tri immidiate tu 12bit thanh 32bit
module Immediate_Generator (
    //input [1:0] ImmSrc_D, 
    input [31:0] Instruction,  
    output reg [31:0] Extimm_D // imm 32bit
);
    always @( Instruction) begin
        case (Instruction[6:0])
            // I type
            7'b0010011: Extimm_D = {{20{Instruction[31]}}, Instruction[31:20]};
            // L type
            7'b0000011: Extimm_D = {{20{Instruction[31]}}, Instruction[31:20]};
            // S type
            7'b0100011: Extimm_D = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
            // B type
            7'b1100011: Extimm_D = {{20{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8]};
            // J type
            7'b1101111: Extimm_D = {{12{Instruction[31]}}, Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21]};
            default: Extimm_D = 32'b0; 
        endcase
    end
endmodule 