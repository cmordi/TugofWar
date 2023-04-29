//This  module displays who won the tug of war and displays it
// to the physical FPGA board and when the "rope" reaches the end. The inputs are clk, reset
// LED1, LED9, L, R.


module victory (champ, clk, reset, LED9, LED1, L, R);

	// Overall inputs and outputs to the victory  module are listed below:
	// Inputs: 2 bit reset, 2 bit LED1, 1- bit LED9, 2 bit L, 2 bit R, 2bit clk
	// Outputs: 7-bit "champ"

	input logic clk;
	input logic reset;
	input logic LED1, LED9;
	input logic L, R;
	output logic [6:0] champ;
	
	// assigning state variables
	enum {off, P1, P2} ps, ns;
	
	//next state logic
	always_comb begin
		case(ps)
			P1: ns = P1; P2: ns = P2;
			off:   
					if (L&LED9& !R) 
						ns = P1;			//shows three  state
							
					else if (LED1 & R & !L) 
						ns = P2;
											//shows three states
					else 
						ns = off;
		endcase

		//displays whether "P1" or "P2" player won the game.
		// else nothing is displayed
		if (P2 == ns)
			champ = 7'b0100100; 
		else if (P1 == ns) 
			champ = 7'b1111001;
		else 
			champ = 7'b1111111;

	end
	
	//sequential logic (DFF)
	always_ff @(posedge clk)
	begin
		if (reset)
			ps <= off;
		else
			ps <= ns;
	end	
endmodule


//Testbench for victory module. 
// Allows one to check that the correct output is displayed 

module victory_testbench();
	logic [6:0] champ;
	logic clk;
	logic reset;
	logic LED1, LED9;
	logic L, R;

	//instantiates victory
	victory dut (.champ, .clk, .reset, .LED9, .LED1, .L, .R);
	
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
		reset <= 1;											@(posedge clk);
															@(posedge clk);
		reset <= 0;											@(posedge clk);
															@(posedge clk);
		LED9 <= 1; 	LED1 <= 0; L <= 1; R <= 0;				@(posedge clk);
															@(posedge clk);
		LED9 <= 0; 	LED1 <= 1;								@(posedge clk);
															@(posedge clk);
		LED9 <= 1; 	LED1 <= 1;								@(posedge clk);
															@(posedge clk);
		LED1 <= 0; 	R <= 1;  								@(posedge clk);
															@(posedge clk);
		reset <= 1;											@(posedge clk);
															@(posedge clk);
		reset <= 0;											@(posedge clk);
															@(posedge clk);
		LED9 <= 0; 	LED1 <= 1; L <= 0; R <= 1;				@(posedge clk);
															@(posedge clk);
		LED9 <= 1;				 							@(posedge clk);
															@(posedge clk);
		LED9 <= 0; 	L <= 1;									@(posedge clk);
															@(posedge clk);
		$stop; 
	end 
endmodule