module top_module (
    input a, b, c, d, e,
    output [24:0] out );//
	
    wire [24:0] bus1, bus2;
    assign bus1 = { {5{a}},{5{b}},{5{c}},{5{d}},{5{e}} };
    assign bus2 = { 5{a,b,c,d,e} };
	assign out = bus1 ~^ bus2;
        
endmodule
