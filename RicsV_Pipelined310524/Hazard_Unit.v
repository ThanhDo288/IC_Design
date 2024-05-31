module Hazard_Unit(
    input [4:0] Rs1_E, Rs2_E, Rs1_D, Rs2_D,
    input [4:0] Rd_M, Rd_W, Rd_E,
    input ResultSrc_E0,
    input RegWrite_M, RegWrite_W,
    output reg [1:0] ForwardA_E, ForwardB_E,
    output reg Stall_F, Stall_D, Flush_E
);

    // load word stall signal
    wire lwStall;
    assign lwStall = ((Rs1_D == Rd_E) || (Rs2_D == Rd_E)) && ResultSrc_E0;

    // Assign stall and flush signals
    always @(*) begin
        Stall_F = lwStall;
        Stall_D = lwStall;
        Flush_E = lwStall;
    end

    // Forwarding logic
    always @(*) begin
        // Initialize outputs
        ForwardA_E = 2'b00;
        ForwardB_E = 2'b00;

        // Forwarding logic for A
        if ((Rs1_E == Rd_M) && RegWrite_M)
            ForwardA_E = 2'b10;
        else if ((Rs1_E == Rd_W) && RegWrite_W)
            ForwardA_E = 2'b01;

        // Forwarding logic for B
        if ((Rs2_E == Rd_M) && RegWrite_M)
            ForwardB_E = 2'b10;
        else if ((Rs2_E == Rd_W) && RegWrite_W)
            ForwardB_E = 2'b01;
    end
endmodule
