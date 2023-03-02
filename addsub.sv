module addsub(
input bit clock,
input logic [63:0] operandA,
input logic [63:0] operandB,
input logic add,
output logic [63:0] result
);

logic addsub;
logic [63:0] A,B;
logic signA, signB;
logic [52:0] mantissaA, mantissaB;
logic [10:0] exponentA, exponentB;
logic [10:0] exponentdiff;
logic [53:0] mantissaResult,mantissaResult1;
logic [10:0] exponentResult;
logic [63:0] Result;

always_ff@(posedge clock)
  begin
  result<=Result;
  end

always_comb
  begin
  if(operandA[62:52]=='b1 || operandA[62:52]=='b1)  //check if any exponent is 2047; If yes operand is NaN or infinity
    Result='bx;
  else
    begin
    if(operandA[62:0] < operandB[62:0])   //check if A>B; If not then swap A and B 
      begin
      B=operandA;
      A=operandB;
      end
    else
      begin
      A=operandA;
      B=operandB;
      end

    exponentA=A[62:52];
    exponentB=B[62:52];

    signA=A[63];
    signB=B[63];
    //if sign bits are same then do addition else subtraction  of magnitudes
    if(add)  addsub= ~(signA^signB);
    else     addsub= signA^signB;
    //if exponent of A!=0 then represent it as 1.mantissaA else 0.mantissaA
    if(|exponentA)  mantissaA={1'b1,A[51:0]};
    else          mantissaA={1'b0,A[51:0]};
    //if exponent of B!=0 then represent it as 1.mantissaB else 0.mantissaB
    if(|exponentB)  mantissaB={1'b1,B[51:0]};
    else          mantissaB={1'b0,B[51:0]};

    exponentdiff=exponentA-exponentB;
    mantissaB=mantissaB>>exponentdiff;
    exponentB=exponentB+exponentdiff;

    if(addsub) 
      begin
      mantissaResult1=mantissaA+mantissaB;
      if(mantissaResult1[53])  mantissaResult[51:0]=mantissaResult1[52:1];
      else                    mantissaResult[51:0]=mantissaResult1[51:0];

      if(mantissaResult1[53])  exponentResult=1+exponentA;
      else                    exponentResult=exponentA;
      end
    else
      begin
      mantissaResult=mantissaA+(~mantissaB)+1;
      end

    Result={signA,exponentResult,mantissaResult[51:0]};

    end 
  end

endmodule
