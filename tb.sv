module BranchPredictorTB;
    logic clock=1;
    logic reset,BranchTaken,Prediction,idealPrediction;
    logic [9:0] PC;
    logic [9:0] PCValue;
    logic ActualOutcome;
    int InstructionCount;
    string Type;
    string line;
    int i=5;

    BranchPredictor DUT(clock,reset,BranchTaken,PC,Prediction);

    always #4 clock = ~clock;

    initial begin
		int fileobj;

		RESET(3);
		
		fileobj = $fopen("trace.txt","r");

		if(fileobj) $display("File Opened Successfully");
		else $display("File Opening Failed!");
		
		while(!$feof(fileobj)) begin
		$fscanf(fileobj, "%0d : %0h : %0s : %0d", InstructionCount, PCValue, Type, ActualOutcome);
		//$display("File: %0d : %0h : %0s : %0d", InstructionCount, PCValue, Type, ActualOutcome);
		CheckPC(PCValue);
		@(negedge DUT.clockby2);
		PC=PCValue;
		@(negedge DUT.clockby2);
		BRANCH(ActualOutcome);
		end
		
		$fclose(fileobj);
		
		RESET(3);
		
    	$stop;
end

    task RESET(input int t);
        reset=1'b1;
	BranchTaken=1'bx;
        repeat(t) begin
	    idealPrediction<=0;
  	    @(negedge clock);
            if(idealPrediction!==Prediction)  $display("reset ERROR");
        end
    endtask

    task CheckPC(input logic [9:0] pc);
        reset=1'b1;
	BranchTaken=1'bx;
	if(pc%4 != 0) $display("Unaligned PC!");
	else $display("Valid PC");
    endtask

    task BRANCH(input logic branchtaken);
        reset=1'b0;
	BranchTaken=branchtaken;
    endtask


/*
    task BRANCH(input logic [9:0] pc, input logic branchtaken);
        reset=1'b0;
		BranchTaken=branchtaken;
		PC=pc;
		@(negedge clock);
    endtask
*/
endmodule