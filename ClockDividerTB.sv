module ClockDividerTB;
    logic clockIN;
    logic clockOUT;

    ClockDivider DUT(clockIN,clockOUT);

    always #2 clockIN = ~clockIN;

    initial begin
		clockIN = 0;
		#500;
        $stop;
    end

endmodule

