module top;
bit   clock=1;
logic reset=0;
logic branchIn;
logic outcome;

BitSaturatingCounter dut(clock,reset,branchIn,outcome);

always  clock = #3 ~clock;

initial begin
#5 reset = 1;
#8 branchIn = 1;
#5 branchIn = 0;
#5 branchIn = 1;

#10 $stop;
end

endmodule
