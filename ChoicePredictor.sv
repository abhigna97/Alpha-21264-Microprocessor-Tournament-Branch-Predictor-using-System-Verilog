// Code your design here
module choice_predictor(
input clock,
input reset,
input ActualPrediction,         //  these are from external source      
output prediction               //  MSB indicates the type of predictor
);

enum {L1, L0, G0, G1} currentState, nextState;

assign prediction = (currentState==L0 || currentState==L1) ? 0 : 1; // 0-local, 1-global

always_ff@(posedge clock)
    if(reset)
        currentState <= L1;
    else
        currentState <= nextState;

always_comb
    begin
        unique case(currentState)
            L1: if(ActualPrediction)
                    nextState = L0;
                else
                    nextState = L1;

            L0: if(ActualPrediction)
                    nextState = G0;
                else
                    nextState = L1;

            G0: if(ActualPrediction)
                    nextState = G1;
                else
                    nextState = L0;

            G1: if(ActualPrediction)
                    nextState = G1;
                else
                    nextState = G0;
        endcase
    end

endmodule
