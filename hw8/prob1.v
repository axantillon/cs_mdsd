// ECE 2372
// Andres Antillon
// Homework 8 Problem 1

module SR_Latch(
    output Q,
    output NQ,
    input S,
    input R
);

    nor #1 nor1(NQ, S, Q);
    nor #1 nor2(Q, R, NQ);

endmodule

module struct_T_FF(
    output Q,
    output NQ,
    input clk,
    input T,
    input clr
);

    wire wMs, wMr, wORclr, wSs, wSr, wNclk, wP, wNP;

    not #1 not1(wNclk, clk);

    and #1 and1(wMs, NQ, T, wNclk);
    and #1 and2(wMr, Q, T, wNclk);
    or #1 or1(wORclr, wMr, clr);

    SR_Latch masterSR(wP, wNP, wMs, wORclr);
    
    and #1 and3(wSs, wP, clk);
    and #1 and4(wSr, wNP, clk);

    SR_Latch slaveSR(Q, NQ, wSs, wSr);
    
endmodule

module counter(
    output [3:0] Q,
    input clk,
    input clr
);

    wire Tc, Td;
    wire [3:0] nQ;

    and #1 and1(Tc, Q[0], Q[1]);
    and #1 and2(Td, Q[0], Q[1], Q[2]);

    struct_T_FF t_flip1(Q[0], nQ[0], clk, 1'b1, clr);
    struct_T_FF t_flip2(Q[1], nQ[1], clk, Q[0], clr);
    struct_T_FF t_flip3(Q[2], nQ[2], clk, Tc, clr);
    struct_T_FF t_flip4(Q[3], nQ[3], clk, Td, clr);

endmodule

module testbench;

    reg clk, clr;
    wire [3:0] Q;

    integer i;

    counter counter1(Q, clk, clr);
    

    /* Clock Signal */
	initial begin
		clk = 1'b0;
		#50;
		for (i=0; i<32; i++) begin
			clk = ~clk;
			#50;
		end
	end

    initial begin
		/* Start with all zeros */
        clr = 1'b1;
        #100
        clr = 1'b0;
	end


    initial begin
        $dumpfile("prob1.vcd");
        $dumpvars(0, testbench);     
    end

endmodule
