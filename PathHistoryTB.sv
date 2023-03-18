module PathHistoryTB;
    logic clock,reset,Prediction;                 
    logic [11:0] PHresult;
    logic [11:0] idealPH;

    PathHistory DUT(clock,reset,Prediction,PHresult);

    always #2 clock = ~clock;

    initial begin
	clock = 1'b0;
        resetPATH(3);
        repeat(15) push(1); 
        repeat(15) push(0);
	repeat(4)  push(1); 
        repeat(15) begin push(1);push(0); end
        resetPATH(3); 
        $stop(); 
    end

    task resetPATH(input int t);
        reset = 1'b1;
	Prediction = 1'bx;
        repeat(t) @(negedge clock);
    endtask

    task push(input logic x);
        reset = 1'b0;
        @(negedge clock);
        Prediction = x;
	@(negedge clock);
    endtask

endmodule
