module LocalDesign(
input logic clock,
input logic reset,
input logic [9:0] PC,
input logic BranchTaken,
output logic LDresult);

logic [9:0] LHTresult;

LocalHistoryTable DUT1(clock,reset,PC,BranchTaken,LHTresult);
LocalPredictor DUT2(clock,reset,BranchTaken,LHTresult,LDresult);

endmodule
