module PathHistory (
  input        clock,
  input        reset,
  input        BranchTaken,                   // outcome
  output logic [11:0] PHistory
);

// localparam N=12;

always_ff@(posedge clock or posedge reset)
  if (reset)
    PHistory <= '0; 
  else
    PHistory <= {PHistory[10:0], BranchTaken}; // shift right and update with outcome

endmodule

