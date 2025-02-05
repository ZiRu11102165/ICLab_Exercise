`timescale  1ns / 1ps
`include "RIM.v"
module tb_RIM;

// RIM Parameters
parameter PERIOD  = 10;


// RIM Inputs
reg   [7:0]  maze                          = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   in_valid                             = 0 ;

// RIM Outputs
wire  out_valid                            ;
wire  [2:0]  out_row                       ;
wire  [2:0]  out_col                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

RIM  u_RIM (
    .maze                    ( maze       [7:0] ),
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .in_valid                ( in_valid         ),

    .out_valid               ( out_valid        ),
    .out_row                 ( out_row    [2:0] ),
    .out_col                 ( out_col    [2:0] )
);

initial
begin
    #10;
    rst_n  =  1;
    #10;
    maze = 8'b10000000; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b11110000; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01011111; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01011111; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01001111; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01110111; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01000011; in_valid=1; #10; in_valid=0; #10;
    maze = 8'b01110011; in_valid=1; #10; in_valid=0; #20;
    #270
    $finish;
end

endmodule