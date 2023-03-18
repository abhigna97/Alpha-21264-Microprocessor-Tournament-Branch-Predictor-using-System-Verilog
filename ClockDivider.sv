module ClockDivider (input logic clockIN,output logic clockOUT);

logic [1:0] count=0;
logic tempclock;

always_ff @(negedge clockIN) begin
	count <= count + 1'b1;
	tempclock<= count<2 ? 1 : 0;
end

assign clockOUT = tempclock;

endmodule
