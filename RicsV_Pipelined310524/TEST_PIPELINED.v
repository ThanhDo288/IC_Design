
module TEST_PIPELINED();
    // Khai b�o c�c t�n hi?u
    reg clk;
    reg reset;
    wire [31:0] PC_cur, Instruction_cur;

    // Kh?i t?o thi?t b? c?n ki?m tra
    RicsV_Pipelined uut (
        .clk(clk),
        .reset(reset),
        .PC_cur(PC_cur),
        .Instruction_cur(Instruction_cur)
    );

    // Kh?i t?o clock
    always begin
        clk = 1'b0; 
        #40; 
        clk = 1'b1; 
        #40;
    end

    // Kh?i t?o reset v� truy?n l?nh v�o b? nh? l?nh
    initial begin
        // Kh?i t?o reset
        reset = 1'b1;
        #10;
        reset = 1'b0;
        
        // H?y reset
        #10;
        reset = 1'b1;

        // Ch?y m� ph?ng m?t th?i gian
        #1000;

        // K?t th�c m� ph?ng
        $finish;
    end

    // Gi�m s�t ??u ra
    always @(posedge clk) begin
        $display("PC: %h, Instruction: %h", PC_cur, Instruction_cur);
    end
endmodule
