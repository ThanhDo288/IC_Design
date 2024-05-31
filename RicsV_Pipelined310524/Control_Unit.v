////////////////////////////// Control_Unit //////////////////////
module Control_Unit (
    input [6:0] Opcode,
    input [2:0] fun3,
    input [6:0]fun7,
    output reg RegWrite_D,
    output reg [1:0] ResultSrc_D,
    output reg MemWrite_D, 
    output reg Jump_D, 
    output reg Branch_D,
    output reg [3:0] ALUControl_D,
    output reg ALUSrc_D,
    output reg [1:0] ImmSrc_D
);
//wire [6:0] Opcode;
//assign Opcode = Instruction[6:0];
reg [1:0]ALUOp;
 always@(*)
    begin
        case (Opcode)
       7'b0110011: begin // R-Type
			RegWrite_D = 1;
			ImmSrc_D = 2'b00;
			ALUSrc_D = 0;
			MemWrite_D = 0;
			ResultSrc_D = 2'b00;
			Branch_D = 0;
			ALUOp = 2'b10;
			Jump_D = 0;
		end
		7'b 0010011: begin // I-Type
			RegWrite_D = 1;
			ImmSrc_D = 2'b00;
			ALUSrc_D = 1;
			MemWrite_D = 0;
			ResultSrc_D = 2'b00;
			Branch_D = 0;
			ALUOp = 2'b01;
			Jump_D = 0;
		end
		7'b 0100011: begin // S-Type
			RegWrite_D = 0;
			ImmSrc_D = 2'b01;
			ALUSrc_D = 1;
			MemWrite_D = 1;
			Branch_D=0;
			ALUOp=2'b00;
			Jump_D = 0;
		end
		7'b 0000011: begin // L-Type
			RegWrite_D = 1;
			ImmSrc_D = 2'b01;
			ALUSrc_D = 1;
			MemWrite_D = 0;
			Branch_D = 0;
			ALUOp = 2'b00;
			ResultSrc_D = 2'b01;
			Jump_D = 0;
		end
		7'b 1100011: begin // B-Type
			RegWrite_D=0;
			ImmSrc_D=2'b10;
			ALUSrc_D=0;
			MemWrite_D=0;
			Branch_D=1;
			ALUOp=2'b11;
			Jump_D = 0;
		end
		7'b 1101111: begin // J-Type
			RegWrite_D = 1;
			ImmSrc_D = 2'b10;
			ALUSrc_D = 0;
			MemWrite_D = 0;
			Branch_D = 0;
			ALUOp = 2'b10;
			ResultSrc_D = 2'b10;
			Jump_D = 1;
		end
        default: 
        begin // J-Type
			RegWrite_D = 1;
			ImmSrc_D = 2'b00;
			ALUSrc_D = 0;
			MemWrite_D = 0;
			ResultSrc_D = 2'b00;
			Branch_D = 0;
			ALUOp = 2'b10;
			Jump_D = 0;
		end
        endcase
    end

    parameter ADD_ALU = 4'b0000;
    parameter SUB_ALU = 4'b0001;
    parameter AND_ALU = 4'b0010;
    parameter OR_ALU =  4'b0011;
    parameter XOR_ALU = 4'b0100;
    parameter SLT_ALU = 4'b0101;
    parameter SHL_ALU = 4'b0110;
    parameter SHR_ALU = 4'b0111;
    parameter SGTe_ALU= 4'b1000;
    parameter EQUAL_ALU = 4'b1001;
    parameter NOT_EQUAL_ALU = 4'b1010;
    parameter ALUCONTROL_WIDTH = 4;
    parameter fun3_WIDTH = 3;
    parameter fun7_WIDTH = 7;
    parameter ALU_OP_WIDTH = 2;
    // alu control
    wire [fun3_WIDTH+fun7_WIDTH-1:0] get_fun;
    assign get_fun = {fun3, fun7};
    always@(*) begin // sai ở chỗ alway @ (get_fun)
//-----------------------------------R-Type-----------------------------------//
    if(ALUOp == 2'b10) begin
        case(get_fun)  
            // add
            10'b0000000000: begin 
                ALUControl_D = ADD_ALU;
            end
            // sub
            10'b0000100000: begin 
                ALUControl_D = SUB_ALU;
            end
            // xor
            10'b1000000000: begin 
                ALUControl_D = XOR_ALU; 
            end
            // or
            10'b1100000000: begin
                ALUControl_D = OR_ALU;
            end
            // and
            10'b1110000000: begin 
                ALUControl_D = AND_ALU;
            end
            // shift_left
            10'b0010000000: begin 
                ALUControl_D = SHL_ALU;
            end
            // shift_right
            10'b1010100000: begin 
                ALUControl_D = SHR_ALU;
            end
            // less_than
            10'b0100000000: 
                ALUControl_D = SLT_ALU;
        endcase
    end

//-----------------------------------I-Type-----------------------------------//
    
    else if(ALUOp == 2'b01) begin
            case(fun3)
            // add
            3'b000: begin 
                ALUControl_D = ADD_ALU;
            end
            // xor
            3'b100: begin 
                ALUControl_D = XOR_ALU;
            end
            // or
            3'b110: begin 
                ALUControl_D = OR_ALU;
            end
            // and
            3'b111: begin 
                ALUControl_D = AND_ALU;
            end
            // shift_left
            3'b001: begin 
                ALUControl_D = SHL_ALU;
            end
            // shift_right
            3'b101: begin 
                ALUControl_D = SHR_ALU;
            end
            // less_than
            3'b010: begin 
                ALUControl_D = SLT_ALU;
            end
            endcase
    end

//-------------------------------S-Type | L-Type------------------------------//

    else if(ALUOp == 2'b00) begin
        ALUControl_D = ADD_ALU;
    end

//-----------------------------------B-Type-----------------------------------//

    else begin
        case(fun3)
            3'b000: begin
                ALUControl_D = SUB_ALU;
            end
            3'b001: begin
                ALUControl_D = NOT_EQUAL_ALU;
            end
            3'b100: begin
                ALUControl_D = SLT_ALU;
            end
            3'b101: begin
                ALUControl_D = SGTe_ALU;
            end
        endcase
    end
end

endmodule