module Assertions(clock,reset,PC,BranchTaken,PredictedBranch,LHTresult);
input 	logic clock,reset,BranchTaken;
input 	logic [9:0] LHTresult;
input 	logic [9:0] PC;
input 	logic PredictedBranch;

property p_PCstable;
	@(negedge clock)	disable iff(reset)	 $changed(PC) |=> {8{PC == $past(PC)}}
endproperty
a_PCstable:assert property(p_PCstable)	else $error("a_PCstable failed");

/* property p_BranchTakenknown;
	@(negedge clock)	disable iff(reset)	
endproperty
a_BranchTakenknown:assert property(p_BranchTakenknown)	else $error("a_BranchTakenknown failed"); */

property p_reset;
	@(negedge clock) reset	|->		$isunknown(PredictedBranch)
endproperty
a_reset:assert property(p_reset)	else $error("a_reset failed");

 property p_lhtresultknown;
	@(posedge clock)	disable iff(reset) $changed(PC) |=> !($isunknown(LHTresult))
endproperty
a_lhtresultknown:assert property(p_lhtresultknown)	else $error("p_lhtresultknown failed");

property p_lptresultknown;
	@(negedge clock)	disable iff(reset) $changed(PC) |=> !($isunknown(LHTresult))
endproperty
a_:assert property(p_)	else $error("a_ failed");

/*property p_;
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
a_:assert property(p_);	else $error("a_ failed"); */

endmodule
