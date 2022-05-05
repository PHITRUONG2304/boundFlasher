module boundFlasher (flick, clk, rst, LEDs);
  input wire flick;
  input wire clk;
  input wire rst;
  output reg [15:0] LEDs;
  
  reg [2:0] state;
  reg [2:0] stateR;
  reg [15:0] ledTemp;
  
  reg flickFlag;
  
  always @(posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
      LEDs <= 16'b0;
    end
    else begin
      LEDs <= ledTemp;
    end
  end
  
  always @(*) begin
    case(state)
		3'b000: begin
			ledTemp = 16'b0;
		end
		3'b001: begin
			if (LEDs[5] != 1) begin
				ledTemp = (LEDs << 1) | 1'b1;
			end
		end
		3'b010: begin
			if (LEDs[0] != 0) begin
				ledTemp = (LEDs >> 1);
			end
		end
		3'b011: begin
			if (LEDs[10] != 1) begin
				ledTemp = (LEDs << 1) | 1'b1;
			end
		end
		3'b100: begin
			if (LEDs[5] != 0) begin
				ledTemp = (LEDs >> 1);
			end
		end
		3'b101: begin
			if (LEDs[15] != 1) begin
				ledTemp = (LEDs << 1) | 1'b1;
			end
		end
		3'b110: begin
			if (LEDs[0] != 0) begin
				ledTemp = (LEDs >> 1);
			end
		end
		default: begin
			ledTemp = 16'b0;
		end
		endcase
  end
  
  
  
  always @(posedge clk or negedge rst) begin
    if (rst == 1'b0) begin
      stateR <= 3'b000;
    end
    else begin
      stateR <= state;
    end
  end
  
  always @(*) begin
    if (rst == 1'b0) begin
      flickFlag = 1'b0;
    end
    else if (flick == 1'b1 && stateR == 3'b011 && LEDs[5] == 1 && LEDs[6] == 0) begin
      flickFlag = 1'b1;
    end
    else if (flick == 1'b1 && stateR == 3'b011 && LEDs[10] == 1 && LEDs[11] == 0) begin
      flickFlag = 1'b1;
    end    
    else if (flick == 1'b1 && stateR == 3'b101 && LEDs[5] == 1 && LEDs[6] == 0) begin
      flickFlag = 1'b1;
    end 
    else if (flick == 1'b1 && stateR == 3'b101 && LEDs[10] == 1 && LEDs[11] == 0) begin
      flickFlag = 1'b1;
    end
    else begin
      flickFlag = 1'b0;
    end
  end
  
  
  always @(*) begin
    if (rst == 1'b0) begin
      state = 3'b000;
    end
    else begin
    case (stateR)
      3'b000: begin //INITIAL
        if (flick == 1) begin
          state = 3'b001;
        end
      end
      
      3'b001: begin //STATE_1
        if (LEDs[5] == 1) begin
          state = 3'b010;
        end
      end
      
      3'b010: begin	//STATE_2
        if (LEDs[0] == 0) begin
          state = 3'b011;
        end
      end
      
      3'b011: begin //STATE_3
        if (flickFlag == 1'b1) begin
          state = 3'b010;
        end 
        else if (LEDs[10] == 1 && flickFlag == 1'b0 && state != 3'b010) begin
          state = 3'b100;
        end
      end
      
      3'b100: begin	//STATE_4
		  if (LEDs[5] == 0) begin
          state = 3'b101;
        end
      end
      
      3'b101: begin //STATE_5
        if (flickFlag == 1'b1) begin
          state = 3'b100;
        end 
        else if (LEDs[15] == 1 && flickFlag == 1'b0) begin
			 state = 3'b110;
        end
      end
      
      3'b110: begin //FINAL
		  if (LEDs[0] == 0) begin
          state = 3'b000;
        end
      end
      
      default: state = 3'b000;
    endcase
    end
  end
  

endmodule