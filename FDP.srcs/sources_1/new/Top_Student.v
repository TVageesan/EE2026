`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input basys_clock, input btnC, output [7:0] JB);

 wire CLOCK_6p25; 
 wire fb, sending_p, sampleP;
 wire [15:0] oled_c;
 wire [6:0] x;
 wire [5:0] y;

 Clock clk (basys_clock, 7, CLOCK_6p25);
 
 Task_C taskC (basys_clock, btnC, x, y, oled_c);
  
 Display display (basys_clock, oled_c , x, y, JB);
            


endmodule