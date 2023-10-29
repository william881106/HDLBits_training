module top_module( 
    input a, 
    input b, 
    output out );
    //and and1(out, a, b); //gate level
	assign out = a&b; //dataflow level
endmodule
