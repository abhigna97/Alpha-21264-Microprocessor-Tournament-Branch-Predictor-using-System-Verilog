// Code your design here
module counter(input ao, input clock, input reset, output logic prediction);
// logic prediction;
logic [1:0] sr='0;
int count;

// assign prediction = sr[1];


always_ff@(posedge clock, posedge reset) begin
if(reset) begin
prediction<=0;
count<=0;
end else begin 
case(count)
0: begin
  prediction<=sr[1];
  count<=1;
end
    
1: begin

if(ao)begin
if(sr==2'b10)
sr<=2'b11;
else if(sr==2'b11)
sr<=2'b11;
else
sr<=sr<<1 | 2'b01;
end

else begin

if(sr==2'b01)
sr<=2'b00;
else if(sr==2'b00)
sr<=2'b00;
else
sr<=sr<<1;
end

count<=0; 
end
endcase
end
  // sr<=sr<<1 | ao;

end

  
endmodule
