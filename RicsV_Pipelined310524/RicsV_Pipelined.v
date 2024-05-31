
//---------------------------------------------------------------
//                        RISC-V Core
//                          Ver 1.0
//                     EDABK  Laboratory
//                      Copyright  2024
//---------------------------------------------------------------
//    Copyright © 2024 by EDABK Laboratory
//    All rights reserved.
//
//    Module  : control_logic
//    Project : RISC-V 5-stage pipeline
//    Author  : Cao Ngoc Thanh Do
//    Company : EDABK Laboratory
//----------------------------------------------------------------

module RicsV_Pipelined (
    input clk,
    input reset,
    output [31:0] PC_cur,
    output [31:0] Instruction_cur
);

    // Wires to connect the modules
    reg [31:0] RD1_E, RD2_E;
    wire [31:0] PC_out, Instr, PCplus4_out, PCSum_out, Mux_PC_out;
    wire Stall_F, Stall_D, Flush_E;
	  // ID-EX register block
    reg RegWrite_E, MemWrite_E, Jump_E, Branch_E, ALUSrc_E;
    reg [1:0] ResultSrc_E;
    reg [3:0] ALUControl_E;
    reg [31:0] PC_E, Rs1_E, Rs2_E, Rd_E, Extimm_E, PCPlus4_E;
	 // Mux for SrcA_E
    reg [31:0] ALUResult_M, SrcA_E;
    wire [1:0] ForwardA_E;
	 // Mux for SrcB_E
    reg [31:0] Mux_RD2E_out;
    wire [1:0] ForwardB_E;
	 // Mux for SrcB_E
    reg [31:0] SrcB_E;
        // MEM-WB register block
    //reg RegWrite_W;
    reg [1:0] ResultSrc_W;
    reg [31:0] ALUResult_W, ReadData_W, Rd_W, PCPlus4_W;
    
    assign PC_cur = PC_out;
    assign Instruction_cur = Instr;


    // Instantiate the Program Counter (PC)
    PC pc_inst(
        .clk(clk),
        .reset(reset),
        .Mux_PC_out(Mux_PC_out),
        .Stall_F(Stall_F),
        .PC_out(PC_out)
    );

    // Instantiate the Instruction Memory
    Instruction_Memory imem_inst(
        .clk(clk),
        .reset(reset),
        .read_address(PC_out),
        .Instruction_out(Instr)
    );

    // Register IF-ID
    reg [31:0] Instruction_D, PCplus4_D, PC_D;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            Instruction_D <= 32'b0;
            PCplus4_D <= 32'b0;
            PC_D <= 32'b0;
        end else begin
            if (!Stall_D) begin
                Instruction_D <= Instr;
                PCplus4_D <= PCplus4_out;
                PC_D <= PC_out;
            end
        end
    end

    // Instantiate the PC Adder
    PCplus4 pcplus4_inst(
        .PCplus4_in(PC_out),
        .PCplus4_out(PCplus4_out)
    );

    // Instantiate the Register File
	 wire [31:0] RD1, RD2;
    reg [31:0] Result_W;
    reg RegWrite_W;
    Register_File regfile_inst(
        .clk(clk),
        .reset(reset),
        .WE3(RegWrite_W),
        .rs_1(Instruction_D[19:15]),
        .rs_2(Instruction_D[24:20]),
		.rd(Rd_W),
		  //in-out
		  .Write_D(Result_W),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Instantiate the Control Unit
    wire RegWrite_D, MemWrite_D, Jump_D, Branch_D, ALUSrc_D;
    wire [1:0] ResultSrc_D, ImmSrc_D;
    wire [3:0] ALUControl_D;
    wire [31:0] Extimm_D;

    Control_Unit control_inst(
        .Opcode(Instruction_D[6:0]),
        .fun3(Instruction_D[14:12]),
        .fun7(Instruction_D[31:25]),
        .RegWrite_D(RegWrite_D),
        //in-out
        .ResultSrc_D(ResultSrc_D),
        .MemWrite_D(MemWrite_D),
        .Jump_D(Jump_D),
        .Branch_D(Branch_D),
		  .ALUControl_D(ALUControl_D),
		  .ALUSrc_D(ALUSrc_D),
		  .ImmSrc_D(ImmSrc_D)
    );

    // Instantiate the Immediate Generator
    Immediate_Generator immgen_inst(
        .Instruction(Instruction_D),
        .Extimm_D(Extimm_D)
    );

    // ID-EX register block
    
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            RegWrite_E <= 1'b0;
            MemWrite_E <= 1'b0;
            Jump_E <= 1'b0;
            Branch_E <= 1'b0;
            ALUSrc_E <= 1'b0;
            ResultSrc_E <= 2'b00;
            ALUControl_E <= 3'b000;
            RD1_E <= 32'b0;
            RD2_E <= 32'b0;
            PC_E <= 32'b0;
            Rs1_E <= 32'b0;
            Rs2_E <= 32'b0;
            Rd_E <= 32'b0;
            Extimm_E <= 32'b0;
            PCPlus4_E <= 32'b0;
        end else if (!Flush_E) begin
            RegWrite_E <= RegWrite_D;
            MemWrite_E <= MemWrite_D;
            Jump_E <= Jump_D;
            Branch_E <= Branch_D;
            ALUSrc_E <= ALUSrc_D;
            ResultSrc_E <= ResultSrc_D;
            ALUControl_E <= ALUControl_D;
            RD1_E <= RD1;
            RD2_E <= RD2;
            PC_E <= PC_D;
            Rs1_E <= Instruction_D[19:15];
            Rs2_E <= Instruction_D[24:20];
            Rd_E <= Instruction_D[11:7];
            Extimm_E <= Extimm_D;
            PCPlus4_E <= PCplus4_D;
        end else begin
            RegWrite_E <= 1'b0;
            MemWrite_E <= 1'b0;
            Jump_E <= 1'b0;
            Branch_E <= 1'b0;
            ALUSrc_E <= 1'b0;
            ResultSrc_E <= 2'b00;
            ALUControl_E <= 3'b000;
            RD1_E <= 32'b0;
            RD2_E <= 32'b0;
            PC_E <= 32'b0;
            Rs1_E <= 32'b0;
            Rs2_E <= 32'b0;
            Rd_E <= 32'b0;
            Extimm_E <= 32'b0;
            PCPlus4_E <= 32'b0;
        end
    end

    // Mux for SrcA_E
   
    always @(RD1_E or Result_W or ALUResult_M or ForwardA_E) begin
        case (ForwardA_E)
            2'b00: SrcA_E <= RD1_E;
            2'b01: SrcA_E <= Result_W;
            2'b10: SrcA_E <= ALUResult_M;
            default: SrcA_E <= RD1_E;
        endcase
    end

    // Mux for SrcB_E
   
    always @(RD2_E or Result_W or ALUResult_M or ForwardB_E) begin
        case (ForwardB_E)
            2'b00: Mux_RD2E_out <= RD2_E;
            2'b01: Mux_RD2E_out <= Result_W;
            2'b10: Mux_RD2E_out <= ALUResult_M;
            default: Mux_RD2E_out <= RD2_E;
        endcase
    end

    // Mux for SrcB_E

    always @(ALUSrc_E or Mux_RD2E_out or Extimm_E) begin
        case (ALUSrc_E)
            1'b0: SrcB_E <= Mux_RD2E_out;
            1'b1: SrcB_E <= Extimm_E;
            default: SrcB_E <= Mux_RD2E_out;
        endcase
    end

    // Instantiate the Adder for PC + Imm
    Add_PC addpc_inst(
        .PC_E(PC_E),
        .Extimm_E(Extimm_E),
        .PCSum_out(PCSum_out)
    );

    // Instantiate the ALU
    wire [31:0] ALUResult_E;
    wire Zero_E;
    ALU alu_inst(
        .SrcA_E(SrcA_E),
        .SrcB_E(SrcB_E),
        .ALUControl_E(ALUControl_E),
        .Zero_E(Zero_E),
        .ALUResult_E(ALUResult_E)
    );

    // Zero_E and Branch_E or PCsrc_E
    wire PCsrc_E;
    assign PCsrc_E = ((Zero_E && Branch_E) || Jump_E);

    // EX-MEM register block
    reg RegWrite_M, MemWrite_M;
    reg [1:0] ResultSrc_M;
    reg [31:0] WriteData_M, Rd_M, PCPlus4_M;
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            RegWrite_M <= 1'b0;
            MemWrite_M <= 1'b0;
            ResultSrc_M <= 2'b00;
            ALUResult_M <= 32'b0;
            WriteData_M <= 32'b0;
            Rd_M <= 32'b0;
            PCPlus4_M <= 32'b0;
        end else begin
            RegWrite_M <= RegWrite_E;
            MemWrite_M <= MemWrite_E;
            ResultSrc_M <= ResultSrc_E;
            ALUResult_M <= ALUResult_E;
            WriteData_M <= Mux_RD2E_out;
            Rd_M <= Rd_E;
            PCPlus4_M <= PCPlus4_E;
        end
    end

    // Instantiate the Data Memory
    wire [31:0] ReadData_M;
    Data_memory dmem_inst(
        .clk(clk),
        .reset(reset),
        .Address(ALUResult_M),
        .WD(WriteData_M),
        .WE(MemWrite_M),
        .RD(ReadData_M)
    );

    // MEM-WB register block
    //reg RegWrite_W;

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

    // Instantiate the Mux for Memory
    always @(ALUResult_W or ReadData_W or PCPlus4_W or ResultSrc_W) begin
        case (ResultSrc_W)
            2'b00: Result_W <= ALUResult_W;
            2'b01: Result_W <= ReadData_W;
            2'b10: Result_W <= PCPlus4_W;
            default: Result_W <= ALUResult_W;
        endcase
    end

    // Instantiate the Mux for PC
    Mux_PC mux_pc_inst(
        .PCplus4_out(PCplus4_out),
        .PCSum_out(PCSum_out),
        .MuxPC(PCsrc_E),
        .Mux_PC_out(Mux_PC_out)
    );

    // Instantiate the Hazard Unit
    Hazard_Unit hazard_unit(
        .Rs1_D(Instruction_D[19:15]),
        .Rs2_D(Instruction_D[24:20]),
        .Rs1_E(Rs1_E),
        .Rs2_E(Rs2_E),
        .Rd_E(Rd_E),
        .Rd_M(Rd_M),
        .Rd_W(Rd_W),
        .ResultSrc_E0(ResultSrc_E[0]),
        .RegWrite_M(RegWrite_M),
        .RegWrite_W(RegWrite_W),
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E),
        .Stall_F(Stall_F),
        .Stall_D(Stall_D),
        .Flush_E(Flush_E)
    );

endmodule
