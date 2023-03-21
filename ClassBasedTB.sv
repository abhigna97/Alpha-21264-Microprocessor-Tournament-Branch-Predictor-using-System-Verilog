module AlphaBranchPredictor_TB;

  // Declare inputs and outputs
  logic clock;
  logic reset;
  logic [31:0] PC;
  logic BranchTaken;
  logic [31:0] PredictedBranch;
  

  AlphaBranchPredictor dut(.clock(clock), .reset(reset), .PC(PC),
                          .BranchTaken(BranchTaken), .PredictedBranch(PredictedBranch));

  class predictor_test;

    // Declare class variables
    rand logic [31:0] PC_rand;
    rand logic BranchTaken_rand;
    logic [31:0] PredictedBranch_observed;   
    

    // Declare coverage variables
    covergroup predictor_coverage;
      option.per_instance = 1;
      option.type = option.with_function;
      option.auto_bin_max = 1024;
      option.weight = 1;
      option.cross = "X";

      PC_bin : coverpoint PC_rand {
        bins PC_bin[] = {[0:1023]};
      }
      BranchTaken_bin : coverpoint BranchTaken_rand {
        bins BranchTaken_bin[] = {0,1};
      }
      PredictedBranch_bin : coverpoint PredictedBranch_observed {
        bins PredictedBranch_bin[] = {[0:1023]};
      }
      cross_pc_branch_bin : cross PC_bin, BranchTaken_bin {
        bins cross_pc_branch_bin[] = {[0:1023], 0,
                                      [0:1023], 1};
      }
    endgroup

    // Declare constraints
    constraint branch_constraint {
      PC_rand >= 0;
      PC_rand <= 1023;
      PredictedBranch_observed inside {[0:1023]};
    }

    // Declare the main test function
    task run_test;
      // Initialize inputs
      reset = 1'b1;
      PC = 0;
      BranchTaken = 1'b0;

      // Apply reset
      @(negedge clock);
      reset = 1'b0;

      // Randomize inputs using constraints
      repeat (100) begin
        if (!randomize() with {branch_constraint;}) $error("Failed to randomize inputs");
        @(posedge clock);
        PredictedBranch_observed = PredictedBranch;
        predictor_coverage.sample();
      end
    endtask

  endclass

  // Instantiate the testbench and call the run_test function
  predictor_test test = new();
  initial begin
    test.run_test();
    $display("Coverage Results:");
    test.predictor_coverage.print();
  end

endmodule
