module Global2BitFSM(
input        clock,
input        reset,
input        BranchTaken,
input logic [11:0] PathHistory,
output logic GPresult
);

logic GPresult1;
logic [1:0] GP [4095:0]= '{default:'0};

always_comb  begin
  if(reset)                   GPresult= GPresult1;
  else if (GP[PathHistory]>1) GPresult=1;
  else                        GPresult=0;
end

always_ff@(posedge clock or posedge reset)
  begin
  if(reset) 
    begin  
    GPresult1<=1'b0; 
    GP[PathHistory]<='0; 
    end
  else 
    begin
    if(GP[PathHistory]>1)
      begin
      if(BranchTaken) GP[PathHistory]<= GP[PathHistory]<3 ? GP[PathHistory]+1'b1 : GP[PathHistory];
      else            GP[PathHistory]<= GP[PathHistory]-1'b1;
      end
    else 
      begin
      if(!BranchTaken) GP[PathHistory]<= GP[PathHistory]>0 ? GP[PathHistory]-1'b1 : GP[PathHistory];
      else             GP[PathHistory]<= GP[PathHistory]+1'b1;
      end
    end
  end

endmodule
