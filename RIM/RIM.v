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
        // $display("61 maze_done_flag = %d", maze_done_flag);
        // $display("store_maze[0] = %d", store_maze[0]);
        // $display("store_maze[1] = %d", store_maze[1]);
        // $display("store_maze[2] = %d", store_maze[2]);
        // $display("store_maze[3] = %d", store_maze[3]);

        // $display("store_maze[4] = %d", store_maze[4]);
        // $display("store_maze[5] = %d", store_maze[5]);
        // $display("store_maze[6] = %d", store_maze[6]);
        // $display("store_maze[7] = %d", store_maze[7]);
        
        maze_done_flag <= (store_maze[7] > 0 )? 1:0;
    end
    /* 建立FSM */
    parameter[1:0] IDLE = 0, SEARCH = 1, DONE = 3;
    reg[1:0]Q, Q_NEXT;
    reg [2:0] now_row, now_col, store_row, store_col, next_row, next_col;
    reg next_valid_flag, try_other_flag, check_end_flag;
    
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
                if (next_valid_flag) Q_NEXT = SEARCH;
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
                // $display("91 maze_done_flag = %d, store_maze[0][7] = %d", maze_done_flag, store_maze[0][7]);
                next_valid_flag <= (maze_done_flag & store_maze[0][7])? 1 : 0;
                try_other_flag <= 0;
                now_col <= 7;
                now_row <= 0;
            end
            SEARCH: begin
                // $display("97 maze_done_flag = %d", maze_done_flag);
                $display("目前位置[%d][%d] ", now_row, now_col);
                if (next_valid_flag & maze_done_flag & store_maze[now_row][now_col]) begin
                    if (!try_other_flag) begin
                        if ((now_row + 1 < 8) & (store_maze[now_row + 1][now_col])) begin 
                            $display(" 勞鼠往下走了! ");
                            now_row <= now_row + 1;
                            now_col <= now_col;
                            next_valid_flag <= 1;
                        end
                        else if ((now_col - 1 > 0) & (store_maze[now_row][now_col - 1])) begin
                            $display(" 勞鼠往右走了! ");
                            now_row <= now_row;
                            now_col <= now_col - 1;
                            next_valid_flag <= 1;
                        end
                        else begin
                            $display(" 勞鼠沒路走了! ");
                            next_valid_flag <= 0;
                        end
                    end
                    else begin
                        if ((now_col - 1 > 0) & (store_maze[now_row][now_col - 1])) begin
                            $display(" 勞鼠往右走了! ");
                            now_row <= now_row;
                            now_col <= now_col - 1;
                            next_valid_flag <= 1;
                        end
                        else if ((now_row + 1 < 8) & (store_maze[now_row + 1][now_col])) begin 
                            $display(" 勞鼠往下走了! ");
                            now_row <= now_row + 1;
                            now_col <= now_col;
                            next_valid_flag <= 1;
                        end
                        else begin
                            $display(" 勞鼠沒路走了! ");
                            next_valid_flag <= 0;
                        end
                    end
                end
                else next_valid_flag <= 0;
                
                try_other_flag <= (store_maze[now_row+1][now_col] & store_maze[now_row][now_col-1])? 1 : 0;
                if (try_other_flag) begin
                    $display(" 勞鼠走到岔路了! 岔路位置[%d][%d]", now_row, now_col);
                    store_row <= now_row;
                    store_col <= now_col;
                end
                if (!next_valid_flag & try_other_flag) begin
                    $display(" 勞鼠要返回岔路了! ");
                    now_row <= store_row;
                    now_col <= store_col;
                end
            end

            DONE: begin
                next_valid_flag <= 0;
                try_other_flag <= 0;
                if (!store_maze[0][7]) begin
                    $display(" 左上角為0! ");
                    out_valid <= 0;
                    out_row <= 0;
                    out_col <= 0;
                end
                else if (!next_valid_flag & now_row!=7 & now_col!=0) begin
                    $display(" 沒有走到終點! ");
                    out_valid <= 0;
                end
                else begin 
                    $display(" 走到終點啦! ");
                    out_valid <= 1;
                end
            end
        endcase
    end

endmodule