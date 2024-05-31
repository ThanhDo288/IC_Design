///////////////////////////// Data_memory //////////////////////
module Data_memory(
    input clk, reset,
    input [31:0] Address, // dia chi cua o nho
    input [31:0] WD, // du lieu ghi vao ney co
    input  WE,   // cho phep ghi/doc vao thanh ghi hay khong
    //output reg [31:0] Dmemory [63:0],
	 output [31:0] RD // ma lenh dau ra
    
    

);
    reg [31:0] Dmemory [63:0]; // 64 thanh ghi chua du lieu , moi o nho 32bit
    
    assign RD= (!WE)?  Dmemory[Address]: 32'b0;


    integer k;
    always @( negedge clk or negedge reset ) begin
        if(! reset==1) begin
            for(k=0; k<64; k=k+1) begin 
                Dmemory[k]<=32'h0;
            end
        end
        else begin
            if(WE==1)   Dmemory[Address]<= WD;
        
        end
    end
endmodule