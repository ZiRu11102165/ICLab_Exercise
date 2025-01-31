`timescale  1ns / 1ps
`include "Choose.v"
module tb_Choose;

// Choose Inputs
reg   [1:0]  mode                          = 0 ;
reg   [9:0]  n0                            = 0 ;
reg   [9:0]  n1                            = 0 ;
reg   [9:0]  n2                            = 0 ;
reg   [9:0]  n3                            = 0 ;
reg   [9:0]  n4                            = 0 ;
reg   [9:0]  n5                            = 0 ;

// Choose Outputs
wire  [9:0]  out                           ;

Choose  u_Choose (
    .mode                    ( mode  [1:0] ),
    .n0                      ( n0    [9:0] ),
    .n1                      ( n1    [9:0] ),
    .n2                      ( n2    [9:0] ),
    .n3                      ( n3    [9:0] ),
    .n4                      ( n4    [9:0] ),
    .n5                      ( n5    [9:0] ),

    .out                     ( out   [9:0] )
);

initial
begin
    mode = 2'b00; n0 = 14; n1 = 30; n2 = 3; n3 = 11; n4 = 1; n5 = 4; 
    #1;
    $display("%d", out);
    #1;
    mode = 2'b01; n0 = 14; n1 = 30; n2 = 3; n3 = 11; n4 = 1; n5 = 4; 
    #1;
    $display("%d", out);
    #1;
    mode = 2'b10; n0 = 14; n1 = 30; n2 = 3; n3 = 11; n4 = 1; n5 = 4; 
    #1;
    $display("%d", out);
    #1;
    mode = 2'b11; n0 = 14; n1 = 30; n2 = 3; n3 = 11; n4 = 1; n5 = 4; 
    #1;
    $display("%d", out);
    $finish;
end

endmodule