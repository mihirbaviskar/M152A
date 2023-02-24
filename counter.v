`timescale 1ns / 1ps
module counter(
	//INPUTS
	adj,
	sel,
	rst,
	pse,
	clk_2Hz,
	clk_1Hz,
	//OUTPUTS
	min,
	sec
	);
	
	//INPUTS
	input adj;
	input sel; 
	input rst; 
	input pse; 
	input clk_2Hz;
	input clk_1Hz;
	//OUTPUTS	
	output reg [5:0] min;
	output reg [5:0] sec;
	//REGISTERS
	reg pause;
  
	initial begin
		//OUTPUTS
		min = 0;
		sec = 0;
		//REGISTERS
		pause = 0;
	end
  
	always @(posedge pse) begin
		pause = ~pause;
	end
	
	reg clk_mode;
	
  	always@(*) begin
		if(adj == 1) begin
			clk_mode = clk_2Hz;
		end
		else begin
			clk_mode = clk_1Hz;
		end
	end
	
	always @(posedge rst or posedge clk_mode) begin
		if (rst == 1) begin
			min = 5'b00000;
			sec = 0;
		end
		
		if (adj == 0 && pause == 0) begin
			if (sec != 59) begin
				sec = sec + 1'b1;
			end
			else begin
				sec = 0;
				min = min + 1'b1;
			end
		end
		else if (adj == 1) begin
			if (sel == 0) begin
				if (min != 59) begin
					min = min + 1'b1;
				end
				else begin
					min = 0;
				end
			end
			else begin
				if (sec != 59) begin
					sec = sec + 1'b1;
				end
				else begin
					sec = 0;
				end
			end
		end
	end
endmodule
