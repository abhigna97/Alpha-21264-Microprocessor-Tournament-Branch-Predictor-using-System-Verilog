module AlphaBranchPredictorTB;
logic clock,reset,BranchTaken,PredictedBranch;
logic [9:0] PC;

AlphaBranchPredictor A1(clock,reset,PC,BranchTaken,PredictedBranch);
class constraints;
	rand bit 	reset;
	rand logic [9:0] PC;
	rand logic BranchTaken;
	int w_PC5bit0_7=60,w_PC5bit8_15=20,w_PC5bit16_23=10,w_PC5bit24_31=10,w_BranchTaken1=80,w_BranchTaken0=20;
	constraint rst{
		reset dist {1:=1,0:=99};
	}
	constraint PCrepeat4_0{
		reset == 1'b0;
		PC[9:5] inside {0,31};
		PC[4:0] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint PCrepeat9_5{
		reset == 1'b0;
		PC[4:0] inside {0,31};
		PC[9:5] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint actualbranch{
		reset == 1'b0;
		BranchTaken dist {1:=w_BranchTaken1,0:=w_BranchTaken0};
	}
	task set_random_seed(int seed);
		//$randomseed();
	endtask
	function void post_randomize();
	endfunction
	function void post_randomize();
	endfunction
endclass
constraints cnstr;

always #2 clock=~clock;

initial begin
clock=0;
resetalpha(4);
  repeat(20) updatealpha(0,1);
$stop();
end

logic [9:0] ILHT [1023:0]= '{default:'0};
logic [2:0] ILPT [1023:0]= '{default:'0};
  logic [11:0] IPH ='{default:'0};
logic [1:0] IGP [4095:0]= '{default:'0};
logic [1:0] ICP [4095:0]= '{default:'0};
logic IdealBranch,IdealLocal,IdealGlobal,IdealChoice;
logic ig,ip;

task resetalpha(input int x);
reset=1'b1; BranchTaken = 'bx; PC = 'bx;
repeat(8.5*x) @(negedge clock);
endtask

task updatealpha(input logic [9:0] pc,input logic ab);
reset=1'b0; BranchTaken = 'bx; PC = pc;
@(negedge clock);
IdealLocal = ILPT[ILHT[PC]] >= 4 ? 1 : 0;
IdealGlobal = IGP[IPH] >= 2 ? 1 : 0;
IdealChoice = ICP[IPH] >= 2 ? 1 : 0;
IdealBranch = IdealChoice ? IdealGlobal: IdealLocal;
repeat(3) @(negedge clock);
if(IdealBranch!==PredictedBranch) $display("ERROR output = %b expected = %b",PredictedBranch,IdealBranch);

BranchTaken = ab;
@(negedge clock);

ig = BranchTaken==IdealGlobal ? 1 : 0;
ip = BranchTaken==IdealLocal ? 1 : 0;
case({ig,ip})
0: ICP[IPH] = ICP[IPH];
1: ICP[IPH] = ICP[IPH]>0 ? ICP[IPH]-1 : ICP[IPH];
2: ICP[IPH] = ICP[IPH]<7 ? ICP[IPH]+1 :ICP[IPH];
3: ICP[IPH] = ICP[IPH];
endcase

if(BranchTaken) begin
ILPT[ILHT[PC]] = ILPT[ILHT[PC]] < 7 ?  ILPT[ILHT[PC]]+1 : 7;
ILHT[PC]=ILHT[PC]<<1 | 1'b1;
IGP[IPH] = IGP[IPH] < 3 ? IGP[IPH]+1 : 3;
IPH=IPH>>1 | 12'h800;
end
else begin
ILPT[ILHT[PC]] = ILPT[ILHT[PC]] > 0 ?  ILPT[ILHT[PC]]-1 : 0;
ILHT[PC]=ILHT[PC]<<1;
IGP[IPH] = IGP[IPH] > 0 ? IGP[IPH]-1 : 0;
IPH=IPH>>1;
end

repeat(3) @(negedge clock);
endtask

endmodule

