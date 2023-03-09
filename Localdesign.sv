module Localdesign(clock,reset,PC,BranchTaken,BranchResult);
  
    input logic clock,reset,BranchTaken;
    input logic [9:0] PC;
    output logic BranchResult;
  
    logic [9:0] LHT [1023:0];
    logic [2:0] LPT [1023:0];

    logic [9:0] LHTresult,LHTprev,PCprev;
    logic [2:0] LPTresult;

    always_ff @(posedge clock or posedge reset) begin
 
        if(reset) begin
      	    foreach(LHT[i]) LHT[i]='b0; 
	    foreach(LPT[i]) LPT[i]='b0;
        end
        else begin
      	    LHTresult<=LHT[PC];
      	    LPTresult<=LPT[LHTresult];
            LHT[PCprev] <= {LHT[PCprev][8:0],BranchTaken};
            LPT[LHTprev] <= {LPT[LHTprev][1:0],BranchTaken};
            PCprev<=PC;
	    LHTprev<=LHTresult;
        end
    end
  
endmodule
