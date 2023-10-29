module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire cout0;
    wire [31:0] b_select;
    
    assign b_select = {32{sub}}^b;
    
    add16 adder0( a[15:0],  b_select[15:0],  sub,   sum[15:0], cout0 );
    add16 adder1( a[31:16], b_select[31:16], cout0, sum[31:16], );

endmodule
