// synthesis verilog_input_version verilog_2001
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );
	
    always @(*)begin
        case(in)
            4'd1 : pos = 0; //0001
            4'd2 : pos = 1; //0010
            4'd3 : pos = 0; //0011
            4'd4 : pos = 2; //0100
            4'd5 : pos = 0; //0101
            4'd6 : pos = 1; //0110
            4'd7 : pos = 0; //0111
            4'd8 : pos = 3; //1000
            4'd9 : pos = 0; //1001
            4'd10: pos = 1; //1010
            4'd11: pos = 0; //1011
            4'd12: pos = 2; //1100
            4'd13: pos = 0; //1101
            4'd14: pos = 1; //1110
            4'd15: pos = 0; //1111
            default: pos = 0;
        endcase
    end
endmodule
