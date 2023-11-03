module top_module (
    input [7:0] a, b, c, d,
    output [7:0] min);//
	
    wire [7:0] min_a_b, min_c_d;
    assign min_a_b = (a < b)?a:b;
    assign min_c_d = (c < d)?c:d;
    assign min = (min_a_b < min_c_d)?min_a_b:min_c_d;

endmodule
