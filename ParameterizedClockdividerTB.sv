module ClockDividerTB;
    logic clockIN;
    logic clockOUT;

    ClockDivider #(2)DUT (
		.clockIN(clockIN),
        .clockOUT(clockOUT)
    );

    always #5 clockIN = ~clockIN;

    initial begin
		clockIN = 0;
		#500;
        $stop;
    end

endmodule

