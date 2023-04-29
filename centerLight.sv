//The center light module displays a single light at the center of the board at the beginning of each game
// on the physical FPGA board and when the game resets. The inputs are clk, reset
//  NL, NR, L, R
module centerLight (lightOn, clk, reset, L, R, NL, NR);

	// Overall inputs and outputs to the centerLight module are listed below:
	// Inputs: 2 bit clk, 2 bit reset, 2 bit NL, 2 bit NR, 2 bit L, 2 bit R
	// Outputs: 2 bit lightOn
	output logic lightOn;
	input logic clk, reset;
	input logic L, R;
	input logic NL, NR;
	
	//assigning state variables
	enum {on, off} ps, ns;

	//states of the lights
	always_comb 
	begin
		case(ps)
			on: lightOn = 1;
			
			off: lightOn = 0;
		endcase
	end
	
	//next state logic
	always_comb 
	begin 
		case(ps)
			on:    	if(!R&L | R&!L) 
						ns = off;
					else ns = on; 
				 
			off: 	if(L&NR&!R | R&NL&!L) 
						ns = on;
					else ns = off; 
			
		endcase
		
	end
	
	//sequential  logic (DFF)
	always_ff @(posedge clk) 
	begin
		if(reset) 
			ps <= on;
		else
			ps <= ns;
	end
	
endmodule

//Testbench for centerLight module. 
// Allows one to check that the correct output is displayed 
module centerLight_testbench();
	logic L, R; 
	logic NL, NR;
	logic lightOn;
	logic clk, reset; 
	
	//instatiating centerLight
	centerLight dut (.lightOn, .clk, .reset, .L, .R, .NL, .NR);
	
	//clock setup. is satisfied when conditions are met
	parameter CLOCK_PERIOD = 50;
	initial 
	begin
		clk <= 0;
			forever #(CLOCK_PERIOD/2) 
		clk <= !clk;
	end 
	
	// clock cycles to be tracked
	initial 
	begin
														@(posedge clk)  
		reset <= 1;										@(posedge clk)	
														@(posedge clk)
		reset <= 0;										@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 1; L <= 1; R <= 0;				@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0;								@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; 								@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 1; 								@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0; L <= 1; 						@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		reset <= 1;										@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 1; NR <= 0; L <= 0; R <= 1; 				@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 1; R <= 0; 				@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		NL <= 0; NR <= 0; L <= 0; R <= 1; 				@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		$stop; 
	end 
endmodule 