module AlphaBranchPredictorTB;
logic clock,reset,BranchTaken,PredictedBranch;
logic [9:0] PC;

AlphaBranchPredictor A1(clock,reset,PC,BranchTaken,PredictedBranch);

always #5 clock=~clock;

initial begin
clock=0;
resetalpha(4);
repeat(20) updatealpha(0,1);
$stop();
end

task resetalpha(input int x);
reset=1'b1; BranchTaken = 'bx; PC = 'bx;
repeat(8.5*x) @(negedge clock);
endtask

task updatealpha(input logic [9:0] pc,input logic ab);
reset=1'b0; BranchTaken = 'bx; PC = pc;
repeat(4) @(negedge clock);
BranchTaken = ab;
repeat(4) @(negedge clock);
endtask

endmodule


