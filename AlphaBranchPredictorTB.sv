module AlphaBranchPredictorTB;
logic clock,reset,BranchTaken,PredictedBranch;
logic [9:0] PC;

AlphaBranchPredictor A1(clock,reset,PC,BranchTaken,PredictedBranch);

always #2 clock=~clock;

initial begin
clock=0;
resetalpha(4);
  repeat(20) updatealpha(0,1);
$stop();
end

logic [9:0] ILHT [1023:0]= '{default:'0};
logic [2:0] ILPT [1023:0]= '{default:'0};
logic [11:0] IPH;
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
if(IdealBranch!==PredictedBranch) $display("ERROR");

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

