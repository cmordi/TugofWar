//This top-level module displays the results of all the modules being combined  together
// in order to be displayed on the physical FPGA board. The inputs are SW[9:0], KEY[3:0] and  CLOCK_50.
	
	// Overall inputs and outputs to the DE1_SoC module are listed below:
	// Inputs: 10-bit SWs, CLOCK_50, and 4-bit KEYs
	// Outputs: 10-bit LEDRs and 7-bit HEX's


module DE1_SoC (HEX0, LEDR, SW, KEY, CLOCK_50);
	
	output logic [9:0] LEDR;
	output logic [6:0] HEX0;
	input logic [9:0] SW;	
	input logic [3:0] KEY; 	
	input logic CLOCK_50; 
	 
	// this will set the following logic to their neutral forms/resetting
	logic first_lt, third_lt; 
	logic first_in, third_in;

	// all of my lights are being instantiated below and are thus being set to the correct positions as well 
	centerLight center	 (.L(third_lt), .R(first_lt), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]), .clk(CLOCK_50), .reset(SW[9]));
	
	normalLight first	 (.L(third_lt), .R(first_lt), .NL(LEDR[2]),	 .NR(1'b0),		 .lightOn(LEDR[1]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight second	 (.L(third_lt), .R(first_lt), .NL(LEDR[3]),	 .NR(LEDR[1]),	 .lightOn(LEDR[2]), 	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight third	 (.L(third_lt), .R(first_lt), .NL(LEDR[4]),	 .NR(LEDR[2]),	 .lightOn(LEDR[3]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight fourth	 (.L(third_lt), .R(first_lt), .NL(LEDR[5]),	 .NR(LEDR[3]),	 .lightOn(LEDR[4]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight fifth	 (.L(third_lt), .R(first_lt), .NL(LEDR[7]),	 .NR(LEDR[5]),	 .lightOn(LEDR[6]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight sixth	 (.L(third_lt), .R(first_lt), .NL(LEDR[8]),	 .NR(LEDR[6]),	 .lightOn(LEDR[7]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight seventh	 (.L(third_lt), .R(first_lt), .NL(LEDR[9]),	 .NR(LEDR[7]),	 .lightOn(LEDR[8]),	 .clk(CLOCK_50), .reset(SW[9]));
	normalLight eighth	 (.L(third_lt), .R(first_lt), .NL(1'b0),	 .NR(LEDR[8]),	 .lightOn(LEDR[9]),	 .clk(CLOCK_50), .reset(SW[9]));

	// flick is being instatiated and is also being used to combat metastability
	flick state1 (.button(!KEY[0]), .out(first_in), .clk(CLOCK_50), .reset(SW[9]));
	flick state2 (.button(!KEY[3]), .out(third_in), .clk(CLOCK_50), .reset(SW[9]));

	// user input is being instantiated and is being used to combat metastability
	userInput first_u	 (.button(first_in),	 .out(first_lt),	 .clk(CLOCK_50), .reset(SW[9])); 
	userInput last_u	 (.button(third_in),	 .out(third_lt),	 .clk(CLOCK_50), .reset(SW[9]));
	
	//victory is being instatiated and is being used to signal the side that one. 
	//i added a little surprise to declare the winner as well
	victory ending (.LED1(LEDR[1]),.LED9(LEDR[9]), .L(third_lt), .R(first_lt), .champ(HEX0), .clk(CLOCK_50), .reset(SW[9]));
	
endmodule

// Testbench for DE1_SoC module. Tests all combinations of the 10-bit inputs of SW[9:0] amd 4-bit input of the KEY [3:0].
// Allows one to check that the correct output is displayed on LEDR[9:0].
module DE1_SoC_testbench();

	
	logic [9:0] LEDR;
	logic [9:0] SW;
	logic [3:0] KEY;
	logic CLOCK_50;
	
	logic [6:0] HEX0;

	//instantiates de1_soc 
	DE1_SoC dut (.HEX0, .LEDR, .SW, .KEY, .CLOCK_50);
	
	//Generate clk off of CLOCK_50, whichClock picks rate. Thus dictating the speed of the clock
	//will keep going until condition is met
	parameter CLOCK_PERIOD = 50;
	initial begin
		CLOCK_50 <= 0;
			forever #(CLOCK_PERIOD/2) 
		CLOCK_50 <= !CLOCK_50;
	end
	
	// clock cycles to be tracked
	initial begin
										@(posedge CLOCK_50);
		SW[9] <= 1;						@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[9] <= 0;						@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 0;		@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1; 					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0; 					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0; KEY[3] <= 1;		@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;    				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;    				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		$stop;
	end
endmodule

//clock divider that divideds the period 
module clock_divider (clock, divided_clocks);
	input logic clock; 
	output logic [31:0] divided_clocks = 0; 

	always_ff @(posedge clock) 
	begin
		divided_clocks <= divided_clocks + 1;
	end

endmodule 