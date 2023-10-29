module top_module( input in, output out );
	//not not1(out, in); //Gate Level
	assign out = ~in; //Dataflow Level
endmodule