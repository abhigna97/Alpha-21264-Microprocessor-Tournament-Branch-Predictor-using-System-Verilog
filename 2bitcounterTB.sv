module global2bitcounterTB;
  
    logic clock,reset,BranchTaken,GPresult,GPideal;
    logic [1:0] count;
  
    Global2BitFSM DUT(clock,reset,BranchTaken,GPresult);
  
    initial begin
        clock=0;
      	forever begin
	      #2; clock=~clock;
      	end
    end

    initial begin
        RESETFSM(4);
        repeat(5) update(1);
	      repeat(5) update(0);
	      repeat(5) update(1);
	      repeat(5) update(0);
	      repeat(2) update(1);
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
	      GPideal=count<=1 ? 0:1;
    	  @(negedge clock);
    	  if(GPresult!==0) $display("Reset ERROR");
	      end
    endtask

    task update(input logic x);
        reset=1'b0;
	      BranchTaken=x;
	      case(BranchTaken)
	          0: count = count==0 ? 0 : count-1;
	          1: count = count==3 ? 3 : count+1;
	      endcase
      	GPideal=count<=1 ? 0:1;
	      @(negedge clock);
	      if(GPideal !== GPresult) $display("ERROR");
    endtask


endmodule
