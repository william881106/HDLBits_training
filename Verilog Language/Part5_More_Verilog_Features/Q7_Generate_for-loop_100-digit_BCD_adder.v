module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
	
    wire [99:0] _cout;
    
   	genvar i;
    generate
        for(i=0; i<100; i++)begin:BCDblock
            if(i == 0)
                bcd_fadd U0(a[3:0], b[3:0], cin, _cout[0], sum[3:0] );
        	else
                bcd_fadd U1(a[4*i+3:4*i], b[4*i+3:4*i], _cout[i-1], _cout[i], sum[4*i+3:4*i] );
        end
        
    endgenerate
    assign cout = _cout[99];
endmodule
