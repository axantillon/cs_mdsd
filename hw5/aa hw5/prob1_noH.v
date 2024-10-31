// ECE 2372
// Andres Antillon
// Homework 5 (b)

module circuit(
    input A, B, C, D,
    output reg G
);

    reg not_A, not_C;
    reg BC_and, ACD_and, ABD_and;

    // Inverters
    always @(A) begin 
        not_A <= #1 ~A;
    end
    always @(C) begin
        not_C <= #1 ~C;
    end

    // AND gates
    always @(B or C) begin
        BC_and <= #2 B & C;
    end
    always @(not_A or not_C or D) begin
        ACD_and <= #2 not_A & not_C & D;
    end
    always @(not_A or B or D) begin
        ABD_and <= #2 not_A & B & D;
    end

    // OR gate
    always @(BC_and or ACD_and or ABD_and) begin
        G <= #2 BC_and | ACD_and | ABD_and;
    end

endmodule

// Testbench
module testbench;

    reg A, B, C, D;
    wire G;

    circuit uut(A, B, C, D, G);

    initial begin
        $dumpfile("prob1_noH.vcd");
        $dumpvars(0, testbench);

        A = 1'b0; B = 1'b1; C = 1'b1; D = 1'b1;
        
        #10 C = 1'b0;
        #20;
    end

    initial begin
        $monitor("Time=%0t A=%b B=%b C=%b D=%b G=%b", $time, A, B, C, D, G);
    end

endmodule
