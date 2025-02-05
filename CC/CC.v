`timescale 1ps/1ps
module CC (
    clk, rst_n, in_valid_1, in_valid_2, 
    in_color, in_stripe, in_action, in_starting_pos,
    out_valid, out_score
);
    input clk, rst_n, in_valid_1, in_valid_2, in_stripe;
    input [5:0] in_starting_pos;
    input [2:0] in_color;
    input [1:0] in_action;
    output reg out_valid;
    output reg [6:0] out_score;

    integer in_count=0;
    reg [35:0] store_color;
    reg [3:0] store_stripe;
    reg [3:0] store_stripe_pos_x, store_stripe_pos_y;

    always@ (negedge clk ) begin 
        if (rst_n) begin
            if (in_valid_1 & (in_count<4)) begin
                //******** 特殊的條紋糖果只有四顆 ********//
                store_stripe_pos_x[in_count] <= in_starting_pos[3:5]; //條紋糖果放置的X位置
                store_stripe_pos_y[in_count] <= in_starting_pos[0:2]; //條紋糖果放置的Y位置
                store_stripe[in_count] <= in_stripe; //條紋糖果的類型 0:水平消除 1:垂直消除
                //******** 特殊的條紋糖果只有四顆 ********//
                store_color[in_count] <= in_color; //依照順序設定顏色
                in_count <= in_count + 1;
            end
            else if(in_valid_1 & (4<=in_count<36)) begin
                store_color[in_count] <= in_color; //依照順序設定顏色
                in_count <= in_count + 1;
            end
        end
        else begin
            out_valid <= 1'bx;
            out_score <= 7'bx;
        end
    end
endmodule