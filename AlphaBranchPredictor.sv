module AlphaBranchPredictor(clock,reset,PC,BranchTaken,PredictedBranch);

input logic clock,reset,BranchTaken;
input logic [9:0] PC;
output logic PredictedBranch;

logic CP,LP,GP,SlowClock;

ClockDivider CD(clock,SlowClock);
GlobalDesign GD(SlowClock,reset,BranchTaken,LP,GP,CP);
LocalDesign LD(clock,reset,PC,BranchTaken,LP);

assign PredictedBranch = CP ? GP : LP;

endmodule
