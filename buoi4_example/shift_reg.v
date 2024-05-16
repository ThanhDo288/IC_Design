module shift_reg #(
    parameter n = 8
)
(
	input clk, rst_n,
	input leftright,
	input [n-1:0] data,
	input load,
	input serial_data,
	output reg [n-1:0] R
);

always @(posedge clk or negedge rst_n)
begin
	if(~rst_n) R<=0;
	else begin
	if(load==1) R<=data;
	else if(leftright==1) R<={R[n-2:0],serial_data};
	else  R<={serial_data,R[n-1:1]};
	end	
end
endmodule