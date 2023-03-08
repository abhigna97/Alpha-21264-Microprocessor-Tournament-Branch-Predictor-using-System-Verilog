// Code your design here
module choice_predictor(
input clock,
input reset,
input ActualLocalPrediction,         //  these are from external source
input ActualGlobalPrediction,        
output prediction               // MSB indicates the type of predictor
);

enum {L1, L0, G0, G1} currentState, nextState;

assign prediction = (currentState==L0 || currentState==L1) ? 0 : 1; // 0-local, 1-global

always_ff@(posedge clock)
if(reset)
currentState <= L0;
else
currentState <= nextState;

always_comb
begin
unique case(currentState)
L1: if((!ActualGlobalPrediction && ActualLocalPrediction) || (!ActualGlobalPrediction && !ActualLocalPrediction) || (ActualGlobalPrediction && ActualLocalPrediction))
    nextState = L1;
else
    nextState = L0;

L0: if((!ActualGlobalPrediction && !ActualLocalPrediction) || (ActualGlobalPrediction && ActualLocalPrediction))
    nextState = L0;
else if((!ActualGlobalPrediction && ActualLocalPrediction))
    nextState = L1;
else
    nextState = G0;

G0: if((!ActualGlobalPrediction && !ActualLocalPrediction) || (ActualGlobalPrediction && ActualLocalPrediction))
    nextState = G0;
else if((!ActualGlobalPrediction && ActualLocalPrediction))
    nextState = L0;
else
    nextState = G1;

G1: if((ActualGlobalPrediction && !ActualLocalPrediction) || (!ActualGlobalPrediction && !ActualLocalPrediction) || (ActualGlobalPrediction && ActualLocalPrediction))
    nextState = G1;
else
    nextState = G0;
endcase
end

endmodule
