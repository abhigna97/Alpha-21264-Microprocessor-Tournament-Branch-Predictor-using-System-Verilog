module ReferenceCounter(clock,reset,PC,ActualBranch,PredictedBranch);

input logic clock,reset,ActualBranch;
input logic [9:0] PC;
output logic PredictedBranch;
 
// logic prediction;

logic count=0;
logic PR;
logic [9:0] PCprev;

 assign PredictedBranch = PR;


always_ff@(posedge clock, posedge reset) begin
if(reset) begin
PR<=0;
count<=0;
end 
else begin 

unique case(count)
0: begin
 if(PC<=PCprev) PR<=1;
else PR<=0;
  count<=1;
end
    
1: begin
count<=0;
PCprev<=PC;
end
endcase

end
end
endmodule
