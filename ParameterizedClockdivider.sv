module ParameterizedClockDivider #(
	parameter DIVISOR = 2
)(
    input logic clockIN,
    output logic clockOUT
);

logic [31:0] count = 32'd0;

always_ff @(posedge clockIN) begin
	count <= count + 1'b1;
	if (count >= (DIVISOR-1))  count <= 32'd0;
    clockOUT <= (count < (DIVISOR/2))? 1'b1: 1'b0;
end

  property p_clocktoggle;									// Property: clockOUT should toggle every DIVISOR cycles
    @(posedge clockIN)
	(count===0) & $rose(clockOUT) |=> ##(DIVISOR) $fell(clockOUT);
  endproperty
  
  property p_dutycycle;										// Property: clockOUT should have a 50% duty cycle
    @(posedge clockIN)
	$rose(clockOUT) |=> ##(DIVISOR/2-1) $changed(clockOUT);
  endproperty
  
  a_clocktoggle:assert property (p_clocktoggle)
    else $error("Assertion failed: a_clocktoggle is false");
  
  a_dutycycle:assert property (p_dutycycle)
    else $error("Assertion failed: a_dutycycle is false");

endmodule
