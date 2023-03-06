module PathHistory (
  input        clock,
  input        reset,
  input        BranchTaken,                   // outcome
  output logic [7:0] PHistory
);

always_ff@(posedge clock or posedge reset)
  if (reset)
    PHistory <= 8'b00000000; 
  else
    PHistory <= {PHistory[6:0], BranchTaken}; // shift right and update with outcome

endmodule
