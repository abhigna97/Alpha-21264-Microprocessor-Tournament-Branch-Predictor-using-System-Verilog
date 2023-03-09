module Globaldesign(clock,reset,BranchTaken,PredictedBranch,GlobalBit,ChoiceBit);
  
    input logic clock,reset,BranchTaken,PredictedBranch;
    output logic GlobalBit,ChoiceBit;

    logic [1:0] BranchResult,ChoiceResult;
  
    logic [11:0] PathHistory='b0;
    logic [11:0] NewPathHistory;
    logic [1:0] GlobalPredict [4095:0];
    logic [1:0] ChoicePredict [4095:0];

    always_ff @(posedge clock or posedge reset) begin
 
        if(reset) begin
            foreach(GlobalPredict[i]) GlobalPredict[i]<='b0; 
            foreach(ChoicePredict[i]) ChoicePredict[i]<='b0;
            PathHistory<='b0;
        end
        else begin
            BranchResult<=GlobalPredict[PathHistory];
            ChoiceResult<=ChoicePredict[PathHistory];
            if(BranchTaken==1 || BranchTaken==0 ) begin 
                GlobalPredict[NewPathHistory]<={GlobalPredict[NewPathHistory][0],BranchTaken};
                ChoicePredict[NewPathHistory]<={ChoicePredict[NewPathHistory][0],BranchTaken};	end
            PathHistory<={PathHistory[10:0],PredictedBranch};
            NewPathHistory<=PathHistory;
        end
    end

    assign GlobalBit = BranchResult>=2 ? 1:0;
    assign ChoiceBit = ChoiceResult>=2 ? 1:0;


  
endmodule
