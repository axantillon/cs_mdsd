module complex(input a, input b, output f);
    // Gate level Attempt
    // wire A , B, NotA, And1, Or1, Or2;

    // not n1(NotA, A);
    // and a1(And1, NotA, A);
    // or o1(Or1, And1, B);
    // or or2(Or2, B, B);
    // or or3(f, Or1, Or2);


    // Behavioral attempt
    assign f = ( ( (~a & a) | b) | (b | b) );
    
endmodule

module simple(input a, input b, output c);
    assign c = b;

endmodule

module testbench;
    reg a, b;
    wire simple, complex;

    simple s1(a, b, simple);
    complex c1(a, b, complex);

    initial begin
        a = 0; b = 0;
        #10 
        a = 0; b = 1;
        #10 
        a = 1; b = 0;
        #10 
        a = 1; b = 1;
        #10;
    end

    initial begin
        $monitor("Time: %2t, a: %b, b: %b, with simple: %b, with complex: %b", $time, a, b, simple, complex);
    end

    initial begin
        $dumpfile("hw2.vcd");
        $dumpvars(0, testbench);
    end

endmodule