module BitSaturatingCounter(
input        clock,
input        resetN,
input        branchIn,
output logic outcome
);
localparam NTAKEN=0, TAKEN=1;
typedef enum {SNT, WNT, WT, ST} state;
// typedef enum  logic {NTAKEN, TAKEN} out;

state currentState, nextState;
// out outcome;

  assign outcome = (currentState==WT | currentState==ST) ? TAKEN : NTAKEN;

always_ff@(posedge clock)
if(!resetN)
currentState <= SNT;
else
currentState <= nextState;

always_comb begin
// outcome = NTAKEN;
unique case(currentState)
SNT:  nextState = (branchIn) ? WNT : SNT; 
WNT:  nextState = (branchIn) ? WT  : SNT; 
WT :  nextState = (branchIn) ? ST  : WNT; 
ST :  nextState = (branchIn) ? ST  : WNT; 
endcase

end

endmodule
