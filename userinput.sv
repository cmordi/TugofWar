//This  userInput module accepts the button, clk and out.
// This will handle all user input
module userInput(button, clk, reset, out);

	// Overall inputs and outputs to the userInput module are listed below:
	// Inputs: 2 bit button, 2 bit reset, 2 bit clk
	// Outputs: 2 bit out

	input logic button, clk, reset;
	output logic out;
	
	enum {on, off} ps, ns; //present state and next state
	
	// next state logic 
	always_ff @(posedge clk) begin
		case(ps)
			on: 	if (button) ns <= on;	// will be zero
						
					else ns <= off;			// will be one
						
				
			off: 	if (button) ns <= on; 	// will be zero 
						
					else ns <= off;			// will be zero
			
		endcase
	end
	
	//this denotes the conditions for the output to run
	assign out = (ps == on & ns == off);
	
	// this is for metastability in terms of D-flipflops
	always_ff @(posedge clk) begin
		if (reset) 					//reset is pressed, then present state is off. if not then it is on
			ps <= off;
		else
			ps <= ns;
	end
endmodule

//Testbench for user_Input module that will test the single button press and allows me to simulate in modelsim
//to make sure that the correct output is displayed

module userInput_testbench();
	logic clk, reset;
	logic button;
	logic out;
	
	// Instantiates userInput
	userInput dut (.out, .button, .clk, .reset);	
	
	//setting clock period 
	parameter CLOCK_PERIOD = 50;
	
	//further setup of clock. in which it will continue until it reaches its condition
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
		
		$stop; //this will end the simulation
	end
endmodule //this will end the module