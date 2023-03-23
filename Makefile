work = work
RTL = AlphaBranchPredictor.sv GlobalDesign.sv LocalDesign.sv GlobalChoicePredictor.sv ClockDivider.sv LocalHistoryTable.sv LocalPredictor.sv PathHistory.sv Assertions.sv ReferenceCounter.sv
TB = AlphaBranchPredictorTB.sv


lib:
	vlib $(work)

compile:
	vlog +cover -source $(RTL) $(TB)

sim:
	vsim -c -coverage -do "coverage save -onexit report.ucdb; run -all; quit -sim; vcover report report.ucdb; exit" AlphaBranchPredictorTB
	
clean:
	rm -rf transcript *.vcd work *.log 


all: clean lib compile sim
