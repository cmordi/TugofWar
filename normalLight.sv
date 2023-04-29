//The normal light module tracks the movement of the "rope" and displays it on the board
// to the physical FPGA board and when the "rope" reaches the end. The inputs are clk, reset
//  NL, NR, L, R

module normalLight(lightOn, clk, reset, NL, NR, L, R,);
	
	// Overall inputs and outputs to the normalLight module are listed below:
	// Inputs: clk, reset, NL, NR, L, R
	// Outputs: lightOn
	output logic lightOn;
	input logic clk, reset;
	input logic L, R; 
	input logic NL, NR;
	
	// assigning state variables
	enum {on, off} ps, ns;

	//shows states of lights
	always_comb 
	begin
		case (ps)
			on: lightOn = 1;
			
			off: lightOn = 0;
		endcase
	end
	
	//next state logic
	always_comb 
	begin
		case (ps)
			on:	  	if(R & !L | !R & L) 
						ns = off;
					else ns = on;
					
			off: 	if(R & NL & !L | L & NR & !R) 
						ns = on;
					else ns = off;
		endcase
	end
	
	//sequential logic (DFF)
	always_ff @(posedge clk) begin
		if (reset) 
			ps <= off;
		else
			ps <= ns;
	end
	
endmodule 

//Testbench for normalLight module. 
// Allows one to check that the correct output is displayed 
module normalLight_testbench();
	logic L, R; 
	logic NL, NR;
	logic lightOn;
	logic clk, reset; 
	
	//instantiating normal light 
	normalLight dut (.lightOn, .clk, .reset, .L, .R, .NL, .NR);
	
	//clock setup. is satisfied when conditions are met
	parameter CLOCK_PERIOD = 50;
	initial 
	begin
		clk <= 0;
			forever #(CLOCK_PERIOD/2)  
		clk <= !clk;
	end 
	
	// clock cycles to be tracked
	initial begin
														@(posedge clk);
		reset <= 1;										@(posedge clk);
														@(posedge clk);
		reset <= 0;										@(posedge clk);
														@(posedge clk);
		L <= 1; R <= 0; NL <= 0; NR <= 1;				@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		NL <= 1; NR <= 0;      							@(posedge clk);		
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		L <= 0; R <= 1; 								@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		NL <= 0; NR <= 1;					 			@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		L <= 1; 			 NL <= 1; NR <= 0;			@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		reset <= 1;										@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		L <= 0; R <= 1; NL <= 1; NR <= 0;				@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		L <= 1; R <= 0; NL <= 0; NR <= 0;				@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		L <= 0; R <= 1; NL <= 0; NR <= 0;				@(posedge clk);
		$stop; 
	end 
endmodule   