module LocalHistoryTable(
input logic clock,
input logic  reset,
input logic [9:0] PC,
input logic BranchTaken,
output logic [9:0] LHTresult);

logic [2:0] count=0;
logic [9:0] LHT [1023:0]= '{default:'0};

always_ff@(posedge clock or posedge reset)
    begin
    if(reset) 
	begin
	LHT <= '{default:'0};
	LHTresult <= 'x;
	end
    else 
	begin
	case(count)
	0: begin
	   LHTresult <= LHT[PC];
	   count <= count + 1;
	   end
	1: count <= count + 1;
	2: count <= count + 1;
	3: count <= count + 1;
	4: count <= count + 1;
	5: begin
	   LHT[PC] <= (BranchTaken) ? {LHT[PC],1'b1} : {LHT[PC],1'b0};
	   count <= count + 1;
	   end
	6: count <= count + 1;
	7: begin
	   count <= 0;
	   LHTresult<='x;
	   end
	endcase
	end
    end
endmodule
