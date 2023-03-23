module Assertions(clock,reset,PC,BranchTaken,PredictedBranch);
input 	logic clock,reset,BranchTaken;
input 	logic [9:0] PC;
input 	logic PredictedBranch;

property p_;
	@(negedge clk)	disable iff(reset)	 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

property p_;
	@(negedge clk)	disable iff(reset) 
endproperty
a_:assert property(p_);	else $error("a_ failed");

endmodule
