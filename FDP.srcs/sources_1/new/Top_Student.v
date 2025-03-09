`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Roshni
//  STUDENT B NAME: Srinivasan Nandhitha Shree
//  STUDENT C NAME: Beverly
//  STUDENT D NAME: Thiruvarudchelvan Vageesan
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input basys_clk, output [7:0] JB, input btnU, input btnC, input btnD);

    wire created6p25megahz, created25Mhz;
    wire [31:0] m = 7;
    wire n = 1;
    wire reset = 0;
    wire fb, sending_pixels, sample_pix;
    wire [6:0] x;
    wire [5:0] y;
    reg [15:0] oled_data = 16'b00000_000000_00000;
    wire [12:0] pixel_index;

    reg [2:0] up_state = 0;
    reg [2:0] centre_state = 0;
    reg [2:0] down_state = 0;

    reg up_pb_prev = 0;
    reg centre_pb_prev = 0;
    reg down_pb_prev = 0;

    reg up_allow_change = 0;
    reg centre_allow_change = 0;
    reg down_allow_change = 0;

    wire up_stable_pb, centre_stable_pb, down_stable_pb;
    Clock(basys_clk, m, created6p25megahz);
    counter up_counter_inst (.stable_pb(up_stable_pb), .sixp25MHzCLOCK(created6p25megahz), .push_button(btnU));
    counter centre_counter_inst (.stable_pb(centre_stable_pb), .sixp25MHzCLOCK(created6p25megahz), .push_button(btnC));
    counter down_counter_inst (.stable_pb(down_stable_pb), .sixp25MHzCLOCK(created6p25megahz), .push_button(btnD));

    Pixel_Coordinates(pixel_index, x, y);
    Clock(basys_clk, n, created25Mhz);

    always @(posedge created25Mhz) begin
        if (btnU && !up_pb_prev) begin 
            up_allow_change <= 1;
        end else if (up_stable_pb) begin 
            up_allow_change <= 0;
        end
        up_pb_prev <= btnU;

      
        if (btnC && !centre_pb_prev) begin 
            centre_allow_change <= 1;
        end else if (centre_stable_pb) begin 
            centre_allow_change <= 0;
        end
        centre_pb_prev <= btnC;

        if (btnD && !down_pb_prev) begin 
            down_allow_change <= 1;
        end else if (down_stable_pb) begin 
            down_allow_change <= 0;
        end
        down_pb_prev <= btnD;
    end

    always @(posedge created25Mhz) begin
        oled_data = 16'b00000_000000_00000; 

        // Top square
        if (x >= 42 && x < 55 && y >= 2 && y < 15) begin 
            case (up_state)
                3'b000: oled_data = 16'b11111_111111_11111; // White
                3'b001: oled_data = 16'b11111_000000_00000; // Red
                3'b010: oled_data = 16'b00000_111111_00000; // Green
                3'b011: oled_data = 16'b00000_000000_11111; // Blue
                3'b100: oled_data = 16'b11111_101001_00000; // Orange
                3'b101: oled_data = 16'b00000_000000_00000; // Black
            endcase
        end

        // Centre square
        if (x >= 42 && x < 55 && y >= 17 && y < 30) begin
            case (centre_state)
                3'b000: oled_data = 16'b11111_111111_11111; // White
                3'b001: oled_data = 16'b11111_000000_00000; // Red
                3'b010: oled_data = 16'b00000_111111_00000; // Green
                3'b011: oled_data = 16'b00000_000000_11111; // Blue
                3'b100: oled_data = 16'b11111_101001_00000; // Orange
                3'b101: oled_data = 16'b00000_000000_00000; // Black
            endcase
        end

        // Down square
        if (x >= 42 && x < 55 && y >= 32 && y < 45) begin 
            case (down_state)
                3'b000: oled_data = 16'b11111_111111_11111; // White
                3'b001: oled_data = 16'b11111_000000_00000; // Red
                3'b010: oled_data = 16'b00000_111111_00000; // Green
                3'b011: oled_data = 16'b00000_000000_11111; // Blue
                3'b100: oled_data = 16'b11111_101001_00000; // Orange
                3'b101: oled_data = 16'b00000_000000_00000; // Black
            endcase
        end

        // Circle logic
        if (up_state == 3'b001 && centre_state == 3'b001 && down_state == 3'b001) begin // All red
            if (((x - 48) * (x - 48)) + ((y - 54) * (y - 54)) <= 42) begin 
                oled_data = 16'b11111_000000_00000; 
            end
        end else if (up_state == 3'b100 && centre_state == 3'b100 && down_state == 3'b100) begin // All orange
            if (((x - 48) * (x - 48)) + ((y - 54) * (y - 54)) <= 42) begin 
                oled_data = 16'b11111_101001_00000; 
            end
        end

        if (up_stable_pb && up_allow_change) begin
            up_state <= (up_state == 3'b101) ? 3'b000 : up_state + 3'b001;
        end
        if (centre_stable_pb && centre_allow_change) begin
            centre_state <= (centre_state == 3'b101) ? 3'b000 : centre_state + 3'b001;
        end
        if (down_stable_pb && down_allow_change) begin
            down_state <= (down_state == 3'b101) ? 3'b000 : down_state + 3'b001;
        end
    end
    Oled_Display(created6p25megahz, reset, fb, sending_pixels,
    sample_pix, pixel_index, oled_data, JB[0], JB[1], JB[3], JB[4], JB[5], JB[6],JB[7]);       
endmodule