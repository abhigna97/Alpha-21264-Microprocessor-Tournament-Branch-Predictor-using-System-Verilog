module GlobalDesignTB;
    logic clock,reset,BranchTaken,LPresult,GPresult,CPresult;

    GlobalDesign DUT(clock,reset,BranchTaken,LPresult,GPresult,CPresult);

    always #2 clock = ~clock;

    initial begin
	clock=0;
	resetGlobal(4);
	repeat(20) updateGlobal(1,1);
	repeat(20) updateGlobal(0,1);
	repeat(20) updateGlobal(1,1);
	repeat(20) updateGlobal(0,1);
	$stop();
    end

    task resetGlobal(input int x);
	reset=1;BranchTaken='bx;
	repeat(x) @(negedge clock);
    endtask

    task updateGlobal(input logic bt,lpresult);
	reset=0;BranchTaken='bx;
        @(negedge clock);
	LPresult = lpresult;
        BranchTaken = bt;
	@(negedge clock);
    endtask

endmodule
