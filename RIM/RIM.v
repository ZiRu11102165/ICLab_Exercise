`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/12/23 14:11:51
// Design Name: Rat in a Maze
// Module Name: RIM
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

module RIM(
    output reg out_valid,
    output reg [2:0]out_row,
    output reg [2:0]out_col,
    input [7:0]maze,
    input clk,
    input rst_n,
    input in_valid
);
    reg [7:0] store_maze [0:7];
    integer in_count=0;
    integer i, j;
    reg maze_done_flag;

    /* 輸入 8 clock 的 maze 使迷宮變成 8x8 */
    always@ (posedge clk or negedge rst_n) begin 
        if (in_valid & (in_count<8)) begin
            store_maze[in_count] <= maze;
            in_count <= in_count + 1;
        end
    end
    always @(*) begin
        maze_done_flag <= (store_maze[7] > 0 )? 1:0;
    end
    /* 建立FSM */
    parameter[1:0] IDLE = 0, SEARCH = 1, DONE = 2;
    reg[1:0]Q, Q_NEXT;
    reg [2:0] now_row, now_col, store_row, store_col, next_row, next_col;
    reg [2:0] store_fold_row [0:8];
    reg [2:0] store_fold_col [0:8];
    reg [2:0] store_ans_row [0:14];
    reg [2:0] store_ans_col [0:14];
    reg back_flag;
    reg [3:0] count_fold;
    reg [3:0] count_ans;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= IDLE;  // 異步重置至 IDLE
        else
            Q <= Q_NEXT;
    end

    always@(*)begin
        case(Q)
            IDLE:
                if(maze_done_flag & !in_valid) Q_NEXT = SEARCH;
                else Q_NEXT = IDLE;
            SEARCH:
                if (!(now_row==7 & now_col==0)) Q_NEXT = SEARCH;
                else Q_NEXT = DONE;
            DONE:
                Q_NEXT = DONE;
            default:
                Q_NEXT = IDLE;
        endcase
    end
    always@(posedge clk or negedge rst_n)begin
        case(Q)
            IDLE: begin 
                back_flag <= 0;
                now_col <= 7;
                now_row <= 0;
                count_fold <= 0;
                count_ans <= 0;
            end
            SEARCH: begin
                $display("目前位置[%d][%d] ", now_row, now_col);
                store_ans_row[count_ans] <= now_row;
                store_ans_col[count_ans] <= now_col;
                $display("count_ans = %d", count_ans);
                if (!back_flag) begin
                    if ((now_row + 1 < 8) & (store_maze[now_row + 1][now_col])) begin 
                        // $display(" 勞鼠往下走了! 1");
                        now_row <= now_row + 1;
                    end
                    else if ((now_col - 1 >= 0) & (store_maze[now_row][now_col - 1])) begin
                        // $display(" 勞鼠往右走了! 2");
                        now_col <= now_col - 1;
                    end
                    else begin
                        // $display(" 勞鼠沒路走了! 3");
                        back_flag <= 1;
                        if (count_fold > 0)begin
                            now_row <= store_fold_row[count_fold - 1];
                            now_col <= store_fold_col[count_fold - 1];
                            count_fold <= count_fold - 1;
                        end
                        count_ans <= count_ans - (now_row - store_fold_row[count_fold - 1]) - (store_fold_col[count_fold - 1] - now_col);
                        $display("count_ans = %d - (%d -%d) - (%d -%d)", count_ans, now_row, store_fold_row[count_fold - 1], store_fold_col[count_fold - 1], now_col);
                    end
                    if (now_row<8 & now_col>0 & store_maze[now_row+1][now_col] & store_maze[now_row][now_col-1])begin
                        // $display(" 勞鼠走到岔路了! 岔路位置[%d][%d] ", now_row, now_col);
                        store_fold_row[count_fold] <= now_row;
                        store_fold_col[count_fold] <= now_col;
                        count_fold <= count_fold + 1;
                    end
                end
                else begin
                    if ((now_col - 1 >= 0) & (store_maze[now_row][now_col - 1])) begin
                        // $display(" 勞鼠往右走了! 4");
                        now_col <= now_col - 1;
                        back_flag <= 0;
                    end
                    
                end
                count_ans <= count_ans + 1;
            end

            DONE: begin
                if (!store_maze[0][7]) begin
                    $display(" 左上角為0! ");
                    out_valid <= 0;
                    out_row <= 0;
                    out_col <= 0;
                end
                else begin 
                    $display(" 走到終點! ");
                    out_valid <= 1;
                    for (i = 0; i <= 15; i = i+1) begin
                        $display("store_ans_row[%d] ", store_ans_row[i]);
                        $display("store_ans_col[%d] ", store_ans_col[i]);
                    end
                end
            end
        endcase
    end
endmodule
