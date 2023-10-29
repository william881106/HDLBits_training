module top_module ( input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q  );
    
    wire [7:0]U0_out, U1_out, U2_out;
    my_dff8 U0(clk, d,      U0_out);
    my_dff8 U1(clk, U0_out, U1_out);
    my_dff8 U2(clk, U1_out, U2_out);
    assign q = (sel[1])?((sel[0])?U2_out:U1_out):((sel[0])?U0_out:d);
    
endmodule
