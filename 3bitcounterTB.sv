module local3bitcounterTB;
  
    logic clock,reset,BranchTaken,LPresult,LPideal;
    logic [2:0] count;
  
    Local3BitFSM DUT(clock,reset,BranchTaken,LPresult);
  
    initial begin
        clock=0;
      	forever begin
	    #2; clock=~clock;
      	end
    end

    initial begin
        RESETFSM(4);
        repeat(10) update(1);
	repeat(10) update(0);
	repeat(5) update(1);
	update(0); update(1);update(0);
	update(1);update(0);update(1);update(0);
	RESETFSM(3);
	update(1);
	$stop(); 
	end
  

    task RESETFSM(input int t);
        reset=1'b1;
	BranchTaken=1'bx;
	count=0;
  	repeat(t) begin
	    LPideal=count<=3 ? 0:1;
    	    @(negedge clock);
    	    if(LPresult!==0) $display("Reset ERROR");
	end
    endtask

    task update(input logic x);
        reset=1'b0;
	BranchTaken=x;
	case(BranchTaken)
	    0: count = count==0 ? 0 : count-1;
	    1: count = count==7 ? 7 : count+1;
	endcase
	LPideal=count<=3 ? 0:1;
	@(negedge clock);
	if(LPideal !== LPresult) $display("ERROR");
    endtask


endmodule




    
    
  
  
  
  
