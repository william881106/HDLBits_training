module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );
	
    wire p2a_p2b, p2c_p2d;
	assign p2a_p2b = p2a & p2b;
    assign p2c_p2d = p2c & p2d;
    assign p2y = p2a_p2b || p2c_p2d;
    
    wire p1a_p1b_p1c, p1d_p1e_p1f;
	assign p1a_p1b_p1c = p1a & p1b & p1c;
    assign p1d_p1e_p1f = p1d & p1e & p1f;
    assign p1y = p1a_p1b_p1c || p1d_p1e_p1f;
    
endmodule
