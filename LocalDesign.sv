module LocalDesign(
input logic clock,
input logic reset,
input logic [9:0] PC,
input logic BranchTaken,
output logic LDresult);

logic [9:0] LHTresult;

LocalHistoryTable LHT(clock,reset,PC,BranchTaken,LHTresult);
LocalPredictor LPT(clock,reset,BranchTaken,LHTresult,LDresult);

endmodule
