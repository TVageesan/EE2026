`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 01:00:20
// Design Name: 
// Module Name: counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter (
    input sixp25MHzCLOCK,
    input push_button,
    output reg stable_pb
);

    parameter DEBOUNCE_CYCLES = 12500;

    reg [31:0] debounce_counter = 0;
    reg button_state_reg = 0;

    always @(posedge sixp25MHzCLOCK) begin
        if (push_button == 1) begin
            if (debounce_counter < DEBOUNCE_CYCLES) begin
                debounce_counter <= debounce_counter + 1;
            end
        end else begin
            debounce_counter <= 0;
        end

        if (debounce_counter == DEBOUNCE_CYCLES) begin
            button_state_reg <= 1;
        end else begin
            button_state_reg <= 0;
        end
    end

    always @(posedge sixp25MHzCLOCK) begin
        stable_pb <= button_state_reg;
    end

endmodule