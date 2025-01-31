`timescale 1ns / 1ps
`include "Calc.v"
`include "Sort.v"
`include "Choose.v"
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/17 18:00:05
// Design Name: Supper MOSFET Calculator
// Module Name: SMC
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

module SMC(output reg [9:0]out,
           input [1:0] mode,
           input [2:0] Vgs0, Vgs1, Vgs2, Vgs3, Vgs4, Vgs5,
           input [2:0] Vds0, Vds1, Vds2, Vds3, Vds4, Vds5,
           input [2:0] W0, W1, W2, W3, W4, W5
           );
    wire [9:0]Id_n0, Id_n1, Id_n2, Id_n3, Id_n4, Id_n5, gm_n0, gm_n1, gm_n2, gm_n3, gm_n4, gm_n5 ;
    wire [9:0]gm_out, Id_out;
    wire [9:0] Calc_Id_out0, Calc_Id_out1, Calc_Id_out2, Calc_Id_out3, Calc_Id_out4, Calc_Id_out5;
    wire [9:0] Calc_gm_out0, Calc_gm_out1, Calc_gm_out2, Calc_gm_out3, Calc_gm_out4, Calc_gm_out5;

    Calc Calc1(
    .Calc_Id_out0(Calc_Id_out0), .Calc_Id_out1(Calc_Id_out1), .Calc_Id_out2(Calc_Id_out2), .Calc_Id_out3(Calc_Id_out3), .Calc_Id_out4(Calc_Id_out4), .Calc_Id_out5(Calc_Id_out5),
    .Calc_gm_out0(Calc_gm_out0), .Calc_gm_out1(Calc_gm_out1), .Calc_gm_out2(Calc_gm_out2), .Calc_gm_out3(Calc_gm_out3), .Calc_gm_out4(Calc_gm_out4), .Calc_gm_out5(Calc_gm_out5), 
    .Vgs0(Vgs0), .Vgs1(Vgs1), .Vgs2(Vgs2), .Vgs3(Vgs3), .Vgs4(Vgs4), .Vgs5(Vgs5), .Vds0(Vds0), .Vds1(Vds1), .Vds2(Vds2), .Vds3(Vds3), .Vds4(Vds4), .Vds5(Vds5),
    .W0(W0), .W1(W1), .W2(W2), .W3(W3), .W4(W4), .W5(W5));
    // always @(*) begin
    //     $display("vgs = %d, vds = %d, w = %d, id = %d, gm = %d,", Vds0, Vds0, W0, Calc_Id_out0, Calc_gm_out0);
    // end
    //將5個Id進行大至小的排序
    Sort sort_Id(
                .n0(Id_n0),
                .n1(Id_n1),
                .n2(Id_n2),
                .n3(Id_n3),
                .n4(Id_n4),
                .n5(Id_n5),
                . Clac_out0(Calc_Id_out0),
                . Clac_out1(Calc_Id_out1),
                . Clac_out2(Calc_Id_out2),
                . Clac_out3(Calc_Id_out3),
                . Clac_out4(Calc_Id_out4),
                . Clac_out5(Calc_Id_out5)
                );
    
    //將5個gm進行大至小的排序
    Sort sort_gm(
                .n0(gm_n0),
                .n1(gm_n1),
                .n2(gm_n2),
                .n3(gm_n3),
                .n4(gm_n4),
                .n5(gm_n5),
                . Clac_out0(Calc_gm_out0),
                . Clac_out1(Calc_gm_out1),
                . Clac_out2(Calc_gm_out2),
                . Clac_out3(Calc_gm_out3),
                . Clac_out4(Calc_gm_out4),
                . Clac_out5(Calc_gm_out5)
                );
    // always @(*) begin
    //     $display("Id n0 = %d, n1 = %d, n2 = %d, n3 = %d, n4 = %d, n5 = %d", Id_n0, Id_n1, Id_n2, Id_n3, Id_n4, Id_n5);
    //     $display("gm n0 = %d, n1 = %d, n2 = %d, n3 = %d, n4 = %d, n5 = %d", gm_n0, gm_n1, gm_n2, gm_n3, gm_n4, gm_n5);
    // end
    //根據Mode計算gm_total輸出
    Choose choose_gm(
    .out(gm_out),
    .mode(mode),
    .n0(gm_n0),
    .n1(gm_n1), 
    .n2(gm_n2), 
    .n3(gm_n3), 
    .n4(gm_n4), 
    .n5(gm_n5)
     );
    
    //根據Mode計算Id_total輸出
    Choose choose_Id(
    .out(Id_out),
    .mode(mode),
    .n0(Id_n0),
    .n1(Id_n1), 
    .n2(Id_n2), 
    .n3(Id_n3), 
    .n4(Id_n4), 
    .n5(Id_n5)
    );
    always@(*) begin
        // 判斷輸出甚麼
        case (mode) 
            2'b00: out = gm_out;
            2'b01: out = Id_out;
            2'b10: out = gm_out;
            2'b11: out = Id_out;
            default : out = 0;
        endcase
    end

endmodule
