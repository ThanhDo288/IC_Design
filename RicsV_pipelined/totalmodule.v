

////////////////////////////// IMEM Block //////////////////////
module Instruction_Memory(
    input clk, reset,
    input [31:0] read_address, // doc dia chi cau lenh tu PC
    output [31:0]  Instruction_out // ma lenh dau ra
);
    reg [31:0] Imemory [63:0]; // 64 thanh ghi chua lenh , moi lenh 32bit
    integer k;
    assign Instruction_out=Imemory[read_address];
    always @( posedge clk or negedge reset ) begin
        if(! reset==1) begin
            for(k=0; k<64; k=k+1) begin 
                Imemory[k]<=32'h0;
            end
        end
    end
endmodule
////////////////////////////// Program Counter Block //////////////////////
module PC (
input clk, reset,
input [31:0] Mux_PC_out,
output reg [31:0] PC_out
);
    always @(posedge clk or negedge reset) begin
        if(!reset==1) 
            PC_out <=32'h0;
        else 
            PC_out <= Mux_PC_out;
    end
endmodule

////////////////////////////// PC Adder //////////////////////
module PCplus4(
    input [31:0] PCplus4_in, //PC_out
    output [31:0] PCplus4_out
);
    assign PCplus4_out= PCplus4_in + 32'h00000004;
endmodule

////////////////////////////// Register File //////////////////////
module Register_File (
    input clk, reset, RegWrite, // RegWrite cho phep ghi vao thanh ghi
    input [31:0] Instruction_in,
    //input [4:0] rs_1, rs_2, rd ; // rs1 =19-15, rs2=24-20 , rd=11-7;
    input [31:0] Write_data, // data ghi vao thanh ghi
    output [31:0] Read_data1,Read_data2
);
    wire [4:0] rs_1, rs_2, rd ;
    assign rs_1 =Instruction_in[19:15];
    assign rs_2 =Instruction_in[24:20];
    assign rd =Instruction_in[11:7];


    reg [31:0] Registers [31:0]; // 32 thanh ghi 32 bit
    integer k;
    always @(posedge clk or negedge reset) begin
        if(!reset==1) begin
            for(k=0;k<32;k=k+1) Registers[k]=32'h0;
        end
        else if (RegWrite==1'b1) Registers[rd]=Write_data;
    end
    assign Read_data1= Registers[rs_1];
    assign Read_data2 =Registers[rs_2];

endmodule   
////////////////////////////// immediate generator //////////////////////
// tao gia tri immidiate tu 12bit thanh 32bit
module Immediate_Generator (
    input [6:0] Opcode, 
    input [31:0] instruction,  
    output reg [31:0] ImmExt // imm 32bit
);
    always @(Opcode or instruction) begin
        case (Opcode)
            7'b0010011: ImmExt= {{20{instruction[31]}}, instruction[31:20]}; // I instruction
            7'b0100011: ImmExt= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // S instruction
            7'b1100011: ImmExt= {{20{instruction[31]}},instruction[31], instruction[7], instruction[30:25],instruction[11:8]}; // B instruction
            default:  ImmExt= {{20{instruction[31]}},instruction[31:20]}; //  instruction
        endcase
    end
endmodule 

////////////////////////////// Control_Unit //////////////////////
module Control_Unit (
    input [31:0] Instruction, 
    //input [6:0] Opcode,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
);
wire [6:0] Opcode;
assign Opcode = Instruction[6:0];
 always@(*)
    begin
        case (Opcode)
        7'b0110011: begin // R-type instr
        ALUSrc<=0; MemtoReg<=0;RegWrite<=1; MemRead<=0; MemWrite<=0;Branch<=0; 
        ALUOp<=2'b10;
        end
        7'b0000011: begin // Load Instruction LW
        ALUSrc<=1; MemtoReg<=1;RegWrite<=1; MemRead<=1; MemWrite<=0;Branch<=0; 
        ALUOp<=2'b00;
        end
        7'b0100011: begin // store Instr SW MetoReg<=X
        ALUSrc<=1; MemtoReg<=1;RegWrite<=0; MemRead<=0; MemWrite<=1;Branch<=0; 
        ALUOp<=2'b00;    
        end
        7'b0000011: begin // B-type MetoReg<=X
        ALUSrc<=0; MemtoReg<=0;RegWrite<=0; MemRead<=0; MemWrite<=1;Branch<=1; 
        ALUOp<=2'b01;    
        end
        default: begin // same R-type instr
        ALUSrc<=0; MemtoReg<=0;RegWrite<=1; MemRead<=0; MemWrite<=0;Branch<=0; 
        ALUOp<=2'b10;
        end
        endcase
    end
endmodule
////////////////////////////// ALU //////////////////////

module ALU(
    input [31:0] Read_data1, ALU_in2, // ALU_in2<= Mux_Register_out
    input [3:0] ALUControl,
    output reg Zero,
    output reg [31:0] ALUResult
);
    always @(ALUControl or Read_data1 or ALU_in2 )
    begin
        case (ALUControl)
        4'b0000: begin Zero<=0; ALUResult<= Read_data1&ALU_in2; end
        4'b0001: begin Zero<=0; ALUResult<= Read_data1||ALU_in2; end
        4'b0010: begin Zero<=0; ALUResult<= Read_data1 + ALU_in2; end
        4'b0110: begin if(Read_data1==ALU_in2) Zero<=1;  
                        else  Zero<=0;
                        ALUResult<= Read_data1-ALU_in2; end
        default:  begin Zero<=0; ALUResult<= Read_data1&ALU_in2; end
        endcase
    end
endmodule
///////////////////////////// ALU-control //////////////////////

module ALU_Control(
    input [1:0] ALUOp,
    input [31:0] Instruction,
    //input [6:0]func7,
    //input func7,
    //input [2:0] func3,
    output reg [3:0] ALUControl
);
    wire func7;
    wire[2:0] func3;
    assign func7=Instruction[30];
    assign func3=Instruction[14:12];
    
    always @(ALUOp or func7 or func3 )
    begin
        case ({ALUOp,func7,func3})
        6'b000000: begin ALUControl<=4'b0010; end 
        6'b010000: begin ALUControl<=4'b0110; end
        6'b100000: begin ALUControl<=4'b0010; end
        6'b101000: begin ALUControl<=4'b0110; end
        6'b100111: begin ALUControl<=4'b0000; end
        6'b100110: begin ALUControl<=4'b0001; end

        default  : begin ALUControl<=4'b0001; end
        endcase
    end
endmodule
///////////////////////////// Data_memory //////////////////////
module Data_memory(
    input clk, reset,
    input [31:0] Address, // dia chi cua o nho
    input [31:0] Write_data, // du lieu ghi vao ney co
    input [31:0] MemWrite,MemRead,   // cho phep ghi/doc vao thanh ghi hay khong
    output [31:0] Read_data // ma lenh dau ra
    

);
    reg [31:0] Dmemory [63:0]; // 64 thanh ghi chua du lieu , moi o nho 32bit
    
    assign Read_data= (MemRead)?  Dmemory[Address]: 32'b0;


    integer k;
    always @( posedge clk or negedge reset ) begin
        if(! reset==1) begin
            for(k=0; k<64; k=k+1) begin 
                Dmemory[k]<=32'h0;
            end
        end
        else begin
            if(MemWrite==1)   Dmemory[Address]<= Write_data;
            //else Read_data<= Dmemory[Address];
        
        end
    end
endmodule
///////////////////////////// Mux-block- datamemory //////////////////////
module Mux_Memory(
    input [31:0] Read_data,
    input [31:0] ALUResult,
    input MemtoReg,
    output [31:0] Mux_Memory_out
);
    assign Mux_Memory_out= (MemtoReg)? Read_data: ALUResult;
endmodule
///////////////////////////// Mux-block- Register //////////////////////
module Mux_Register(
    input [31:0] Read_data2,
    input [31:0] ImmExt,
    input ALUSrc,
    output [31:0] Mux_Register_out
);
    assign Mux_Register_out= (ALUSrc)? ImmExt: Read_data2;
endmodule
///////////////////////////// Add- PC //////////////////////
module Add_PC(
    input [31:0] PC_out,
    input [31:0] ImmExt,
    output [31:0] PCSum_out
);
    assign PCSum_out= PC_out+ImmExt;
endmodule
///////////////////////////// Mux-block- PC //////////////////////
module Mux_PC(
    input [31:0] PCplus4_out,
    input [31:0] PCSum_out,
    input Zero,
    input Branch,
    output [31:0] Mux_PC_out
);
    assign Mux_PC_out= (Zero&Branch)? PCSum_out: PCplus4_out;
endmodule
