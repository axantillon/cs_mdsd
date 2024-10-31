// ECE 2372
// Andres Antillon
// Homework 6 Problem 1


//Part a)
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

module behavior_T_FF(
    output reg Q, NQ,
    input clk,
    input T,
    input clr
);

    always @(posedge clk) begin
        if (clr) begin
            Q <= 1'b0;
            NQ <= 1'b1;
        end
        else if (T) begin
            Q <= ~Q;
            NQ <= ~NQ;
        end
    end

endmodule

module testbench;

    reg clk, T, clr;
    wire gQ, gNQ, bQ, bNQ;

    integer i, j;

    struct_T_FF t_flip(gQ, gNQ, clk, T, clr);
    behavior_T_FF t_flip_behave(bQ, bNQ, clk, T, clr);
    

    /* Clock Signal */
	initial begin
		clk = 1'b0;
		#50;
		for (i=0; i<16; i++) begin
			clk = ~clk;
			#50;
		end
	end

    initial begin
		/* Start with all zeros */
        clr = 1'b1;
        #100
        clr = 1'b0;
        #20
		T = 1'b0;
		#20;
        T = 1'b1;
        #50;
        T = 1'b0;
        #50;
        T = 1'b1;
        #50;
        T = 1'b0;
        #100;
        T = 1'b0;
        #50;
        T = 1'b1;
        #50;
        T = 1'b0;

	end


    initial begin
        $dumpfile("prob2.vcd");
        $dumpvars(0, testbench);     
    end

endmodule
