// Verilog module for circuit in problem 5
// Andres Aguilar for ECE 2372

module circuit( output out, input a, b, c, d); // declare module that models the circuit
    reg notA, notC, e, f, g;

    always @(b or c) begin
        e <= #2 b & c;
    end
    always @(c) begin
        notC <= #1 ~c;
    end
    always @(a) begin
        notA <= #1 ~a;
    end
    always @(notA or notC or d) begin
        f <= #2 notA & notC & d;
    end
    always @(e or f) begin
        g <= #2 e | f;
    end
    assign out = g;
endmodule

module testbench; // redo
    reg s, t, u, v; // declare inputs for circuit
    wire out; // declare outputs

    circuit uut(out, s, t, u, v); // initialize testbench

    initial begin // test for these values (need help to create loop, will ask you later)
        s = 1'b0;
        t = 1'b1;
        u = 1'b1;
        v = 1'b1;
        #10;
        u = 1'b0;
        #50;
	end
    initial begin
		$monitor ("s=%d t=%d u=%d v=%d out=%d", s, t, u, v, out);
		$dumpfile("circuit.vcd");
		$dumpvars(0, testbench);
	end
endmodule



