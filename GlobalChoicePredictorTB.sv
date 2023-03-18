module GlobalChoicePredictorTB;
logic clock,reset,BranchTaken,LPresult,GPresult,CPresult;
logic [11:0] PHresult;
logic count;

GlobalChoicePredictor DUT(clock,reset,BranchTaken,LPresult,PHresult,GPresult,CPresult);

always #5 clock = ~clock;

initial begin
    clock=0;
    resetGCHT(4);
    updateGCHT(0,1,1);
    updateGCHT(0,1,1);
    updateGCHT(0,1,1);
    updateGCHT(0,1,1);  
    updateGCHT(0,1,1); 
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0);
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0);

    $stop;  
end

task resetGCHT(input int t);
    reset = 1'b1;
    BranchTaken	= 1'bx;
    repeat(t)@(negedge clock);
endtask

task updateGCHT(input logic [11:0] phresult, input logic branchtaken, lpresult);
    reset = 1'b0;
    PHresult=phresult;
    count=0;
    repeat(2) begin
	if(count > 0) BranchTaken = branchtaken;
	else          BranchTaken = 'bx;
	if(count > 0) LPresult = lpresult;
	else          LPresult = 'bx;
	count = count + 1;
        @(negedge clock);
	end
    endtask
endmodule
