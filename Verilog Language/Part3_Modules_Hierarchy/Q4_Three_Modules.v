module top_module ( input clk, input d, output q );
    wire U0_out, U1_out;
    my_dff U0(clk, d,      U0_out);
    my_dff U1(clk, U0_out, U1_out);
    my_dff U2(clk, U1_out, q);
endmodule
