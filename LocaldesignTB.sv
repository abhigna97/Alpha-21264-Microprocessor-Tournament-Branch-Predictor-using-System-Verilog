module LocaldesignTB;
  
    logic clock,reset,BranchTaken;
    logic [9:0] PC;
    logic BranchResult;
  
    initial begin
        clock=0;
        forever begin #2; clock=~clock; end
    end
  
    Localdesign a1(clock,reset,PC,BranchTaken,BranchResult);
  
    initial begin
        resetfsm;
        //pcload(30);
	branchload(30,'bx);
        branchload(10,'bx);
        branchload(20,1);
        branchload(30,1);
        branchload(10,1);
        branchload(20,1);
        branchload(30,1);
        branchload(10,1);
        branchload(10,1);
        branchload(10,1);
        branchload(40,1);
        branchload(50,1);
        branchload(60,1);
        resetfsm;
	branchload(30,'bx);
        branchload(10,'bx);
        branchload(20,1);
        branchload(30,1);
        branchload(10,1);
        branchload(20,1);
        branchload(30,1);
        branchload(10,1);
        branchload(10,1);
        branchload(10,1);
        branchload(40,1);
        branchload(50,1);
        branchload(60,1);
       $stop();
    end 
  
    task resetfsm;
        reset=1'b1;
        @(negedge clock);
   // $display("%b %d",a1.LHT[20],a1.PCprev);
    endtask
  
    task pcload(input logic [9:0] x);
        PC=x;
        reset=1'b0;
        @(negedge clock);
  //  $display("%b %d",a1.LHT[PC],a1.PCprev);
    endtask
  
    task branchload(input logic [9:0] y,input logic x);
        BranchTaken=x; reset=1'b0;
        PC=y;
        @(negedge clock);
     // $display("%b %b",a1.LHT[a1.PCprev],a1.LHT[PC]);
  //  $display("%b ",a1.LHTresult);
  //  $display("%b %b %b",a1.LPTresult[a1.LHTresult],a1.LPTresult,a1.PCprev);
    endtask
  
  
endmodule
    
