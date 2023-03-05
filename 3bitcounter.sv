module Local3BitFSM(clock,reset,BranchTaken,LPresult);

    input logic clock,reset,BranchTaken; 
    output logic LPresult;
    
    enum logic [2:0] {SN,WN1,WN2,WN3,WT1,WT2,WT3,ST} cst,nst;

    always_ff @ (posedge clock or posedge reset) begin
      	if(!reset) cst<=nst;
      	else cst<=SN;
    end
  
    always_comb begin
        case(cst)
	    SN:nst=BranchTaken==0 ? SN:WN1;
            WN1:nst=BranchTaken==0 ? SN:WN2;
            WN2:nst=BranchTaken==0 ? WN1:WN3;
            WN3:nst=BranchTaken==0 ? WN2:WT1;
            WT1:nst=BranchTaken==0 ? WN3:WT2;
            WT2:nst=BranchTaken==0 ? WT1:WT3;
            WT3:nst=BranchTaken==0 ? WT2:ST;
            ST:nst=BranchTaken==0 ? WT3:ST;
        endcase
    end
  
    assign LPresult = cst>=WT1 ? 1:0;
  
endmodule
