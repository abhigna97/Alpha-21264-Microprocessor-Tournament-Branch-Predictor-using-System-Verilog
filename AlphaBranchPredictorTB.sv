module AlphaBranchPredictorTB;
logic clock,reset,BranchTaken,PredictedBranch;
logic [9:0] PC;

real tests,WrongPredict,WrongRefPredict = 0.0;
real PredictPercent,RefPredictPercent;
logic RefpredictedBranch;

AlphaBranchPredictor ABP(clock,reset,PC,BranchTaken,PredictedBranch);
bind AlphaBranchPredictor Assertions ASRT(clock,ABP.CD.clockOUT,reset,PC,BranchTaken,PredictedBranch,ABP.LD.LHT.LHTresult,ABP.LD.LPT.LPresult,
ABP.GD.GCP.GPresult,ABP.GD.GCP.CPresult,ABP.GD.PH.PHresult);
ReferenceCounter RC(ABP.SlowClock,reset,PC,BranchTaken,RefPredictedBranch);

always #2 clock=~clock;

class constraints;
	rand 	bit 	reset;
	rand 	logic 	[9:0] PC;
	rand 	logic 	BranchTaken;
	
	int w_PC5bit0_7=60,w_PC5bit8_15=20,w_PC5bit16_23=10,w_PC5bit24_31=10,w_BranchTaken1=80,w_BranchTaken0=20;
	int samepcval= 1024;
	constraint rst{								// Constraint to randomize reset with given weights
		reset dist {1:=1,0:=99};
	}
	constraint PCrepeat4_0{						// Constraint to maintain upper 5 bits of PC constant, and lower 5 bits are randomized in groups as per given weights
		reset == 1'b0;
		PC[9:5] inside {0,31};
		PC[4:0] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint PCrepeat9_5{						// Constraint to maintain lower 5 bits of PC constant, and upper 5 bits are randomized in groups as per given weights
		reset == 1'b0;
		PC[4:0] inside {0,31};
		PC[9:5] dist {[0:7]:= w_PC5bit0_7,[8:15]:=w_PC5bit8_15,[16:23]:=w_PC5bit16_23,[24:31]:=w_PC5bit24_31};
	}
	constraint actualbranch{					// Constraint to randomize Actual Branch Taken as per given weights
		reset == 1'b0;
		BranchTaken dist {1:=w_BranchTaken1,0:=w_BranchTaken0};
	}
	constraint samePC{
		reset == 1'b0;
		PC inside {samepcval};
	}
endclass

covergroup coverage;
	option.per_instance = 1;		// coverage is collected separately for each instance
	option.auto_bin_max = 1024;		// maximum number of auto bins created for each variable
	option.weight = 1;				// relative importance of this covergroup
	option.get_inst_coverage = 1;	// 
	type_option.merge_instances = 1;
	
	PC_bin : coverpoint PC {
		bins PC_bin[] = {[0:1023]};
	}
	BranchTaken_bin : coverpoint BranchTaken {
		bins BranchTaken_bin[] = {0,1};
	}
	cross_PC_BranchTaken_bin : cross PC_bin, BranchTaken_bin;
endgroup

constraints cnstr;		// Instance for constraints class
coverage cvr;//=new; 		// Instance for coverage class

initial begin: weighted_randomization
	static int coverpercentage;
	cnstr = new();
	cnstr.rst.constraint_mode(0);
	cnstr.PCrepeat9_5.constraint_mode(0);
	cnstr.PCrepeat4_0.constraint_mode(1);
	cnstr.actualbranch.constraint_mode(1);
	cnstr.samePC.constraint_mode(0);
	//cnstr.constraint_mode(0);
	cnstr.w_PC5bit0_7 	= 40;
	cnstr.w_PC5bit8_15 	= 30;
	cnstr.w_PC5bit16_23 = 20;
	cnstr.w_PC5bit24_31 = 10;
	cnstr.w_BranchTaken1= 90;
	cnstr.w_BranchTaken0= 10;
	cnstr.samepcval = 250;
	clock=0;
	resetalpha(4);
	ForLoopTest(500);
	$display("FOR + IF LOOP TEST CASE WITH IF CONDITION 0 ");
	ForIfLoopTest(500,0);
	$display("FOR + IF LOOP TEST CASE WITH IF CONDITION $random");
	ForIfLoopTestRandom(500);
	$display("FOR + IF LOOP TEST CASE WITH IF CONDITION 1");
	ForIfLoopTest(500,1);

	RandomTests(7000);

	RESULTS();

	$stop();
end



logic [9:0] ILHT [1023:0]	= '{default:'0};
logic [2:0] ILPT [1023:0]	= '{default:'0};
logic [1:0] IGP [4095:0]	= '{default:'0};
logic [1:0] ICP [4095:0]	= '{default:'0};
logic [11:0] IPH 			= '{default:'0};
logic IdealBranch,IdealLocal,IdealGlobal,IdealChoice;
logic ig,ip;

task resetalpha(input int x);
	reset=1'b1;
	BranchTaken = 'bx;
	PC = 'bx;
	repeat(8.5*x) @(negedge clock);
endtask

task updatealpha(input logic [9:0] pc,input logic ab);
	reset		=1'b0;
	BranchTaken = 'bx;
	PC 			= pc;
	tests		+= 1;
	@(negedge clock);
	IdealLocal 	= ILPT[ILHT[PC]] >= 4 	? 1 : 0;
	IdealGlobal = IGP[IPH] >= 2 		? 1 : 0;
	IdealChoice = ICP[IPH] >= 2 		? 1 : 0;
	IdealBranch = IdealChoice ? IdealGlobal: IdealLocal;
	repeat(3) @(negedge clock);
	 if(IdealBranch!==PredictedBranch) $display("ERROR output = %b expected = %b",PredictedBranch,IdealBranch);

	BranchTaken = ab;
	@(negedge clock);

	if(PredictedBranch!=BranchTaken) WrongPredict+=1;
		if(RefPredictedBranch!=BranchTaken) WrongRefPredict+=1;

	ig = BranchTaken==IdealGlobal ? 1 : 0;
	ip = BranchTaken==IdealLocal ? 1 : 0;
	unique case({ig,ip})
	0: ICP[IPH] = ICP[IPH];
	1: ICP[IPH] = ICP[IPH]>0 ? ICP[IPH]-1 : ICP[IPH];
	2: ICP[IPH] = ICP[IPH]<3 ? ICP[IPH]+1 :ICP[IPH];
	3: ICP[IPH] = ICP[IPH];
	endcase

	if(BranchTaken) begin
		ILPT[ILHT[PC]] 	= ILPT[ILHT[PC]] < 7 ?  ILPT[ILHT[PC]]+1 : 7;
		ILHT[PC]		= ILHT[PC] << 1 | 1'b1;
		IGP[IPH] 		= IGP[IPH] < 3 ? IGP[IPH]+1 : 3;
		IPH				= IPH>>1 | 12'h800;
	end
	else begin
		ILPT[ILHT[PC]] 	= ILPT[ILHT[PC]] > 0 ?  ILPT[ILHT[PC]]-1 : 0;
		ILHT[PC]		= ILHT[PC]<<1;
		IGP[IPH] 		= IGP[IPH] > 0 ? IGP[IPH]-1 : 0;
		IPH				= IPH>>1;
	end

	repeat(3) @(negedge clock);
endtask

task ForLoopTest(input int x);
	automatic real flt 		= x+1;
	automatic real fltfail 	= WrongPredict;
	automatic real reffltfail = WrongRefPredict;
	cvr = new;
	repeat(x-1) begin
		updatealpha(30,1); 
		cvr.sample(); 
	end
	updatealpha(30,0);
	fltfail 	= WrongPredict-fltfail;
	reffltfail 	= WrongRefPredict-reffltfail;
	$display("FOR LOOP TEST CASE");
	$display("TOURNAMENT PREDICTOR >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",flt,fltfail,100*(flt-fltfail)/flt);
	$display("REFERENCE PREDICTOR  >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",flt,reffltfail,100*(flt-reffltfail)/flt);
	$display("\n");
endtask

task ForIfLoopTest(input int x, input logic act);
	automatic real filt 	= 2*x -1;
	automatic real filtfail = WrongPredict;
	automatic real reffiltfail = WrongRefPredict;
	cvr = new;
	repeat(x-1) begin
		updatealpha(70,1);
		updatealpha(106,act);
		cvr.sample(); 
	end
	updatealpha(70,0);
	filtfail 	= WrongPredict - filtfail;
	reffiltfail = WrongRefPredict - reffiltfail;
	$display("TOURNAMENT PREDICTOR >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",filt,filtfail,100*(filt-filtfail)/filt);
	$display("REFERENCE PREDICTOR  >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",filt,reffiltfail,100*(filt-reffiltfail)/filt);
	$display("\n");
endtask

task ForIfLoopTestRandom(input int x);
	automatic real filt 	= 2*x -1;
	automatic real filtfail = WrongPredict;
	automatic real reffiltfail = WrongRefPredict;
	cvr = new;
	repeat(x-1) begin
		updatealpha(70,1);
		updatealpha(106,$random); 
		cvr.sample();
	end
	updatealpha(70,0);
	filtfail 	= WrongPredict - filtfail;
	reffiltfail = WrongRefPredict - reffiltfail;
	$display("TOURNAMENT PREDICTOR >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",filt,filtfail,100*(filt-filtfail)/filt);
	$display("REFERENCE PREDICTOR  >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",filt,reffiltfail,100*(filt-reffiltfail)/filt);
	$display("\n");
endtask

task RandomTests(input int x);
	automatic real Randtest 	= x;
	automatic real Randfail 	= WrongPredict;
	automatic real RefRandfail 	= WrongRefPredict;
	cvr = new;
	repeat(x) begin
		RANDOMIZATION_FAILURE:assert(cnstr.randomize());
		updatealpha(cnstr.PC,cnstr.BranchTaken);
		cvr.sample();
	end
	Randfail 	= WrongPredict - Randfail;
	RefRandfail = WrongRefPredict - RefRandfail;
	$display("RANDOM TEST CASE");
	$display("TOURNAMENT PREDICTOR >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",Randtest,Randfail,100*(Randtest-Randfail)/Randtest);
	$display("REFERENCE PREDICTOR  >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",Randtest,RefRandfail,100*(Randtest-RefRandfail)/Randtest);
	$display("\n");
endtask



task RESULTS();
	PredictPercent		= ((tests - WrongPredict)/tests)*100;
	RefPredictPercent 	= ((tests - WrongRefPredict)/tests)*100;
	$display("END RESULTS:");
	$display("TOURNAMENT PREDICTOR >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",tests,WrongPredict,PredictPercent);
	$display("REFERENCE PREDICTOR  >> Tests: %d ,Wrong Predictions: %d, Predict Percentage: %f ",tests,WrongRefPredict,RefPredictPercent);
endtask

endmodule


