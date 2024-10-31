module multiplier(input [1:0]a, input [1:0]b, output[3:0]f);

    // X = A1A2B1B2
    assign f[3] = a[1] & a[0] & b[1] & b[0];

    // Y = A1B1 (A`2 + A2B`2)
    assign f[2] = (a[0] & b[0]) & (~a[1] + (a[1] & ~b[1]));

    // Z = A1A2(B`1B2 + B1B`2)
    assign f[1] = (a[0] & a[1]) & ( b[0] ^ b[1] );

    // D = A2B2(A`1B1 + A1B`1)
    assign f[0] = (a[1] & b[1]) & ( a[0] ^ b[0] );

endmodule

module testbench;

    reg[1:0]a;
    reg[1:0]b;
    wire[3:0]f;

    multiplier m1(a, b, f);

    initial begin
        a = 2'b00;
        b = 2'b00;
        #10;
        a = 2'b00;
        b = 2'b01;
        #10;
        a = 2'b00;
        b = 2'b10;
        #10;
        a = 2'b00;
        b = 2'b11;
        #10;

        a = 2'b01;
        b = 2'b00;
        #10;
        a = 2'b01;
        b = 2'b01;
        #10;
        a = 2'b01;
        b = 2'b10;
        #10;
        a = 2'b01;
        b = 2'b11;
        #10;

        a = 2'b10;
        b = 2'b00;
        #10;
        a = 2'b10;
        b = 2'b01;
        #10;
        a = 2'b10;
        b = 2'b10;
        #10;
        a = 2'b10;
        b = 2'b11;
        #10;

        a = 2'b11;
        b = 2'b00;
        #10;
        a = 2'b11;
        b = 2'b01;
        #10;
        a = 2'b11;
        b = 2'b10;
        #10;
        a = 2'b11;
        b = 2'b11;
        #10;
    end

    initial begin
        $monitor("a=%d;   b=%d;   f=%d", a, b, f);
    end

    initial begin
        $dumpfile("hw3.vcd");
        $dumpvars(0, testbench);
    end

endmodule