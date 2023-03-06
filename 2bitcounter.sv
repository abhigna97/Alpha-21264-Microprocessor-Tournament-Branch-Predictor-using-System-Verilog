module Global2BitFSM(
input        clock,
input        reset,
input        BranchTaken,
output logic GPresult
);

localparam NTAKEN=0, TAKEN=1;

typedef enum {SNT, WNT, WT, ST} state;

state currentState, nextState;

assign GPresult = (currentState==WT | currentState==ST) ? TAKEN : NTAKEN;

always_ff@(posedge clock or posedge reset)
  if(reset)
    currentState <= SNT;
  else
    currentState <= nextState;

always_comb begin
  unique case(currentState)
    SNT:  nextState = (BranchTaken) ? WNT : SNT; 
    WNT:  nextState = (BranchTaken) ? WT  : SNT; 
    WT :  nextState = (BranchTaken) ? ST  : WNT; 
    ST :  nextState = (BranchTaken) ? ST  : WT; 
  endcase
end

endmodule
