`default_nettype none
module top_module(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n   ); 
	
    wire a_and_b;
    wire c_and_d;
    wire out_or;
    
    assign a_and_b = a & b;
    assign c_and_d = c & d;
    assign out_or = a_and_b || c_and_d;
    assign out = out_or;
    assign out_n = ~out_or;
        
endmodule
