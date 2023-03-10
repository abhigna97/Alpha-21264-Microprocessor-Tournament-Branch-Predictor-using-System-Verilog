module Localdesign(clock,reset,PC,BranchTaken,BranchResult);
  
    input logic clock,reset,BranchTaken;
    input logic [9:0] PC;
    output logic BranchResult;
  
    logic [9:0] LHT [1023:0];
    logic [2:0] LPT [1023:0];

    logic [9:0] LHTresult,LHTprev,PCprev,PC2prev;
    logic [2:0] LPTresult;

    always_ff @(posedge clock or posedge reset) begin
 
        if(reset) begin
      	    foreach(LHT[i]) LHT[i]='b0; 
	    foreach(LPT[i]) LPT[i]='b0;
        end
        else begin
            if(PCprev==PC && !$isunknown(PCprev)) LHTresult<={LHT[PC][8:0],BranchTaken};
            else LHTresult<=LHT[PC];

	    if(LHTprev==LHTresult && !$isunknown(LHTresult)) LPTresult<={LPT[LHTresult][1:0],BranchTaken};
	    else LPTresult<=LPT[LHTresult];

	    if(!$isunknown(BranchTaken)) begin
                LPT[LHTprev] <= {LPT[LHTprev][1:0],BranchTaken};
                LHT[PC2prev] <= {LHT[PC2prev][8:0],BranchTaken}; end
            end
        end

    always_ff @(posedge clock or posedge reset) begin
	PCprev<=PC;
    	PC2prev<=PCprev;
	LHTprev<=LHTresult; 
    end

    assign BranchResult = LPTresult>3? 1:0;

  
endmodule
