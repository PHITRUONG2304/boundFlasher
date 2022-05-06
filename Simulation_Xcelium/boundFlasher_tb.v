module boundFlasher_tb;
  
  parameter HALF_CYCLE = 5;
  parameter CYCLE = HALF_CYCLE * 2;
  
  reg flick, clk, rst;
  wire [15:0] led;
  
  boundFlasher dut(.flick(flick), .clk(clk), .rst(rst), .LEDs(led));
    
  //generate clock
  always begin
    clk = 1'b0;
    #HALF_CYCLE clk = 1'b1;
    #HALF_CYCLE;
  end
  
  initial begin
    rst = 0;		// second 0
    flick = 0; 		// second 0
    #2 rst = 1; 	// second 2

	 //INITIAL
	 //STATE_1: 60
	 //STATE_2: 60
	 //STATE_3: 110
	 //STATE_4: 60
	 //STATE_5: 110
	 //FINAL: 160
	 
    // Test case :
    #5 flick = 1;	// second 7		(Testcase 1) Normal flow
    #3 flick = 0;	// second 10
	
    #580 flick = 1; // second 590	(Testcase 6) Flick signal to repeat the process
    #3 flick = 0;	// second 593
	 
	 #173 flick = 1; // second 766 (Testcase 2) Flick signal at L5 in state 3
	 #3 flick = 0;
	 
	 #139 flick = 1; //second 908 (Testcase 8) Flick signal at between L5 and L10 in state 3
	 #3 flick = 0;
	 
	 #25 flick = 1; // second 936 (Testcase 3) Flick signal at L10 in state 3
	 #3 flick = 0;
	 
	 #288 flick = 1; //second 1227 (Testcase 4) Flick signal at L5 in state 5
    #3 flick = 0;
	 
	 #70 flick = 1; //second 1300 (Testcase 5) Flick signal at L10 in state 5
	 #3 flick = 0;
	 
	 #343 flick = 1; // second 1646	(Testcase 6) Flick signal to repeat the process
	 #3 flick = 0;
	 
	 #100 flick = 1; // second 1749 (Testcase 7) Flick signal at any time slot (not kickback point in turning off leds state)
	 #3 flick = 0;
	 
	 #100 rst = 0; // second 1852 (Testcase 9) Reset signal at any time slot
	 #3 rst = 1;
	 
	 
	 #3 flick = 1; //second 1858 (Testcase 6) Flick signal to repeat the process
	 #3 flick = 0;
	 
	 #55 flick = 1; //second 1916 (Testcase 10) Flick signal at initial state
	 #3 flick = 0;
	 
	 #167 rst = 0; flick = 1; // second 2086 (Testcase 11) Reset signal with flick signal at kickback point in turning off leds state
	 #3 flick = 0;
	 #3 rst = 1;

    //////////////////////////////  
    #(CYCLE*45) $finish;
  end
  
  // To see waveform in online EDA playground only
//  initial begin
//    $dumpfile("debug.vcd");
//    $dumpvars;
//  end
  /////

initial begin
    $recordfile("waves");
    $recordvars("depth=0", boundFlasher_tb);
end

endmodule