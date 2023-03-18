module LocalDesignTB;
  
    logic clock,reset,BranchTaken,LDresult;
    logic [2:0] count;
    logic [9:0] PC;

    //LHT DUT1(clock,reset,PC,BranchTaken,LHTresult);
  
    LocalDesign DUT(clock,reset,PC,BranchTaken,LDresult);
  
    always #2 clock = ~clock;

    initial begin
	clock = 1'b0;
        resetlocal(4);
for(int i=0;i<11;i++) updatelocal(i,1);
for(int i=0;i<11;i++) updatelocal(i,1);
	$stop();
    end
  

    task resetlocal(input int t);
        reset = 1'b1;
	BranchTaken = 1'bx;PC= 'bx;
	repeat(t*4) @(negedge clock);
    endtask

task updatelocal(input logic [9:0] pc, branchtaken);
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
