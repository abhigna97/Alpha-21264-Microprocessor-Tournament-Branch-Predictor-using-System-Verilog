module LHT(clock,reset,BranchTaken,LHresult);

    input logic clock,reset,BranchTaken;
    output logic [9:0] LHresult;
  
    logic [9:0] LocalHistory='b0;
  
    always @ (posedge clock or posedge reset) begin
        if(reset) LocalHistory<='b0;
        else LocalHistory<={LocalHistory[8:0],BranchTaken};
    end
  
    assign LHresult = LocalHistory;
  
endmodule
