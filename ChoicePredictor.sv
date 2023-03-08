// Code your design here
module choice_predictor(
input clock,
input reset,
input [11:0] PathHistory,
input ActualPrediction,               
output prediction               
);

logic [1:0] CP [4095:0];
    
assign prediction = (CP[PathHistory] > 1) ? 1 : 0;
    
always_ff@(posedge clock)
    if(reset)
      CP <= '{default:'0};
    else
        CP[PathHistory]<= (ActualPrediction) ? CP[PathHistory] + 1'b1 : CP[PathHistory] - 1'b1;

endmodule
