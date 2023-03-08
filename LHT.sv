module LHT(clock,reset,BranchTaken,LHresult);

    input logic clock,reset,BranchTaken;
    output logic [9:0] LHresult;
  
    logic [9:0] LocalHistory='b0;
  
    always @ (posedge clock or posedge reset) begin
        if(reset) LocalHistory<='b0;
        else LocalHistory<={BranchTaken,LocalHistory[9:1]};
    end
  
    assign LHresult = LocalHistory;
  
endmodule
