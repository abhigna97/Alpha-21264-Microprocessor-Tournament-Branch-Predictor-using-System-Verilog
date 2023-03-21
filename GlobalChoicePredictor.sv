module GlobalChoicePredictor(
input logic clock,
input logic reset,
input logic BranchTaken,
input logic LPresult,
input logic [11:0] PHresult,
output logic GPresult,
output logic CPresult);

logic [2:0] GPR,CPR;
bit gp,lp;
assign GPresult = GPR > 1 ? 1 : 0;
assign CPresult = CPR > 1 ? 1 : 0;
assign gp = GPresult==BranchTaken ? 1 : 0;
assign lp = LPresult==BranchTaken ? 1 : 0;
logic count=0;

logic [1:0] GP [4095:0]= '{default:'0};
logic [1:0] CP [4095:0]= '{default:'0};

always_ff@(posedge clock or posedge reset)
    begin
    if(reset) 
	begin
	CP <= '{default:'0};
	GP <= '{default:'0};
	GPR <= 'x;
	CPR <= 'x;
	count<=0;
	end
    else
	begin
	case(count)
	0: begin
	   GPR <= GP[PHresult];
	   CPR <= CP[PHresult];
	   count <= 1;
	   end
	1: begin
	   if(BranchTaken)  GP[PHresult] <= GPR < 3 ? GPR + 1'b1 : GPR;
	   else             GP[PHresult] <= GPR > 0 ? GPR - 1'b1 : GPR;

           if(gp&lp || !gp&!lp) CP[PHresult] <= CPR;
	   else if(!gp&lp)      CP[PHresult] <= CPR==0 ? CPR : CPR-1;
	   else if(gp&!lp)      CP[PHresult] <= CPR==3 ? CPR : CPR+1;

	   CPR <= 'bx;
	   GPR <= 'bx;
	   count <= 0;
	   end
	endcase
	end
    end

endmodule
