module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire cout0;
    add16 adder0( a[15:0], b[15:0], 1'b0, sum[15:0], cout0 );
    add16 adder1( a[31:16], b[31:16], cout0, sum[31:16], );

endmodule

module add1 ( input a, input b, input cin,   output sum, output cout );
	assign sum = a^b^cin;
    assign cout = (a&b) | cin&(b|a);
    // cout = (a&b)|(b&cin)|(a&cin);
    //      = (a&b)| cin(b+a); 分配律
endmodule
