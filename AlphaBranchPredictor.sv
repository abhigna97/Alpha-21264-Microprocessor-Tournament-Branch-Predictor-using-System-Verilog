module AlphaBranchPredictor(clock,reset,PC,BranchTaken,PredictedBranch);

input logic clock,reset,BranchTaken;
input logic [9:0] PC;
output logic PredictedBranch;

logic CP,LP,GP,SlowClock;

ClockDivider C1(clock,SlowClock);
GlobalDesign G1(SlowClock,reset,BranchTaken,LP,GP,CP);
LocalDesign L1(clock,reset,PC,BranchTaken,LP);

assign PredictedBranch = CP ? GP : LP;

endmodule


