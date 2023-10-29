module top_module( 
    input [7:0] in,
    output [7:0] out
);
    integer i;
    always@ (*)begin
        for(i=0;i<=7;i++)begin
            out[i] = in[7-i]; // 特別注意 for-loop 不能 assign
        end
    end

endmodule
