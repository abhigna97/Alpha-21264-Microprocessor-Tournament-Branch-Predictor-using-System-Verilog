module GlobalDesign(
input logic clock,
input logic reset,
input logic BranchTaken,
input logic LPresult,
output logic GPresult,
output logic CPresult);

logic [11:0] PHresult;

GlobalChoicePredictor DUT1(clock,reset,BranchTaken,LPresult,PHresult,GPresult,CPresult);
PathHistory DUT2(clock,reset,BranchTaken,PHresult);

endmodule
