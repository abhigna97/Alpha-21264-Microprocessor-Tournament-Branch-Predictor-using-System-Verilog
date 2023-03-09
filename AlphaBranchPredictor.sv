module AlphaBranchPredictor(clock,reset,PC,BranchTaken,BranchResult);
    input logic clock,reset,BranchTaken;
    input logic [11:0] PC;
    output logic BranchResult;
  
    logic ChoiceBit,GlobalBit;
    logic LocalBit;
  
    Globaldesign GX(clock,reset,BranchTaken,PredictedBranch,GlobalBit,ChoiceBit);
    Localdesign LX(clock,reset,PC,BranchTaken,LocalBit);
  
    assign BranchResult = ChoiceBit ? GlobalBit : LocalBit;
  
endmodule
