`timescale  1ns / 1ps
`include "Calc.v"
module tb_Calc;

// Calc Inputs
reg   [2:0]  Vgs0                          = 0 ;
reg   [2:0]  Vgs1                          = 0 ;
reg   [2:0]  Vgs2                          = 0 ;
reg   [2:0]  Vgs3                          = 0 ;
reg   [2:0]  Vgs4                          = 0 ;
reg   [2:0]  Vgs5                          = 0 ;
reg   [2:0]  Vds0                          = 0 ;
reg   [2:0]  Vds1                          = 0 ;
reg   [2:0]  Vds2                          = 0 ;
reg   [2:0]  Vds3                          = 0 ;
reg   [2:0]  Vds4                          = 0 ;
reg   [2:0]  Vds5                          = 0 ;
reg   [2:0]  W0                            = 0 ;
reg   [2:0]  W1                            = 0 ;
reg   [2:0]  W2                            = 0 ;
reg   [2:0]  W3                            = 0 ;
reg   [2:0]  W4                            = 0 ;
reg   [2:0]  W5                            = 0 ;
reg   clk                                  = 0 ;
reg   reset                                = 1 ;

// Calc Outputs
wire  [9:0]  Calc_Id_out0                  ;
wire  [9:0]  Calc_Id_out1                  ;
wire  [9:0]  Calc_Id_out2                  ;
wire  [9:0]  Calc_Id_out3                  ;
wire  [9:0]  Calc_Id_out4                  ;
wire  [9:0]  Calc_Id_out5                  ;
wire  [9:0]  Calc_gm_out0                  ;
wire  [9:0]  Calc_gm_out1                  ;
wire  [9:0]  Calc_gm_out2                  ;
wire  [9:0]  Calc_gm_out3                  ;
wire  [9:0]  Calc_gm_out4                  ;
wire  [9:0]  Calc_gm_out5                  ;

Calc  u_Calc (
    .Vgs0                    ( Vgs0          [2:0] ),
    .Vgs1                    ( Vgs1          [2:0] ),
    .Vgs2                    ( Vgs2          [2:0] ),
    .Vgs3                    ( Vgs3          [2:0] ),
    .Vgs4                    ( Vgs4          [2:0] ),
    .Vgs5                    ( Vgs5          [2:0] ),
    .Vds0                    ( Vds0          [2:0] ),
    .Vds1                    ( Vds1          [2:0] ),
    .Vds2                    ( Vds2          [2:0] ),
    .Vds3                    ( Vds3          [2:0] ),
    .Vds4                    ( Vds4          [2:0] ),
    .Vds5                    ( Vds5          [2:0] ),
    .W0                      ( W0            [2:0] ),
    .W1                      ( W1            [2:0] ),
    .W2                      ( W2            [2:0] ),
    .W3                      ( W3            [2:0] ),
    .W4                      ( W4            [2:0] ),
    .W5                      ( W5            [2:0] ),

    .Calc_Id_out0            ( Calc_Id_out0  [9:0] ),
    .Calc_Id_out1            ( Calc_Id_out1  [9:0] ),
    .Calc_Id_out2            ( Calc_Id_out2  [9:0] ),
    .Calc_Id_out3            ( Calc_Id_out3  [9:0] ),
    .Calc_Id_out4            ( Calc_Id_out4  [9:0] ),
    .Calc_Id_out5            ( Calc_Id_out5  [9:0] ),
    .Calc_gm_out0            ( Calc_gm_out0  [9:0] ),
    .Calc_gm_out1            ( Calc_gm_out1  [9:0] ),
    .Calc_gm_out2            ( Calc_gm_out2  [9:0] ),
    .Calc_gm_out3            ( Calc_gm_out3  [9:0] ),
    .Calc_gm_out4            ( Calc_gm_out4  [9:0] ),
    .Calc_gm_out5            ( Calc_gm_out5  [9:0] )
);
/*
always @(*) begin
    if ((Vgs-1)>Vds1) begin
        Calc_Id_out = W*(2*(Vgs-1)*Vds-Vds*Vds)/3;
        Calc_gm_out = (2*(W*Vds))/3;
    end
    else begin
        Calc_Id_out = (W*(Vgs-1)*(Vgs-1))/3;
        Calc_gm_out = 2*(W*(Vgs-1))/3;
    end
end
*/
initial
begin

    // in = 1 ~ 7
    Vgs0 = 5; Vgs1 = 2; Vgs2 = 6; Vgs3 = 4; Vgs4 = 5; Vgs5 = 7;  
    Vds0 = 6; Vds1 = 6; Vds2 = 7; Vds3 = 2; Vds4 = 3; Vds5 = 6;  
    W0 = 7;     W1 = 7;   W2 = 3;   W3 = 1;   W4 = 4;   W5 = 6;
    // $display("Test 1 Parameter: Vgs0=0x%b, Vgs1=0x%b, Vgs2=0x%b, Vgs3=0x%b, Vgs4=0x%b, Vgs5=0x%b", Vgs0, Vgs1, Vgs2, Vgs3, Vgs4, Vgs5);
    // $display("Test 1 Parameter: Vds0=0x%b, Vds1=0x%b, Vds2=0x%b, Vds3=0x%b, Vds4=0x%b, Vds5=0x%b", Vds0, Vds1, Vds2, Vds3, Vds4, Vds5);
    // $display("Test 1 Parameter: W0=0x%b, W1=0x%b, W2=0x%b, W3=0x%b, W4=0x%b, W5=0x%b", W0, W1, W2, W3, W4, W5);
    #10
    $display("Test 1 gm Ans : gm0=%d, gm1=%d, gm2=%d, gm3=%d, gm4=%d, gm5=%d", Calc_gm_out0, Calc_gm_out1, Calc_gm_out2, Calc_gm_out3, Calc_gm_out4, Calc_gm_out5);
    $display("Test 1 Id Ans : Id0=%d, Id1=%d, Id2=%d, Id3=%d, Id4=%d, Id5=%d", Calc_Id_out0, Calc_Id_out1, Calc_Id_out2, Calc_Id_out3, Calc_Id_out4, Calc_Id_out5);
    
    // $display("");
    $finish;
end
endmodule
