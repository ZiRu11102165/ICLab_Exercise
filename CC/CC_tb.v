`timescale  1ns / 1ps

module tb_CC;

// CC Parameters
parameter PERIOD  = 10;
parameter TEST_NUM = 0;

// CC Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   in_valid_1                           = 0 ;
reg   in_valid_2                           = 0 ;
reg   in_stripe                            = 0 ;
reg   [5:0]  in_starting_pos               = 0 ;
reg   [2:0]  in_color                      = 0 ;
reg   [1:0]  in_action                     = 0 ;

// CC Outputs
wire  out_valid                            ;
wire  [6:0]  out_score                     ;

reg [107:0]pattern_color [0:0];
reg [23:0]pattern_pos [0:0];
reg [3:0]pattern_type [0:0];

integer i, time_count;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  0;
end

CC  u_CC (
    .clk                     ( clk                    ),
    .rst_n                   ( rst_n                  ),
    .in_valid_1              ( in_valid_1             ),
    .in_valid_2              ( in_valid_2             ),
    .in_stripe               ( in_stripe              ),
    .in_starting_pos         ( in_starting_pos  [5:0] ),
    .in_color                ( in_color         [2:0] ),
    .in_action               ( in_action        [1:0] ),

    .out_valid               ( out_valid              ),
    .out_score               ( out_score        [6:0] )
);

initial
begin
    $readmemb("Candy_Crush_color.dat", pattern_color);
    $readmemb("Candy_Crush_position.dat", pattern_pos);
    $readmemb("Candy_Crush_type.dat", pattern_type);
    #10 rst_n  =  1;
    for (i=0; i<36;i=i+1) begin
        // in_color = pattern_color[2:0];
        @(negedge clk);

    end

    
    $finish;
end

endmodule