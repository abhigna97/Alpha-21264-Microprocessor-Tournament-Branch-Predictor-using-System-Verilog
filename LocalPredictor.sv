module LocalPredictor(
    input 	logic clock,
    input 	logic reset,
    input 	logic BranchTaken,
    input 	logic [9:0] LHTresult,
    output 	logic LPresult);

    logic [2:0] LPT [1023:0]= '{default:'0};          				//Local Predictor of 1024 entries containing 3 bits history
    logic [2:0] LPTresult;
    assign LPresult = (LPTresult > 3) ? 1 : 0;

    logic [2:0] state=0;


    always_ff @(posedge clock or posedge reset) begin
        if (reset) LPT<='{default:'0};
	else begin
	    case(state)
//0:
		1:LPTresult <= LPT[LHTresult];
//2:
//3:
//4:
//5:
		5: begin          			
		    if(BranchTaken) LPT[LHTresult] <= LPTresult < 7 ? LPTresult + 1'b1 : LPTresult; 
		    else LPT[LHTresult] <= LPTresult > 0 ? LPTresult - 1'b1 : LPTresult;
		    //LPTresult<='bx;
		end
                7: LPTresult<='bx;
//7:
	    endcase
	state<=state+1;
        end 
    end 
endmodule
