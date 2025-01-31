`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/18 17:25:19
// Design Name: Choose SMC output
// Module Name: Choose
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
///////////////////////////////////////////////////////////////////////////////////

    
module Choose(
    output reg [9:0]out,
    input [1:0]mode,
    input [9:0]n0,
    input [9:0]n1, 
    input [9:0]n2, 
    input [9:0]n3, 
    input [9:0]n4, 
    input [9:0]n5
);
    always@ (*) begin
        case (mode) 
            2'b00: out <= n3 + n4 + n5;
            2'b01: out <= 3*n3 + 4*n4 + 5*n5;
            2'b10: out <= n0 + n1 + n2;
            2'b11: out <= 3*n0 + 4*n1 + 5*n2;
            default : out <= 0;
        endcase
    end
endmodule