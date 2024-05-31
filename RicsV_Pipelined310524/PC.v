////////////////////////////// Program Counter Block //////////////////////
module PC (
input clk, reset,
input [31:0] Mux_PC_out,
input Stall_F,
output reg [31:0] PC_out
);
    always @(posedge clk or negedge reset) begin
        if(!reset==1) 
            PC_out <=32'h0;
        else 
        if(!Stall_F) begin
            PC_out <= Mux_PC_out;
        end
        else begin
            PC_out <= PC_out;
        end
    end
endmodule
