`timescale  1ns / 1ps
`include "RIM.v"
`define pattern_path "C:\\Users\\USER\\Desktop\\verilog_Exercise\\RIM\\Pattern.dat"
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
reg [153:0] pattern [0:100];
reg [153:0] p;
reg [2:0] gt_row, gt_col, ans_row, ans_col; 
integer i, single_error;


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
    single_error = 0;
    in_valid = 0;
    forever #(PERIOD/2)  clk=~clk;
end

initial begin
    $readmemb(`pattern_path, pattern);
    rst_n = 0;
    #20 rst_n = 1; // 給予 reset 信號
    
    for (i=0; i<100; i = i+1) begin
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
        // @(posedge out_valid);
        @(out_col or out_col);
        if ((out_row!==p[89:87]) & (out_col!==p[44:42]))begin  //1
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[89:87], p[44:42]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[86:84]) & (out_col!==p[41:39]))begin  //2
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[86:84], p[41:39]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[83:81]) & (out_col!==p[38:36]))begin  //3
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[83:81], p[38:36]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[80:78]) & (out_col!==p[35:33]))begin  //4
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[80:78], p[35:33]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[77:75]) & (out_col!==p[32:30]))begin  //5
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[77:75], p[32:30]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[74:72]) & (out_col!==p[29:27]))begin  //6
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[74:72], p[29:27]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[71:69]) & (out_col!==p[26:24]))begin  //7
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[71:69], p[26:24]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[68:66]) & (out_col!==p[23:21]))begin  //8
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[68:66], p[23:21]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[65:63]) & (out_col!==p[20:18]))begin  //9
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[65:63], p[20:18]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[62:60]) & (out_col!==p[17:15]))begin  //10
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[62:60], p[17:15]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[59:57]) & (out_col!==p[14:12]))begin  //11
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[59:57], p[14:12]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[56:54]) & (out_col!==p[11:9]))begin  //12
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[56:54], p[11:9]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[53:51]) & (out_col!==p[8:6]))begin  //13
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[53:51], p[8:6]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[50:48]) & (out_col!==p[5:3]))begin  //14
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[50:48], p[5:3]);
            single_error = single_error + 1;
        end
        @(out_col or out_col);
        if ((out_row!==p[47:45]) & (out_col!==p[2:0]))begin  //15
            $display("out_row == %d , out_col ==%d", out_row, out_col);
            $display("out_row!== %d , out_col!==%d", p[47:45], p[2:0]);
            single_error = single_error + 1;
        end
        
        $display("single_error = %d", single_error);
        @(negedge out_valid);
        @(negedge clk);
        @(negedge clk);
    end

    $finish;
end


endmodule
