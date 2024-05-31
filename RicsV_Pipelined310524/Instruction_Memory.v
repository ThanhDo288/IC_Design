module Instruction_Memory(
    input clk, reset,
    input [31:0] read_address, // doc dia chi cau lenh tu PC
    output [31:0] Instruction_out // ma lenh dau ra
);
    reg [7:0] Imemory [255:0]; // 256 ô nhớ, mỗi ô chứa 1 byte
    integer k;


    initial begin
    $readmemh("C:/questasim64_10.2c/examples/riscV_instr/hexa.txt", Imemory);
     end

    
    
    assign Instruction_out = {Imemory[read_address], Imemory[read_address + 1], Imemory[read_address + 2], Imemory[read_address + 3]};

    // always @(posedge clk or negedge reset) begin
    //     if (!reset) begin
    //         for (k = 0; k < 256; k = k + 1) begin 
    //             Imemory[k] <= 8'h00;
    //         end
    //         //0
    //         Imemory[0] <= 8'h00;
    //         Imemory[1] <= 8'h31; 
    //         Imemory[2] <= 8'h00;
    //         Imemory[3] <= 8'hB3;  // add x1, x2, x3
    //         // 1
    //         Imemory[4] <= 8'h00;
    //         Imemory[5] <= 8'h20;
    //         Imemory[6] <= 8'h01;
    //         Imemory[7] <= 8'h13; // addi x2, x0, 2
    //         // 2
    //         Imemory[8] <= 8'h00; 
    //         Imemory[9] <= 8'hC0;
    //         Imemory[10] <= 8'h01;
    //         Imemory[11] <= 8'h93; //addi x3, x0, 12
    //         // 3
    //         Imemory[12] <= 8'h40;
    //         Imemory[13] <= 8'h21;
    //         Imemory[14] <= 8'h80;
    //         Imemory[15] <= 8'hb3;//  // sub x1, x3, x2 
    //         // 4
    //         Imemory[16] <= 8'h40;
    //         Imemory[17] <= 8'h20;
    //         Imemory[18] <= 8'h80;
    //         Imemory[19] <= 8'hb3; //// sub x1, x1, x2
    //     end
    // end

    // always @(posedge clk or negedge reset) begin
    //     if (!reset) begin
    //         Instruction_out <=0;
    //     end
    //     else begin
    //         Instruction_out <= {Imemory[read_address], Imemory[read_address + 1], Imemory[read_address + 2], Imemory[read_address + 3]}

    //     end
    // end
endmodule
