`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/17 18:20:05
// Design Name: Id and gm Calculator
// Module Name: Calc
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

    
module Calc(
    output reg [9:0]Calc_Id_out0, output reg [9:0]Calc_Id_out1, output reg [9:0]Calc_Id_out2, output reg [9:0]Calc_Id_out3, output reg [9:0]Calc_Id_out4, output reg [9:0]Calc_Id_out5,
    output reg [9:0]Calc_gm_out0, output reg [9:0]Calc_gm_out1, output reg [9:0]Calc_gm_out2, output reg [9:0]Calc_gm_out3, output reg [9:0]Calc_gm_out4, output reg [9:0]Calc_gm_out5, 
    input [2:0]Vgs0, input [2:0]Vgs1, input [2:0]Vgs2, input [2:0]Vgs3, input [2:0]Vgs4, input [2:0]Vgs5,
    input [2:0]Vds0, input [2:0]Vds1, input [2:0]Vds2, input [2:0]Vds3, input [2:0]Vds4, input [2:0]Vds5,
    input [2:0]W0, input [2:0]W1, input [2:0]W2, input [2:0]W3, input [2:0]W4, input [2:0]W5);
       
    always @(*) begin
        if ((Vgs0-1)>Vds0) begin
            Calc_Id_out0 = W0*(2*(Vgs0-1)*Vds0-Vds0*Vds0)/3;
            Calc_gm_out0 = 2*(W0*Vds0)/3;
        end
        else begin
            Calc_Id_out0 = (W0*(Vgs0-1)*(Vgs0-1))/3;
            Calc_gm_out0 = 2*(W0*(Vgs0-1))/3;
        end
    end

    always @(*) begin
        if ((Vgs1-1)>Vds1) begin
            Calc_Id_out1 = W1*(2*(Vgs1-1)*Vds1-Vds1*Vds1)/3;
            Calc_gm_out1 = (2*(W1*Vds1))/3;
        end
        else begin
            Calc_Id_out1 = (W1*(Vgs1-1)*(Vgs1-1))/3;
            Calc_gm_out1 = 2*(W1*(Vgs1-1))/3;
        end
    end

    always @(*) begin
        if ((Vgs2-1)>Vds2) begin
            Calc_Id_out2 = W2*(2*(Vgs2-1)*Vds2-Vds2*Vds2)/3;
            Calc_gm_out2 = 2*(W2*Vds2)/3;
        end
        else begin
            Calc_Id_out2 = (W2*(Vgs2-1)*(Vgs2-1))/3;
            Calc_gm_out2 = 2*(W2*(Vgs2-1))/3;
        end
    end
    

    always @(*) begin
        if ((Vgs3-1)>Vds3) begin
            Calc_Id_out3 = W3*(2*(Vgs3-1)*Vds3-Vds3*Vds3)/3;
            Calc_gm_out3 = 2*(W3*Vds3)/3;
        end
        else begin
            Calc_Id_out3 = (W3*(Vgs3-1)*(Vgs3-1))/3;
            Calc_gm_out3 = 2*(W3*(Vgs3-1))/3;
        end
    end

    always @(*) begin
        if ((Vgs4-1)>Vds4) begin
            Calc_Id_out4 = W4*(2*(Vgs4-1)*Vds4-Vds4*Vds4)/3;
            Calc_gm_out4 = 2*(W4*Vds4)/3;
        end
        else begin
            Calc_Id_out4 = (W4*(Vgs4-1)*(Vgs4-1))/3;
            Calc_gm_out4 = 2*(W4*(Vgs4-1))/3;
        end
    end

    always @(*) begin
        if ((Vgs5-1)>Vds5) begin
            Calc_Id_out5 = W5*(2*(Vgs5-1)*Vds5-Vds5*Vds5)/3;
            Calc_gm_out5 = 2*(W5*Vds5)/3;
        end
        else begin
            Calc_Id_out5 = (W5*(Vgs5-1)*(Vgs5-1))/3;
            Calc_gm_out5 = 2*(W5*(Vgs5-1))/3;
        end
    end
endmodule
    