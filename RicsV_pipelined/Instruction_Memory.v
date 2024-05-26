module Instruction_Memory(
    input clk, reset,
    input [31:0] read_address, // doc dia chi cau lenh tu PC
    output [31:0] Instruction_out // ma lenh dau ra
);
    reg [7:0] Imemory [255:0]; // 256 ô nhớ, mỗi ô chứa 1 byte
    integer k;
    
    assign Instruction_out = {Imemory[read_address], Imemory[read_address + 1], Imemory[read_address + 2], Imemory[read_address + 3]};

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (k = 0; k < 256; k = k + 1) begin 
                Imemory[k] <= 8'h00;
            end
            // Khởi tạo các lệnh trực tiếp
            Imemory[0] <= 8'h00;
            Imemory[1] <= 8'h40;
            Imemory[2] <= 8'h80;
            Imemory[3] <= 8'h93;  // 0x00000093 // addi x1, x1, 4;
        end
    end
endmodule