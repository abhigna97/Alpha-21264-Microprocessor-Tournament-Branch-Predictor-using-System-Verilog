module LocalPredictorTB;
  
    logic clock,reset,BranchTaken,LPresult,LPideal;
    logic [9:0] LHTresult;
    logic [2:0] count;
  
    LocalPredictor DUT(clock,reset,BranchTaken,LHTresult,LPresult);
  
    always #2 clock = ~clock;

    initial begin
	clock = 1'b0;
        resetLP(4);
	repeat(10) updateLP(1,1);
	repeat(3) updateLP(0,0);
	repeat(2) begin updateLP(1,0);updateLP(0,1);end
	$stop();
    end
  

    task resetLP(input int t);
        reset = 1'b1;
	BranchTaken = 1'bx;
	repeat(t*4) @(negedge clock);
    endtask

    task updateLP(input logic [9:0] x,y);
        reset = 1'b0;LHTresult='bx;
	@(negedge clock); LHTresult = x; @(negedge clock);@(negedge clock);@(negedge clock);BranchTaken = y;@(negedge clock);@(negedge clock);
	@(negedge clock);@(negedge clock);
    endtask


endmodule




    
    
  
  
  
  
