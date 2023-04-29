/* The flick module is what is used to test metastability. It accepts clk, reset and button as an input*/

 
// Overall inputs and outputs for the flick module are listed below:
//Input: 10 - bit clk, 2 bit reset, 2 bit button 
//Output: 2- bit out
module flick (reset, button, out, clk);


input logic clk;
input logic reset;
input logic button;
output logic out;
logic state1;

//for analyzing DFF
	always_ff @(posedge clk) 
    begin
		state1 <= button;
	end
	
	always_ff @(posedge clk) 
    begin
		out <= state1;
	end
endmodule

// Testbench for flick  module. 
// Allows one to check that the correct output is shown throughout board
module flick_testbench();
	logic clk;
	logic reset;
	logic button;
	logic out;
	
	//this instantiates the flick module
	flick dut (.reset, .button, .out, .clk);
	
	//clock setup. is satisfied when conditions are met
	parameter CLOCK_PERIOD = 50;
	
	//Generate clk off of CLOCK_50, whichClock picks rate. Thus dictating the speed of the clock
	//will keep going until condition is met
	initial begin
		clk <= 0;
			forever #(CLOCK_PERIOD/2) 
		clk <= !clk;
	end
	
	// clock cycles to be tracked
	initial begin
		
		reset		 		<= 1;					@(posedge clk); //50
													@(posedge clk); //150
		reset		 		<= 0;					@(posedge clk); //200
													@(posedge clk); //250
		button		 		<= 0;					@(posedge clk); //300
													@(posedge clk); //350
													@(posedge clk); //400
		button		 		<= 1;					@(posedge clk); //450
													@(posedge clk); //500
													@(posedge clk); //550
		button		 		<= 0;					@(posedge clk); //600
													@(posedge clk); //650
													@(posedge clk); //700
		button		 		<= 1;					@(posedge clk); //750
													@(posedge clk); //800
													@(posedge clk); //850
													
		$stop; 
	end 
endmodule