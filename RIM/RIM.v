`timescale 1ns / 1ps

module RIM(
    output reg out_valid,
    output reg [2:0]out_row,
    output reg [2:0]out_col,
    input [7:0]maze,
    input clk,
    input rst_n,
    input in_valid
);
    /* 建立FSM */
    parameter[1:0] IDLE = 0, SEARCH = 1, DONE = 2;
    integer in_count, out_count, i;
    reg [7:0] store_maze [0:7];
    reg[1:0]Q, Q_NEXT;
    reg [2:0] now_row, now_col;
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
                if(!in_valid & in_count>7) Q_NEXT = SEARCH;
                else Q_NEXT = IDLE;
            SEARCH:
                if (!(now_row==7 & now_col==0)) Q_NEXT = SEARCH;
                else Q_NEXT = DONE;
            DONE:
                if (out_count<14) Q_NEXT = DONE;
                else Q_NEXT = IDLE;
            default:
                Q_NEXT = IDLE;
        endcase
    end
    always@(posedge clk or negedge rst_n)begin
        if (!rst_n) begin
            in_count <= 0;
            out_row <= 0;
            out_col <= 0;
            out_count <= 0;
            back_flag <= 0;
            now_col <= 7;
            now_row <= 0;
            out_valid <= 0;
            count_fold <= 0;
            count_ans <= 0;
        end
        else begin
            case(Q)
                IDLE: begin 
                    in_count <= 0;
                    out_row <= 0;
                    out_col <= 0;
                    out_count <= 0;
                    back_flag <= 0;
                    now_col <= 7;
                    now_row <= 0;
                    out_valid <= 0;
                    count_fold <= 0;
                    count_ans <= 0;
                    // for (i = 0; i < 15; i = i + 1) begin
                    //     store_ans_row[i] <= 3'b000; // 設為 0
                    //     store_ans_col[i] <= 3'b000;
                    // end
                    // for (i = 0; i < 8; i = i + 1) begin
                    //     store_maze[i] <= 8'b0000_0000; // 設為 0
                    // end
                    
                    /* 輸入 8 clock 的 maze 使迷宮變成 8x8 */
                    if (!rst_n) begin
                        in_count <= 0;
                    end
                    else begin
                        if (in_valid)begin
                            store_maze[in_count] <= maze;
                            in_count <= in_count + 1;
                        end
                        else in_count <= 0;
                    end
                end
                SEARCH: begin
                    store_ans_row[count_ans] <= now_row;
                    store_ans_col[count_ans] <= now_col;
                    if (!back_flag) begin
                        if ((now_row + 1 < 8) & (store_maze[now_row + 1][now_col])) begin 
                            now_row <= now_row + 1;
                        end
                        else if ((now_col - 1 >= 0) & (store_maze[now_row][now_col - 1])) begin
                            now_col <= now_col - 1;
                        end
                        else begin
                            back_flag <= 1;
                            if (count_fold > 0)begin
                                now_row <= store_fold_row[count_fold - 1];
                                now_col <= store_fold_col[count_fold - 1];
                                count_fold <= count_fold - 1;
                            end
                        end
                        if (now_row<8 & now_col>0 & store_maze[now_row+1][now_col] & store_maze[now_row][now_col-1])begin
                            store_fold_row[count_fold] <= now_row;
                            store_fold_col[count_fold] <= now_col;
                            count_fold <= count_fold + 1;
                        end
                    end
                    else begin
                        if ((now_col - 1 >= 0) & (store_maze[now_row][now_col - 1])) begin
                            now_col <= now_col - 1;
                            back_flag <= 0;
                        end
                        
                    end
                    if (back_flag) begin
                        count_ans <= count_ans - (store_ans_row[count_ans - 1] - now_row) - (now_col - store_ans_col[count_ans - 1]);
                    end
                    else count_ans <= count_ans + 1;
                end

                DONE: begin
                    out_valid <= 1;
                    out_row <= store_ans_row[out_count];
                    out_col <= store_ans_col[out_count];
                    out_count <= out_count + 1; 
                end
            endcase
        end
    end
endmodule
