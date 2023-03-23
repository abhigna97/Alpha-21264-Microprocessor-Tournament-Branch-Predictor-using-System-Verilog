module Assertions(clock,slowclock,reset,PC,BranchTaken,PredictedBranch,LHTresult,LPresult,GPresult,CPresult,PHresult);
input 	logic clock,slowclock,reset,BranchTaken,LPresult,GPresult,CPresult;
input 	logic [9:0] LHTresult;
input 	logic [11:0] PHresult;
input 	logic [9:0] PC;
input 	logic PredictedBranch;

// 	PC should be stable for at least 8 clock cycles after applying anew
property p_PCstable;
	@(negedge clock)	disable iff(reset)	 $changed(PC) |=> {8{PC == $past(PC)}}
endproperty
a_PCstable:assert property(p_PCstable)	else $error("a_PCstable failed");

//	When Reset is asserted, PredictedBranch is unknown
property p_reset;
	@(negedge clock) reset	|->		$isunknown(PredictedBranch)
endproperty
a_reset:assert property(p_reset)	else $error("a_reset failed");

//	LHT result is known 1 clock cyle after applying new PC
property p_lhtresultknown;
	@(posedge clock)	disable iff(reset) $changed(PC) |=> !($isunknown(LHTresult))
endproperty
a_lhtresultknown:assert property(p_lhtresultknown)	else $error("p_lhtresultknown failed");

// 	LP result is known 2 clock cycles after applying new PC
property p_lptresultknown;
	@(posedge clock)	disable iff(reset) $changed(PC) |=> ##1 !($isunknown(LPresult))
endproperty
a_lptresultknown:assert property(p_lptresultknown)	else $error("a_lptresultknown failed");

// 	GP,CP results are uknown for 2 clock cycles after applying new PC, and are known for the next 2 cycles
property p_gpcpknown;
	@(negedge clock)	disable iff(reset) $changed(PC) |=> ($isunknown({GPresult,CPresult})) |=> ##2 !($isunknown({GPresult,CPresult}))
endproperty
a_gpcpknown:assert property(p_gpcpknown)	else $error("a_gpcpknown failed");

// 	PH should be stable for atleast 2 clock cycles after a change
property p_PHstable;
	@(posedge clock)	disable iff(reset) $changed(PHresult)|=> {2{PHresult == $past(PHresult)}}
endproperty
a_PHstable:assert property(p_PHstable)	else $error("a_PHstable failed");

// slowclock would remain low for 2 clock cycles upon negedge of the clock (clock divide by 4)
property p_slowclk;
	@(negedge clock)	disable iff(reset) $fell(slowclock) |=> ##1 $rose(slowclock)
endproperty
a_slowclk:assert property(p_slowclk)	else $error("a_slowclk failed");

// PredictedBranch is known after 2 clock cyles of applying a new PC
property p_predictedknown;
	@(negedge clock)	disable iff(reset) $changed(PC) |=> ##1 !($isunknown(PredictedBranch))
endproperty
a_predictedknown:assert property(p_predictedknown)	else $error("a_predictedknown failed");

endmodule
