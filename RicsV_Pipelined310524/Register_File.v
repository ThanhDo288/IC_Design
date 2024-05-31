////////////////////////////// Register File //////////////////////
module Register_File (
    input clk, reset, WE3, // RegWrite cho phep ghi vao thanh ghi

    input [4:0] rs_1, rs_2, rd, // rs1 =19-15, rs2=24-20 , rd=11-7;
    input [31:0] Write_D, // data ghi vao thanh ghi
    output [31:0] RD1,RD2
    //output reg [31:0] Registers_out [31:0] // 32 thanh ghi 32 bit
);
    //wire [4:0] rs_1, rs_2, rd ;
    //assign rs_1 =Instruction_in[19:15];
    //assign rs_2 =Instruction_in[24:20];
    //assign rd =Instruction_in[11:7];


    reg [31:0] Registers [31:0]; // 32 thanh ghi 32 bit
    integer k;
    // ghi o canh am
    always @(negedge clk or negedge reset) begin
        if(!reset==1) begin
            for(k=0;k<32;k=k+1) Registers[k]<=32'h0;
        end
        else if (WE3==1'b1) Registers[rd]<=Write_D;
    end
    
    assign RD1= Registers[rs_1];
    assign RD2 =Registers[rs_2];

endmodule   