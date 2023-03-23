module AlphaBranchPredictorTB;
logic clock,reset,BranchTaken,PredictedBranch;
logic [9:0] PC;

real tests,WrongPredict = 0.0;
real PredictPercent;

AlphaBranchPredictor A1(clock,reset,PC,BranchTaken,PredictedBranch);
bind AlphaBranchPredictor Assertions ASRT(clock,reset,PC,BranchTaken,PredictedBranch,A1.G1.LPresult);

always #2 clock=~clock;

class constraints;
	rand bit 	reset;
	rand logic [9:0] PC;
	rand logic BranchTaken;
	int w_PC5bit0_7=60,w_PC5bit8_15=20,w_PC5bit16_23=10,w_PC5bit24_31=10,w_BranchTaken1=80,w_BranchTaken0=20;
	constraint rst{								// Constraint to randomize reset with given weights
		reset dist {1:=1,0:=99};
	}
	constraint PCrepeat4_0{						// Constraint to maintain upper 5 bits of PC constant, and lower 5 bits are randomized as per given weights
		reset == 1'b0;
		PC[9:5] inside {0,31};
		PC[4:0] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint PCrepeat9_5{						// Constraint to maintain lower 5 bits of PC constant, and upper 5 bits are randomized as per given weights
		reset == 1'b0;
		PC[4:0] inside {0,31};
		PC[9:5] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint actualbranch{					// Constraint to randomize Actual Branch Taken as per given weights
		reset == 1'b0;
		BranchTaken dist {1:=w_BranchTaken1,0:=w_BranchTaken0};
	}

endclass
constraints cnstr;

initial begin: weighted_randomization
cnstr = new();
cnstr.rst.constraint_mode(0);
cnstr.PCrepeat9_5.constraint_mode(0);
cnstr.PCrepeat4_0.constraint_mode(1);
cnstr.actualbranch.constraint_mode(1);
cnstr.w_PC5bit0_7 	= 40;
cnstr.w_PC5bit8_15 	= 30;
cnstr.w_PC5bit16_23 = 20;
cnstr.w_PC5bit24_31 = 10;
cnstr.w_BranchTaken1= 90;
cnstr.w_BranchTaken0= 10;
clock=0;
resetalpha(4);
  repeat(1000) begin
RANDOMIZATION_FAILURE:assert(cnstr.randomize());
 updatealpha(cnstr.PC,cnstr.BranchTaken);
end
PredictPercent= ((tests-WrongPredict)/tests)*100;
$display("Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",tests,WrongPredict,PredictPercent);
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
tests+=1;
@(negedge clock);
IdealLocal = ILPT[ILHT[PC]] >= 4 ? 1 : 0;
IdealGlobal = IGP[IPH] >= 2 ? 1 : 0;
IdealChoice = ICP[IPH] >= 2 ? 1 : 0;
IdealBranch = IdealChoice ? IdealGlobal: IdealLocal;
repeat(3) @(negedge clock);
if(IdealBranch!==PredictedBranch) $display("ERROR output = %b expected = %b",PredictedBranch,IdealBranch);

BranchTaken = ab;
@(negedge clock);

if(PredictedBranch!=BranchTaken) WrongPredict+=1;

ig = BranchTaken==IdealGlobal ? 1 : 0;
ip = BranchTaken==IdealLocal ? 1 : 0;
case({ig,ip})
0: ICP[IPH] = ICP[IPH];
1: ICP[IPH] = ICP[IPH]>0 ? ICP[IPH]-1 : ICP[IPH];
	2: ICP[IPH] = ICP[IPH]<3 ? ICP[IPH]+1 :ICP[IPH];
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


