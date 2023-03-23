module GlobalChoicePredictorTB;
logic clock,reset,BranchTaken,LPresult,GPresult,CPresult;
logic [11:0] PHresult;
logic count;

GlobalChoicePredictor DUT(clock,reset,BranchTaken,LPresult,PHresult,GPresult,CPresult);

always #5 clock = ~clock;

class GCP_constraints;
rand bit   reset;
rand logic [11:0] phresult;
rand logic BranchTaken;
rand logic LPresult;

int w_PC5bit0_7=60,w_PC5bit8_15=20,w_PC5bit16_23=10,w_PC5bit24_31=10,w_BranchTaken1=80,w_BranchTaken0=20;
int samepcval= 1024;

constraint resetC{
reset dist {1:=1, 0:=99};
}

constraint phresultC{
reset == 1'b0;
// phresult[9:5] inside {0,31};
// phresult[4:0] dist {[0:7]:=60, [8:15]:=20, [16:23]:=10, [24:31]:=10};
phresult[11:0] dist {0,4095};
}

constraint BranchTakenC{
BranchTaken dist {1:=80, 0:=20};
}

constraint LPresultC{
LPresult dist {1:=80, 0:=20};
}

endclass
GCP_constraints cnstr;
initial begin
    clock=0;
    
	cnstr = new();
    resetGCHT(4);
	cnstr.resetC.constraint_mode(0);
	cnstr.phresultC.constraint_mode(0);
	cnstr.BranchTakenC.constraint_mode(0);
	cnstr.LPresultC.constraint_mode(0);
	// resetGCHT(4);

repeat(30) begin 
RANDOMIZATION_FAILURE:assert(cnstr.randomize());
updateGCHT(cnstr.phresult, cnstr.BranchTaken, cnstr.LPresult);
end
	
/*  updateGCHT(0,1,1);
    updateGCHT(0,1,1);
    updateGCHT(0,1,1);
    updateGCHT(0,1,1);  
    updateGCHT(0,1,1); 
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0);
    updateGCHT('hf,1,0); 
    updateGCHT('hf,1,0); */

resetGCHT(4);
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
