module GlobalDesignTB;
  
    logic clock,reset,BranchTaken,PredictedBranch;
    logic Globalbit,Choicebit;
  
    initial begin
        clock=0;
        forever begin #2; clock=~clock; end
    end
  
    Globaldesign g1(clock,reset,BranchTaken,PredictedBranch,Globalbit,Choicebit);
  
    initial begin
        resetfsm;

        branchload('bx,1);
        repeat(4) begin
            branchload(1,1);branchload(1,1);branchload(1,1);branchload(1,1); end

    $stop();
    end 
  
    task resetfsm;
        reset=1'b1;
        @(negedge clock);
   // $display("%b %b",g1.GlobalPredict[g1.PathHistory],g1.ChoicePredict[g1.PathHistory]);
    endtask
  
    task branchload(input logic x,y);
        BranchTaken=x; PredictedBranch=y;
        reset=1'b0;
        @(negedge clock);
     // $display("%b",g1.NewPathHistory);
    endtask
/*  
  task branchload(input logic x);
    BranchTaken=x;
    @(negedge clock);
    $display("%b %b",g1.GlobalPredict[g1.PathHistory],g1.ChoicePredict[g1.PathHistory]);
  endtask
  */
  
endmodule
    
