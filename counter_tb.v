// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module counter_tb;

  // Inputs
  reg adj;
  reg sel;
  reg rst;
  reg pse;
  reg clk_2Hz;
  reg clk_1Hz;
  
  // Outputs
  wire [5:0] min;
  wire [5:0] sec;
  
  // Instantiate the counter module
  counter dut (
    .adj(adj),
    .sel(sel),
    .rst(rst),
    .pse(pse),
    .clk_2Hz(clk_2Hz),
    .clk_1Hz(clk_1Hz),
    .min(min),
    .sec(sec)
  );
  
  // Clock generation
    initial begin
      clk_1Hz = 0;
      forever #500000000 clk_1Hz = ~clk_1Hz;
  end
  initial begin
  	clk_2Hz = 0;
    forever #250000000 clk_2Hz = ~clk_2Hz;
  end
  
  initial
 	begin
    $dumpfile("waveform.vcd");
	$dumpvars(0, dut);
 end
  // Testbench logic
  initial begin
    // Reset the counter
    rst = 1;
    adj = 0;
    #10 rst = 0;
    
    // Wait for a few clock cycles
    #100;
        
    // Wait for 10 seconds
    #10000000000;
    // Stop the counter and check the time
    pse = 1;
    #100;
    pse = 0; // simulates button click
    #100;
    // should be 00:10
    $display("Current time: %d:%d", min, sec);
    
    sel = 0;
    adj = 1;
    // Wait for 10 seconds update minutes
    // should be 20:10
    #10000000000
    $display("Current time: %d:%d", min, sec); 
    sel = 1; // change to seconds
    // Wait for 10 seconds update seconds
    // should be 20:30
    #10000000000
    $display("Current time: %d:%d", min, sec); 
    #15000000000// wait 15 seconds should overflow to  20:00
    $display("Current time: %d:%d", min, sec);
    
    adj = 0; //go back to normal mode
    pse = 1;
   	#100;
    pse = 0; // simulates button click
    #15000000000 // wait 15 seconds should be 20:15
    $display("Current time: %d:%d", min, sec);
    // reset
    rst = 1;
    #10 
    rst = 0;
    $display("Current time: %d:%d", min, sec);
    #70000000000 // wait 70 seconds expect 1:10
    $display("Current time: %d:%d", min, sec);
    // End the simulation
    $finish;
  end
  
endmodule
