module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] hi_0_out, hi_1_out;
	wire select_bit;
    
    add16   adder_lo( a[15:0],  b[15:0],  1'b0, sum[15:0], select_bit );
    add16 adder_hi_0( a[31:16], b[31:16], 1'b0, hi_0_out, );
    add16 adder_hi_1( a[31:16], b[31:16], 1'b1, hi_1_out, );
    assign sum[31:16] = (select_bit)?hi_1_out:hi_0_out;
    
endmodule
