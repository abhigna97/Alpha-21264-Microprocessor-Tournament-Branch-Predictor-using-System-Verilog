
module LHTtb;
  
    logic clock,reset,BranchTaken;
  	logic [9:0] LHresult;
  
  	logic [9:0] LHideal;
  
  	LHT DUT(clock,reset,BranchTaken,LHresult);
  
    initial begin
        clock=0;
      	forever #2; clock=~clock;
    end
  
    task RESETLHT();
        reset=1'b1;
		BranchTaken=1'bx;
      	@ (negedge clock);
      	LHideal='b0;
      	if(LHresult!==LHideal) $display("Reset ERROR");
    endtask
  
  	task update(input logic x);
        reset=1'b0;
    	BranchTaken=x;
   	 	@(negedge clock);
    	LHideal=LHideal>>1 | BranchTaken<<9;
    	if(LHresult!==LHideal) $display("ERROR: %b %b",LHresult,LHideal);
    endtask
  
  	initial begin
        RESETLHT();
    	RESETLHT();
    	RESETLHT();
    	update(0);update(1);update(1);
    	repeat(8) update(0);
    	repeat(4) update(1);
    	RESETLHT();
    	$display("Done");
    	$stop();
    end

endmodule
