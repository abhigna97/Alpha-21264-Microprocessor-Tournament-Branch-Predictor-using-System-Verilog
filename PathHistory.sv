module PathHistory (
    input 	logic clock,
    input 	logic reset,
    input 	logic Prediction,                   
    output 	logic [11:0] PHresult);

    logic state = 0;
    logic [11:0] PH;

    assign PHresult=PH;

    always_ff @(posedge clock or posedge reset)begin
  	if (reset) begin PH <= 12'd0; state<=0; end
    else begin
        case(state)
        0:  state<=state+1;
	1:  begin PH <= {Prediction,PH[11:1]}; state<=state+1; end
    endcase 
    end
    end

endmodule
