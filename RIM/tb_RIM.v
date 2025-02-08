/*
 * @info: --> Auto create header by korofileheader <--
 * @Author: Northern NOOB
 * @Mail: northsnoob@gmail.com
 * @Date: 2025-02-06 21:41
 * @LastEditors: Northern NOOB
 * @LastEditTime: 2025-02-07 02:30
 * @Version: default
 */
`timescale  10ps / 1ps
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
reg [2:0] gt_row, gt_col; 
wire [2:0] ans_row, ans_col;
integer i, j, error, single_error, count, start_, end_;


RIM  uut_RIM (
    .maze                    ( maze       [7:0] ),
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .in_valid                ( in_valid         ),

    .out_valid               ( out_valid        ),
    .out_row                 ( out_row    [2:0] ),
    .out_col                 ( out_col    [2:0] )
);

always
   #(PERIOD/2) clk=~clk;
reg timing_eligible;
initial
begin
    clk = 0;
    maze = 0;
    rst_n = 1;
    error = 0;
    single_error = 0;
    in_valid = 0;
    timing_eligible = 1;
    #(PERIOD*2) rst_n = 0;
    #(PERIOD*2) rst_n = 1;
    // forever #(PERIOD/2)  clk=~clk;
end


reg [7:0] inv_maze;
function [7:0] inv(input [7:0] in_data); begin
    inv[0] = in_data[7];
    inv[1] = in_data[6];
    inv[2] = in_data[5];
    inv[3] = in_data[4];
    inv[4] = in_data[3];
    inv[5] = in_data[2];
    inv[6] = in_data[1];
    inv[7] = in_data[0];
end
endfunction

integer map_row,k;
parameter map_max=153;
task set_maze;begin
    
    for (map_row = 0;map_row < 8;map_row = map_row + 1)begin
        @(negedge clk);
        in_valid = 1;
        for (k=0;k<8;k=k+1) 
            // maze[k] = p[map_max-(map_row*8)-k]; //153 146 is first
            maze[7-k] = p[map_max-(map_row*8)-k]; //原代碼 maze[k] = p[map_max-(map_row*8)-k]; 
        $display("row: %1d %b",map_row,inv(maze));
        // inv();
    end
    @(negedge clk);
    in_valid = 0;
    maze = 8'dx;
end
endtask
integer ans_i;
parameter row_max=89;
parameter col_max=44;
parameter col_min=0;
reg read_start;
task read_maze_ans;begin
    // $display("read_maze_ans:  %b",p[89:0]);
    read_start=1;
    for (ans_i = 0;ans_i < 15;ans_i = ans_i + 1)begin
        // $display("read_maze_ans:  %d,p=%b",row_max-(ans_i*3),p[row_max-(ans_i*3)-2]);
        // $display("read_maze_ans:  %d,p=%b",row_max-(ans_i*3),p[row_max-(ans_i*3)-2]);
        // $display("read_maze_ans:  %d,p=%b",row_max-(ans_i*3),p[row_max-(ans_i*3)-2]);

        gt_row[2] = p[row_max-(ans_i*3)];
        gt_row[1] = p[row_max-(ans_i*3)-1];
        gt_row[0] = p[row_max-(ans_i*3)-2];
        gt_col[2] = p[col_max-(ans_i*3)];
        gt_col[1] = p[col_max-(ans_i*3)-1];
        gt_col[0] = p[col_max-(ans_i*3)-2];
        // gt_col[2] = p[col_min+(ans_i*3)+2];
        // gt_col[1] = p[col_min+(ans_i*3)+1];
        // gt_col[0] = p[col_min+(ans_i*3)];
        // $display("read_maze_ans: gt_col[0] %d",gt_col[0]);

        @(posedge clk);
    end
    read_start=0;
end
endtask

reg match;

always @(*) begin
    if (ans_row == out_row && ans_col == out_col && timing_eligible)  // 檢查高 4 位元是否符合特定模式
        match = 1;
    else
        match = 0;
end
assign ans_row = (read_start)? gt_row:8'h00;
assign ans_col = (read_start)? gt_col:8'h00;
always@(negedge clk)
    if(match!=1)
        single_error=single_error+1;
parameter test_count = 100;
initial begin
    $readmemb("C:\\Users\\USER\\Desktop\\verilog_Exercise\\RIM\\Pattern.dat", pattern);
    read_start = 0;
    wait(!rst_n);
    wait(rst_n);
    error=0;
    single_error=0;
    #50;
    for (i=1; i <= test_count; i = i + 1) begin
        timing_eligible = 1;
        p = pattern[i];
        set_maze();
        for(j=0;j<200;j=j+1)begin :TIMING_TEST
            @(negedge clk);
            if (out_valid)
                j=200;
            if(j==199)
                timing_eligible = 0;
            // $display("run_loop  ;;;;");
        end
        read_maze_ans();
        @(negedge clk);
        if(single_error>0)begin
            error=error+1;
            single_error=0;
        end
        @(negedge clk);
    end
    $display("error %3d/%3d",error,test_count);
    #100 $stop;
end

endmodule