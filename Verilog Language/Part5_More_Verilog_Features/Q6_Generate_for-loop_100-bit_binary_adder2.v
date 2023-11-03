module full_adder(
    input a, b, cin,
    output cout, sum );
	
    assign sum = a^b^cin;
    assign cout = (a&b)|(a&cin)|(b&cin);
        
endmodule

module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
	
    genvar i;
    generate
        for(i=0; i<100; i++)begin : Full_adder_block
            if(i==0)
                full_adder U0(a[0], b[0], cin, cout[0], sum[0]);
            else
                full_adder U1(a[i], b[i], cout[i-1], cout[i], sum[i]);
        end
    endgenerate
endmodule

