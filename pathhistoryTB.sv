module PathHistoryTB;
  logic        clock;
  logic        reset;
  logic        BranchTaken;                  // outcome
  logic [11:0] PHistory;
  logic [11:0] idealPHistory;

    PathHistory DUT(clock,reset,BranchTaken,PHistory);

    initial begin
        clock=0;
      	forever begin
	    #2; clock=~clock;
      	end
    end

    initial begin
        RESETPATH(3);
        repeat(6) push(1); 
        repeat(5) push(0);
        repeat(7) push(0);
        repeat(12) push(1);
        RESETPATH(3); 
        $stop; 
    end

    task RESETPATH(input int t);
        reset=1'b1;
	BranchTaken=1'bx;
        repeat(t) begin
	    idealPHistory<='0;
  	    @(negedge clock);
            if(idealPHistory!==PHistory)  $display("reset ERROR");
        end
    endtask

    task push(input logic x);
        reset=1'b0;
        BranchTaken=x;
	idealPHistory<={idealPHistory[10:0],x};
        @(negedge clock);
        if(idealPHistory!==PHistory)  $display("ERROR");
    endtask

endmodule
