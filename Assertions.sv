module Assertions(clock,slowclock,reset,PC,BranchTaken,PredictedBranch,LHTresult,LPresult,GPresult,CPresult,PHresult);
input 	logic clock,slowclock,reset,BranchTaken,LPresult,GPresult,CPresult;
input 	logic [9:0] LHTresult;
input 	logic [11:0] PHresult;
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
	@(posedge clock)	disable iff(reset) $changed(PC) |=> ##1 !($isunknown(LPresult))
endproperty
a_lptresultknown:assert property(p_lptresultknown)	else $error("a_lptresultknown failed");

property p_gpcpknown;
	@(negedge clock)	disable iff(reset) $changed(PC) |=> ($isunknown({GPresult,CPresult,PHresult}))[*2] |-> !($isunknown({GPresult,CPresult,PHresult}))
endproperty
a_gpcpknown:assert property(p_gpcpknown)	else $error("a_gpcpknown failed");

property p_PHstable;
	@(posedge clock)	disable iff(reset) $changed(PHresult)|=> {2{PHresult == $past(PHresult)}}
endproperty
a_PHstable:assert property(p_PHstable)	else $error("a_PHstable failed");

property p_slowclk;
	@(negedge clock)	disable iff(reset) $fell(slowclock) |=> ##1 $rose(slowclock)
endproperty
a_slowclk:assert property(p_slowclk)	else $error("a_slowclk failed");

property p_predictedknown;
	@(negedge clock)	disable iff(reset) $changed(PC) |=> ##1 !($isunknown(PredictedBranch))
endproperty
a_predictedknown:assert property(p_predictedknown)	else $error("a_predictedknown failed");

endmodule
