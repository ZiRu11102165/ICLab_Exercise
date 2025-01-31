`timescale  1ns / 1ps
`include "Sort.v"
module tb_Sort;

// Sort Inputs
reg   [9:0]  Clac_out0                     = 0 ;
reg   [9:0]  Clac_out1                     = 0 ;
reg   [9:0]  Clac_out2                     = 0 ;
reg   [9:0]  Clac_out3                     = 0 ;
reg   [9:0]  Clac_out4                     = 0 ;
reg   [9:0]  Clac_out5                     = 0 ;

// Sort Outputs
wire  [9:0]  n0                            ;
wire  [9:0]  n1                            ;
wire  [9:0]  n2                            ;
wire  [9:0]  n3                            ;
wire  [9:0]  n4                            ;
wire  [9:0]  n5                            ;

Sort  u_Sort (
    .Clac_out0               ( Clac_out0  [9:0] ),
    .Clac_out1               ( Clac_out1  [9:0] ),
    .Clac_out2               ( Clac_out2  [9:0] ),
    .Clac_out3               ( Clac_out3  [9:0] ),
    .Clac_out4               ( Clac_out4  [9:0] ),
    .Clac_out5               ( Clac_out5  [9:0] ),

    .n0                      ( n0         [9:0] ),
    .n1                      ( n1         [9:0] ),
    .n2                      ( n2         [9:0] ),
    .n3                      ( n3         [9:0] ),
    .n4                      ( n4         [9:0] ),
    .n5                      ( n5         [9:0] )
);

initial
begin
    #1;
    Clac_out0 = 32; Clac_out1 = 19; Clac_out2 = 1; Clac_out3 = 25; Clac_out4 = 95; Clac_out5 = 1000;
    #1;
    $display("Sort 1 Ans: n0=%d, n1=%d, n2=%d, n3=%d, n4=%d, n5=%d", n0, n1, n2, n3, n4, n5);
    #1;
    Clac_out0 = 50; Clac_out1 = 677; Clac_out2 = 190; Clac_out3 = 5; Clac_out4 = 412; Clac_out5 = 862;
    #1;
    $display("Sort 2 Ans: n0=%d, n1=%d, n2=%d, n3=%d, n4=%d, n5=%d", n0, n1, n2, n3, n4, n5);
    #1;
    Clac_out0 = 350; Clac_out1 = 1000; Clac_out2 = 611; Clac_out3 = 31; Clac_out4 = 210; Clac_out5 = 801;
    #1;
    $display("Sort 3 Ans: n0=%d, n1=%d, n2=%d, n3=%d, n4=%d, n5=%d", n0, n1, n2, n3, n4, n5);
    $finish;
end

endmodule