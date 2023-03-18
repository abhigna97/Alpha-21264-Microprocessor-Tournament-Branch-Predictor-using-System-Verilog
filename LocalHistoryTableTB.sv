module LocalHistoryTableTB;
logic clock,reset,BranchTaken;
logic [9:0] PC,LHTresult,LHTideal;

LocalHistoryTable DUT(clock,reset,PC,BranchTaken,LHTresult);

logic [2:0] count;

always #5 clock = ~clock;

initial begin
    clock=0;
    resetLHT(4);
    updateLHT(1023,1);
    updateLHT(52,0);
    updateLHT(52,1);
    updateLHT(1023,0);  
    updateLHT(1023,1); 
    updateLHT(1023,1); 
    updateLHT(1023,1); 
    updateLHT(126,1);
    $stop;  
end

task resetLHT(input int t);
    reset = 1'b1;
    BranchTaken	= 1'bx;
    repeat(t) begin
    	LHTideal='b0;
    	@(negedge clock);
    	if(LHTresult !== LHTideal) $display("Reset ERROR, %t",$time);
    	end
endtask

task updateLHT(input logic [9:0] pc, branchtaken);
    reset = 1'b0;
    PC=pc;
    count=0;
    repeat(8) begin
	if(count > 3) BranchTaken = branchtaken;
	else          BranchTaken = 'bx;
	count = count + 1;
        @(negedge clock);
	end
    endtask
endmodule
