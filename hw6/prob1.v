// ECE 2372
// Andres Antillon
// Homework 6 Problem 1

// Part a)
module gate_8_1_MUX(
    output f,
    input [2:0] S,
    input [7:0] I
);

    wire wAnd1, wAnd2, wAnd3, wAnd4, wAnd5, wAnd6, wAnd7, wAnd8;

    and and1(wAnd1, ~S[2], ~S[1], ~S[0], I[0]);
    and and2(wAnd2, ~S[2], ~S[1],  S[0], I[1]);
    and and3(wAnd3, ~S[2],  S[1], ~S[0], I[2]);
    and and4(wAnd4, ~S[2],  S[1],  S[0], I[3]);
    and and5(wAnd5,  S[2], ~S[1], ~S[0], I[4]);
    and and6(wAnd6,  S[2], ~S[1],  S[0], I[5]);
    and and7(wAnd7,  S[2],  S[1], ~S[0], I[6]);
    and and8(wAnd8,  S[2],  S[1],  S[0], I[7]);

    wire wOr;

    or or1(wOr, wAnd1, wAnd2, wAnd3, wAnd4, wAnd5, wAnd6, wAnd7, wAnd8);

    assign f = wOr;
    
endmodule


// Part b)
module a2_1_MUX(
    output f,
    input I0, I1, S
);

    wire wAnd1, wAnd2, wOr;

    and and1(wAnd1, ~S, I0);
    and and2(wAnd2, S, I1);
    or or1(wOr, wAnd1, wAnd2);

    assign f = wOr;

endmodule

module a2_1_8_1_MUX(
    output f,
    input [2:0] S,
    input [7:0] I
);

    wire wMux1, wMux2, wMux3, wMux4;

    a2_1_MUX mux1(wMux1, I[6], I[7], S[0]);
    a2_1_MUX mux2(wMux2, I[4], I[5], S[0]);
    a2_1_MUX mux3(wMux3, I[2], I[3], S[0]);
    a2_1_MUX mux4(wMux4, I[0], I[1], S[0]);

    wire wMux5, wMux6;

    a2_1_MUX mux5(wMux5, wMux2, wMux1, S[1]);
    a2_1_MUX mux6(wMux6, wMux4, wMux3, S[1]);

    wire wMux7;

    a2_1_MUX mux7(wMux7, wMux6, wMux5, S[2]);

    assign f = wMux7;
    
endmodule


//Part c)
module tri_buff(
    output f,
    input a, sel
);

    assign f = sel ? a : 1'bz;

endmodule

// 8 to 1 MUX using only tri state buffers
module tri_buff_8_1_MUX(
    output f,
    input [2:0] S,
    input [7:0] I
);
    wire [7:0] tri_out;
    wire enable0, enable1, enable3, enable4, enable5, enable6, enable7;

    assign enable0 = ~S[2] & ~S[1] & ~S[0];
    assign enable1 = ~S[2] & ~S[1] &  S[0];
    assign enable2 = ~S[2] &  S[1] & ~S[0];
    assign enable3 = ~S[2] &  S[1] &  S[0];
    assign enable4 =  S[2] & ~S[1] & ~S[0];
    assign enable5 =  S[2] & ~S[1] &  S[0];
    assign enable6 =  S[2] &  S[1] & ~S[0];
    assign enable7 =  S[2] &  S[1] &  S[0];

    tri_buff tb1(tri_out[0], I[0], enable0);
    tri_buff tb2(tri_out[1], I[1], enable1);
    tri_buff tb3(tri_out[2], I[2], enable2);
    tri_buff tb4(tri_out[3], I[3], enable3);
    tri_buff tb5(tri_out[4], I[4], enable4);
    tri_buff tb6(tri_out[5], I[5], enable5);
    tri_buff tb7(tri_out[6], I[6], enable6);
    tri_buff tb8(tri_out[7], I[7], enable7);

    // Combine all outputs
    assign f = tri_out[0];
    assign f = tri_out[1];
    assign f = tri_out[2];
    assign f = tri_out[3];
    assign f = tri_out[4];
    assign f = tri_out[5];
    assign f = tri_out[6];
    assign f = tri_out[7];

endmodule
    
    


module testbench;

    // Using bus instead, for ease of testing
    reg [7:0] I;
    reg [2:0] S;
    wire gate_Z, a2_1_Z, tri_buff_Z;

    integer i;

    gate_8_1_MUX gate_mux(gate_Z, S, I); 
    a2_1_8_1_MUX mux_mux(a2_1_Z, S, I);
    tri_buff_8_1_MUX tri_buff_mux(tri_buff_Z, S, I);

    /* Stimulus waveform */
    initial begin
        
        for (i = 0; i < 16; i=i+1) begin
            I = 8'b11000110;
            #20;
            I = 8'b01101110;
            #20;
            I = 8'b10110010;
            #20;
            I = 8'b00011110;
            #20;
            I = 8'b11100110;
            #20;
            I = 8'b01101010;
            #20;
        end
    end

    initial begin
        S = 3'b000;
        #120 S = 3'b001;
        #120 S = 3'b010;
        #120 S = 3'b011;
        #120 S = 3'b100;
        #120 S = 3'b101;
        #120 S = 3'b110;
        #120 S = 3'b111;
    end

    initial begin
        $dumpfile("prob1.vcd");
        $dumpvars(0, testbench);     
    end

endmodule
