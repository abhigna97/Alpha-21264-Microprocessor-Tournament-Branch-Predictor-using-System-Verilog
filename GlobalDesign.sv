module GlobalDesign(
input logic clock,
input logic reset,
input logic BranchTaken,
input logic LPresult,
output logic GPresult,
output logic CPresult);

logic [11:0] PHresult;

GlobalChoicePredictor GCP(clock,reset,BranchTaken,LPresult,PHresult,GPresult,CPresult);
PathHistory PH(clock,reset,BranchTaken,PHresult);

endmodule
