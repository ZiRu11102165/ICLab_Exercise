`timescale  1ns / 1ps
`include "RIM.v"
module tb_RIM;

// RIM Parameters
parameter PERIOD  = 10;


// RIM Inputs
reg   [7:0]  maze                          = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 1 ;
reg   in_valid                             = 0 ;

// RIM Outputs
wire  out_valid                            ;
wire  [2:0]  out_row                       ;
wire  [2:0]  out_col                       ;
reg [153:0] pattern [1:100];
reg [153:0] p;
reg [2:0] gt_row, gt_col, ans_row, ans_col; 
integer i, j, error, single_error, count, start_, end_;


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
    clk = 0;
    #10 rst_n = 0;
    #10 rst_n = 1;
    error = 0;
    single_error = 0;
    in_valid = 0;
    forever #(PERIOD/2)  clk=~clk;
end

always @(negedge clk) begin    
    if (!rst_n) begin
        count = 0;
        gt_row = 0;
        gt_col = 0;
    end
    else begin
        $readmemb("C:\\Users\\USER\\Desktop\\verilog_Exercise\\RIM\\Pattern.dat", pattern);
        #10
        for (i=1; i<100; i = i+1) begin
            p = pattern[i];
            @(negedge clk);
            in_valid = 1;
            maze = p[153:146];
            @(negedge clk);
            maze = p[145:138];
            @(negedge clk);
            maze = p[137:130];
            @(negedge clk);
            maze = p[129:122];
            @(negedge clk);
            maze = p[121:114];
            @(negedge clk);
            maze = p[113:106];
            @(negedge clk);
            maze = p[105:98];
            @(negedge clk);
            maze = p[97:90];
            @(negedge clk);
            in_valid = 0;
            maze = 8'bx;
            #370;
            @(negedge clk);
            @(negedge clk);
        end
    end
    $finish;
end

endmodule
