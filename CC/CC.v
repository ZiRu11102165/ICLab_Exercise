`timescale 1ns/1ns
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

    integer i;
    reg [5:0] in_count, x_count, y_count;
    reg [3:0] in_count_2;
    reg [5:0] score_count;
    reg [6:0] tmp_score_1, tmp_score_2, tmp_score_3, tmp_score;
    reg [5:0] now_pos;
    reg [5:0] BUILD_count;
    reg [2:0] Q,Q_next;
    reg [3:0] store_color [0:35];
    reg [3:0] tmp_record [0:35];
    reg [1:0] store_stripe [0:35];
    reg [1:0] stort_action [0:9];
    reg [5:0] stort_action_pos [0:9];
    reg [2:0] re_bulid;

    parameter IDLE=0, BUILD=1, CHECK_LINE_RL=2, CHECK_LINE_UD=3, CHECK_STRIPE_CANDY=4, SCORE=5, ACTION=6, FINAL=7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= IDLE;
        else Q <= Q_next;
    end
    reg start, flag_remove_7self, first_stripe;  
    reg [3:0]action_count;
    always @(*) begin
        case(Q)
            IDLE:   // 0
                if (BUILD_count == 45) Q_next = CHECK_LINE_RL;
                else Q_next = IDLE;
            // BUILD:  // 1
            //     if(BUILD_count == 45) Q_next = CHECK_LINE_RL;
            //     else Q_next = BUILD;
            CHECK_LINE_RL:  // 2
                if (x_count == 6) Q_next = CHECK_LINE_UD;
                else Q_next = CHECK_LINE_RL;
            CHECK_LINE_UD:  // 3
                if (x_count == 30) Q_next = CHECK_STRIPE_CANDY;
                else Q_next = CHECK_LINE_UD;
            CHECK_STRIPE_CANDY: // 4
                if (y_count == 37) Q_next = SCORE;
                else Q_next = CHECK_STRIPE_CANDY;
            SCORE:  // 5
                if (action_count < 10 & score_count == 18) Q_next = ACTION;
                else if (action_count == 10 & score_count == 18) Q_next = FINAL;
                else Q_next = SCORE;
            ACTION: // 6
                if (action_count < 10) Q_next = CHECK_LINE_RL;
                else Q_next = ACTION;
            FINAL:  // 7
                // if (out_valid == 1 ) Q_next = IDLE; 
                // else Q_next = FINAL;
                Q_next = IDLE;
            default :
                Q_next = IDLE;
        endcase
        
    end

    always@ (posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            start <= 0;
            out_valid <= 0;
            out_score <= 0;
        end
        else begin
            case (Q) 
                IDLE: begin
                    if (start == 0) begin
                        out_valid <= 0;
                        out_score <= 0;
                        in_count <= 0;
                        in_count_2 <= 0;
                        x_count <= 0;
                        y_count <= 1;
                        score_count <= 0;
                        now_pos <= 0;
                        re_bulid <= 0;
                        flag_remove_7self <= 0;
                        BUILD_count <= 0;
                        tmp_score_1 <= 0;
                        tmp_score_2 <= 0;
                        tmp_score_3 <= 0;
                        tmp_score <= 0;
                        first_stripe <= 0;
                        action_count <= 0;
                        for (i = 0; i < 36; i = i + 1) begin
                            store_color[i]  = 3'b000;
                        end
                        for (i = 0; i < 36; i = i + 1) begin
                            tmp_record[i]   = 4'b0000;
                        end
                        for (i = 0; i < 36; i = i + 1) begin
                            store_stripe[i] = 2'b00;
                        end
                        for (i = 0; i < 10; i = i + 1) begin
                            stort_action[i]  = 2'b00;
                        end
                        for (i = 0; i < 10; i = i + 1) begin
                            stort_action_pos[i]  = 5'b0_0000;
                        end
                        start <= 1;
                    end
                    else begin
                        if (BUILD_count < 46)begin
                            if (in_valid_1)begin
                                store_color[in_count] <= in_color; //依照順序設定顏色
                                if(in_count < 4) begin
                                    //******** 特殊的條紋糖果只有四顆 ********//
                                    store_stripe[in_starting_pos[5:3]*6 + in_starting_pos[2:0]] <= in_stripe + 1;    //糖果的類型 0:一般 1:水平消除 2:垂直消除
                                    //******** 特殊的條紋糖果只有四顆 ********//
                                end
                                in_count <= in_count + 1;
                                BUILD_count <= BUILD_count + 1;
                            end
                            else if (in_valid_2) begin
                                stort_action[in_count_2] <= in_action;
                                stort_action_pos [in_count_2] <= in_starting_pos[5:3]*6 + in_starting_pos[2:0];
                                in_count_2 <= in_count_2 + 1;
                                BUILD_count <= BUILD_count + 1;
                            end
                        end
                    end
                    
                    
                end
                CHECK_LINE_RL:begin
                    if (y_count < 5)begin
                        if ((store_color[y_count + 6*(x_count) - 1] !== 15 ) & (store_color[y_count + 6*(x_count)] !== 15) & (store_color[y_count + 6*(x_count) +1] !== 15)) begin
                            if ((store_color[y_count + 6*x_count - 1] == store_color[y_count + 6*x_count]) & (store_color[y_count + 6*x_count - 1] == store_color[y_count + 6*x_count + 1]) & (store_color[y_count + 6*x_count] == store_color[y_count + 6*x_count + 1])) begin
                                tmp_record[y_count + 6*x_count - 1] <= store_color[y_count + 6*x_count - 1] + 8; 
                                tmp_record[y_count + 6*x_count]     <= store_color[y_count + 6*x_count ] + 8; 
                                tmp_record[y_count + 6*x_count + 1] <= store_color[y_count + 6*x_count + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*x_count - 1] < 6) tmp_record[y_count + 6*x_count - 1] <= store_color[y_count + 6*x_count - 1]; 
                                if (tmp_record[y_count + 6*x_count    ] < 6) tmp_record[y_count + 6*x_count]     <= store_color[y_count + 6*x_count]; 
                                if (tmp_record[y_count + 6*x_count + 1] < 6) tmp_record[y_count + 6*x_count + 1] <= store_color[y_count + 6*x_count + 1]; 
                            end
                        end
                        if ((store_color[y_count + 6*(x_count + 1) - 1] !== 15 ) & (store_color[y_count + 6*(x_count + 1)] !== 15) & (store_color[y_count + 6*(x_count + 1) +1] !== 15)) begin
                            if ((store_color[y_count + 6*(x_count + 1) - 1] == store_color[y_count + 6*(x_count + 1)]) & (store_color[y_count + 6*(x_count + 1) - 1] == store_color[y_count + 6*(x_count + 1) + 1]) & (store_color[y_count + 6*(x_count + 1)] == store_color[y_count + 6*(x_count + 1) + 1])) begin
                                tmp_record[y_count + 6*(x_count + 1) - 1] <= store_color[y_count + 6*(x_count + 1) - 1] + 8; 
                                tmp_record[y_count + 6*(x_count + 1)]     <= store_color[y_count + 6*(x_count + 1) ] + 8; 
                                tmp_record[y_count + 6*(x_count + 1) + 1] <= store_color[y_count + 6*(x_count + 1) + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*(x_count + 1) - 1] < 6) tmp_record[y_count + 6*(x_count + 1) - 1] <= store_color[y_count + 6*(x_count + 1) - 1]; 
                                if (tmp_record[y_count + 6*(x_count + 1)    ] < 6) tmp_record[y_count + 6*(x_count + 1)]     <= store_color[y_count + 6*(x_count + 1)]; 
                                if (tmp_record[y_count + 6*(x_count + 1) + 1] < 6) tmp_record[y_count + 6*(x_count + 1) + 1] <= store_color[y_count + 6*(x_count + 1) + 1]; 
                            end
                        end
                        if ((store_color[y_count + 6*(x_count + 2) - 1] !== 15 ) & (store_color[y_count + 6*(x_count + 2)] !== 15) & (store_color[y_count + 6*(x_count + 2) +1] !== 15)) begin
                            if ((store_color[y_count + 6*(x_count + 2) - 1] == store_color[y_count + 6*(x_count + 2)]) & (store_color[y_count + 6*(x_count + 2) - 1] == store_color[y_count + 6*(x_count + 2) + 1]) & (store_color[y_count + 6*(x_count + 2)] == store_color[y_count + 6*(x_count + 2) + 1])) begin
                                tmp_record[y_count + 6*(x_count + 2) - 1] <= store_color[y_count + 6*(x_count + 2) - 1] + 8; 
                                tmp_record[y_count + 6*(x_count + 2)]     <= store_color[y_count + 6*(x_count + 2) ] + 8; 
                                tmp_record[y_count + 6*(x_count + 2) + 1] <= store_color[y_count + 6*(x_count + 2) + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*(x_count + 2) - 1] < 6) tmp_record[y_count + 6*(x_count + 2) - 1] <= store_color[y_count + 6*(x_count + 2) - 1]; 
                                if (tmp_record[y_count + 6*(x_count + 2)    ] < 6) tmp_record[y_count + 6*(x_count + 2)]     <= store_color[y_count + 6*(x_count + 2)]; 
                                if (tmp_record[y_count + 6*(x_count + 2) + 1] < 6) tmp_record[y_count + 6*(x_count + 2) + 1] <= store_color[y_count + 6*(x_count + 2) + 1]; 
                            end
                        end
                        if ((store_color[y_count + 6*(x_count + 3) - 1] !== 15 ) & (store_color[y_count + 6*(x_count + 3)] !== 15) & (store_color[y_count + 6*(x_count + 3) +1] !== 15)) begin
                            if ((store_color[y_count + 6*(x_count + 3) - 1] == store_color[y_count + 6*(x_count + 3)]) & (store_color[y_count + 6*(x_count + 3) - 1] == store_color[y_count + 6*(x_count + 3) + 1]) & (store_color[y_count + 6*(x_count + 3)] == store_color[y_count + 6*(x_count + 3) + 1])) begin
                                tmp_record[y_count + 6*(x_count + 3) - 1] <= store_color[y_count + 6*(x_count + 3) - 1] + 8; 
                                tmp_record[y_count + 6*(x_count + 3)]     <= store_color[y_count + 6*(x_count + 3) ] + 8; 
                                tmp_record[y_count + 6*(x_count + 3) + 1] <= store_color[y_count + 6*(x_count + 3) + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*(x_count + 3) - 1] < 6) tmp_record[y_count + 6*(x_count + 3) - 1] <= store_color[y_count + 6*(x_count + 3) - 1]; 
                                if (tmp_record[y_count + 6*(x_count + 3)    ] < 6) tmp_record[y_count + 6*(x_count + 3)]     <= store_color[y_count + 6*(x_count + 3)]; 
                                if (tmp_record[y_count + 6*(x_count + 3) + 1] < 6) tmp_record[y_count + 6*(x_count + 3) + 1] <= store_color[y_count + 6*(x_count + 3) + 1]; 
                            end
                        end
                        if ((store_color[y_count + 6*(x_count + 4) - 1] !== 15 ) & (store_color[y_count + 6*(x_count + 4)] !== 15) & (store_color[y_count + 6*(x_count + 4) +1] !== 15)) begin
                            if ((store_color[y_count + 6*(x_count + 4) - 1] == store_color[y_count + 6*(x_count + 4)]) & (store_color[y_count + 6*(x_count + 4) - 1] == store_color[y_count + 6*(x_count + 4) + 1]) & (store_color[y_count + 6*(x_count + 4)] == store_color[y_count + 6*(x_count + 4) + 1])) begin
                                tmp_record[y_count + 6*(x_count + 4) - 1] <= store_color[y_count + 6*(x_count + 4) - 1] + 8; 
                                tmp_record[y_count + 6*(x_count + 4)]     <= store_color[y_count + 6*(x_count + 4) ] + 8; 
                                tmp_record[y_count + 6*(x_count + 4) + 1] <= store_color[y_count + 6*(x_count + 4) + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*(x_count + 4) - 1] < 6) tmp_record[y_count + 6*(x_count + 4) - 1] <= store_color[y_count + 6*(x_count + 4) - 1]; 
                                if (tmp_record[y_count + 6*(x_count + 4)    ] < 6) tmp_record[y_count + 6*(x_count + 4)]     <= store_color[y_count + 6*(x_count + 4)]; 
                                if (tmp_record[y_count + 6*(x_count + 4) + 1] < 6) tmp_record[y_count + 6*(x_count + 4) + 1] <= store_color[y_count + 6*(x_count + 4) + 1]; 
                            end
                        end
                        if ((store_color[y_count + 6*(x_count + 5) - 1] !== 15 ) & (store_color[y_count + 6*(x_count + 5)] !== 15) & (store_color[y_count + 6*(x_count + 5) +1] !== 15)) begin
                            if ((store_color[y_count + 6*(x_count + 5) - 1] == store_color[y_count + 6*(x_count + 5)]) & (store_color[y_count + 6*(x_count + 5) - 1] == store_color[y_count + 6*(x_count + 5) + 1]) & (store_color[y_count + 6*(x_count + 5)] == store_color[y_count + 6*(x_count + 5) + 1])) begin
                                tmp_record[y_count + 6*(x_count + 5) - 1] <= store_color[y_count + 6*(x_count + 5) - 1] + 8; 
                                tmp_record[y_count + 6*(x_count + 5)]     <= store_color[y_count + 6*(x_count + 5) ] + 8; 
                                tmp_record[y_count + 6*(x_count + 5) + 1] <= store_color[y_count + 6*(x_count + 5) + 1] + 8; 
                            end
                            else begin
                                if (tmp_record[y_count + 6*(x_count + 5) - 1] < 6) tmp_record[y_count + 6*(x_count + 5) - 1] <= store_color[y_count + 6*(x_count + 5) - 1]; 
                                if (tmp_record[y_count + 6*(x_count + 5)    ] < 6) tmp_record[y_count + 6*(x_count + 5)]     <= store_color[y_count + 6*(x_count + 5)]; 
                                if (tmp_record[y_count + 6*(x_count + 5) + 1] < 6) tmp_record[y_count + 6*(x_count + 5) + 1] <= store_color[y_count + 6*(x_count + 5) + 1]; 
                            end
                        end

                        y_count <= y_count+1;
                    end 
                    else begin
                        x_count <= 6;
                        y_count <= 0;
                    end
                end
                CHECK_LINE_UD:begin
                        if (x_count < 30)begin
                            if ((store_color[x_count - 6] !== 15) & (store_color[x_count] !== 15) & (store_color[x_count + 6] !== 15)) begin 
                                if ((store_color[x_count - 6] == store_color[x_count]) & (store_color[x_count - 6] == store_color[x_count + 6]) & (store_color[x_count] == store_color[x_count + 6])) begin
                                    tmp_record[x_count - 6] <= tmp_record[x_count - 6] + 8; 
                                    tmp_record[x_count]     <= tmp_record[x_count] + 8; 
                                    tmp_record[x_count + 6] <= tmp_record[x_count + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[x_count - 6] <= tmp_record[x_count - 6];
                                    tmp_record[x_count]     <= tmp_record[x_count];
                                    tmp_record[x_count + 6] <= tmp_record[x_count + 6];
                                end
                            end

                            if ((store_color[(x_count+1) - 6] !== 15) & (store_color[(x_count+1)] !== 15) & (store_color[(x_count+1) + 6] !== 15)) begin 
                                if ((store_color[(x_count+1) - 6] == store_color[(x_count+1)]) & (store_color[(x_count+1) - 6] == store_color[(x_count+1) + 6]) & (store_color[(x_count+1)] == store_color[(x_count+1) + 6])) begin
                                    tmp_record[(x_count+1) - 6] <= tmp_record[(x_count+1) - 6] + 8; 
                                    tmp_record[(x_count+1)]     <= tmp_record[(x_count+1)] + 8; 
                                    tmp_record[(x_count+1) + 6] <= tmp_record[(x_count+1) + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[(x_count+1) - 6] <= tmp_record[(x_count+1) - 6];
                                    tmp_record[(x_count+1)]     <= tmp_record[(x_count+1)];
                                    tmp_record[(x_count+1) + 6] <= tmp_record[(x_count+1) + 6];
                                end
                            end

                            if ((store_color[(x_count+2) - 6] !== 15) & (store_color[(x_count+2)] !== 15) & (store_color[(x_count+2) + 6] !== 15)) begin
                                if ((store_color[(x_count+2) - 6] == store_color[(x_count+2)]) & (store_color[(x_count+2) - 6] == store_color[(x_count+2) + 6]) & (store_color[(x_count+2)] == store_color[(x_count+2) + 6])) begin
                                    tmp_record[(x_count+2) - 6] <= tmp_record[(x_count+2) - 6] + 8; 
                                    tmp_record[(x_count+2)]     <= tmp_record[(x_count+2)] + 8; 
                                    tmp_record[(x_count+2) + 6] <= tmp_record[(x_count+2) + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[(x_count+2) - 6] <= tmp_record[(x_count+2) - 6];
                                    tmp_record[(x_count+2)]     <= tmp_record[(x_count+2)];
                                    tmp_record[(x_count+2) + 6] <= tmp_record[(x_count+2) + 6];
                                end
                            end

                            if ((store_color[(x_count+3) - 6] !== 15) & (store_color[(x_count+3)] !== 15) & (store_color[(x_count+3) + 6] !== 15)) begin
                                if ((store_color[(x_count+3) - 6] == store_color[(x_count+3)]) & (store_color[(x_count+3) - 6] == store_color[(x_count+3) + 6]) & (store_color[(x_count+3)] == store_color[(x_count+3) + 6])) begin
                                    tmp_record[(x_count+3) - 6] <= tmp_record[(x_count+3) - 6] + 8; 
                                    tmp_record[(x_count+3)]     <= tmp_record[(x_count+3)] + 8; 
                                    tmp_record[(x_count+3) + 6] <= tmp_record[(x_count+3) + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[(x_count+3) - 6] <= tmp_record[(x_count+3) - 6];
                                    tmp_record[(x_count+3)]     <= tmp_record[(x_count+3)];
                                    tmp_record[(x_count+3) + 6] <= tmp_record[(x_count+3) + 6];
                                end
                            end

                            if ((store_color[(x_count+4) - 6] !== 15) & (store_color[(x_count+4)] !== 15) & (store_color[(x_count+4) + 6] !== 15)) begin
                                if ((store_color[(x_count+4) - 6] == store_color[(x_count+4)]) & (store_color[(x_count+4) - 6] == store_color[(x_count+4) + 6]) & (store_color[(x_count+4)] == store_color[(x_count+4) + 6])) begin
                                    tmp_record[(x_count+4) - 6] <= tmp_record[(x_count+4) - 6] + 8; 
                                    tmp_record[(x_count+4)]     <= tmp_record[(x_count+4)] + 8; 
                                    tmp_record[(x_count+4) + 6] <= tmp_record[(x_count+4) + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[(x_count+4) - 6] <= tmp_record[(x_count+4) - 6];
                                    tmp_record[(x_count+4)]     <= tmp_record[(x_count+4)];
                                    tmp_record[(x_count+4) + 6] <= tmp_record[(x_count+4) + 6];
                                end
                            end
                            
                            if ((store_color[(x_count+5) - 6] !== 15) & (store_color[(x_count+5)] !== 15) & (store_color[(x_count+5) + 6] !==15)) begin
                                if ((store_color[(x_count+5) - 6] == store_color[(x_count+5)]) & (store_color[(x_count+5) - 6] == store_color[(x_count+5) + 6]) & (store_color[(x_count+5)] == store_color[(x_count+5) + 6])) begin
                                    tmp_record[(x_count+5) - 6] <= tmp_record[(x_count+5) - 6] + 8; 
                                    tmp_record[(x_count+5)]     <= tmp_record[(x_count+5)] + 8; 
                                    tmp_record[(x_count+5) + 6] <= tmp_record[(x_count+5) + 6] + 8; 
                                end
                                else begin 
                                    tmp_record[(x_count+5) - 6] <= tmp_record[(x_count+5) - 6];
                                    tmp_record[(x_count+5)]     <= tmp_record[(x_count+5)];
                                    tmp_record[(x_count+5) + 6] <= tmp_record[(x_count+5) + 6];
                                end
                            end
                            x_count <= x_count + 6;
                        end
                end
                CHECK_STRIPE_CANDY:begin
                        if (y_count < 36)begin
                            if ((tmp_record[y_count] !== 15) & (tmp_record[y_count] > 7))begin
                              if (store_stripe[y_count] == 1)begin
                                tmp_record [(y_count/6)*6] <= 7;
                                tmp_record [(y_count/6)*6 + 1] <= 7;
                                tmp_record [(y_count/6)*6 + 2] <= 7;
                                tmp_record [(y_count/6)*6 + 3] <= 7;
                                tmp_record [(y_count/6)*6 + 4] <= 7;
                                tmp_record [(y_count/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[y_count] == 2)begin
                                tmp_record [y_count - (6*(y_count/6))] <= 7;
                                tmp_record [y_count - (6*(y_count/6)) + 6] <= 7;
                                tmp_record [y_count - (6*(y_count/6)) + 12] <= 7;
                                tmp_record [y_count - (6*(y_count/6)) + 18] <= 7;
                                tmp_record [y_count - (6*(y_count/6)) + 24] <= 7;
                                tmp_record [y_count - (6*(y_count/6)) + 30] <= 7;
                              end
                            end
                            
                            if ((tmp_record[(y_count + 1)] !== 15) & (tmp_record[(y_count + 1)] > 7))begin
                              if (store_stripe[(y_count + 1)] == 1)begin
                                tmp_record [((y_count + 1)/6)*6] <= 7;
                                tmp_record [((y_count + 1)/6)*6 + 1] <= 7;
                                tmp_record [((y_count + 1)/6)*6 + 2] <= 7;
                                tmp_record [((y_count + 1)/6)*6 + 3] <= 7;
                                tmp_record [((y_count + 1)/6)*6 + 4] <= 7;
                                tmp_record [((y_count + 1)/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[(y_count + 1)] == 2)begin
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6))] <= 7;
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6)) + 6] <= 7;
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6)) + 12] <= 7;
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6)) + 18] <= 7;
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6)) + 24] <= 7;
                                tmp_record [(y_count + 1) - (6*((y_count + 1)/6)) + 30] <= 7;
                              end
                            end

                            if ((tmp_record[(y_count + 2)] !== 15) & (tmp_record[(y_count + 2)] > 7))begin
                              if (store_stripe[(y_count + 2)] == 1)begin
                                tmp_record [((y_count + 2)/6)*6] <= 7;
                                tmp_record [((y_count + 2)/6)*6 + 1] <= 7;
                                tmp_record [((y_count + 2)/6)*6 + 2] <= 7;
                                tmp_record [((y_count + 2)/6)*6 + 3] <= 7;
                                tmp_record [((y_count + 2)/6)*6 + 4] <= 7;
                                tmp_record [((y_count + 2)/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[(y_count + 2)] == 2)begin
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6))] <= 7;
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6)) + 6] <= 7;
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6)) + 12] <= 7;
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6)) + 18] <= 7;
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6)) + 24] <= 7;
                                tmp_record [(y_count + 2) - (6*((y_count + 2)/6)) + 30] <= 7;
                              end
                            end

                            if ((tmp_record[(y_count + 3)] !== 15) & (tmp_record[(y_count + 3)] > 7))begin
                              if (store_stripe[(y_count + 3)] == 1)begin
                                tmp_record [((y_count + 3)/6)*6] <= 7;
                                tmp_record [((y_count + 3)/6)*6 + 1] <= 7;
                                tmp_record [((y_count + 3)/6)*6 + 2] <= 7;
                                tmp_record [((y_count + 3)/6)*6 + 3] <= 7;
                                tmp_record [((y_count + 3)/6)*6 + 4] <= 7;
                                tmp_record [((y_count + 3)/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[(y_count + 3)] == 2)begin
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6))] <= 7;
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6)) + 6] <= 7;
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6)) + 12] <= 7;
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6)) + 18] <= 7;
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6)) + 24] <= 7;
                                tmp_record [(y_count + 3) - (6*((y_count + 3)/6)) + 30] <= 7;
                              end
                            end
                            
                            if ((tmp_record[(y_count + 4)] !== 15) & (tmp_record[(y_count + 4)] > 7))begin
                              if (store_stripe[(y_count + 4)] == 1)begin
                                tmp_record [((y_count + 4)/6)*6] <= 7;
                                tmp_record [((y_count + 4)/6)*6 + 1] <= 7;
                                tmp_record [((y_count + 4)/6)*6 + 2] <= 7;
                                tmp_record [((y_count + 4)/6)*6 + 3] <= 7;
                                tmp_record [((y_count + 4)/6)*6 + 4] <= 7;
                                tmp_record [((y_count + 4)/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[(y_count + 4)] == 2)begin
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6))] <= 7;
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6)) + 6] <= 7;
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6)) + 12] <= 7;
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6)) + 18] <= 7;
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6)) + 24] <= 7;
                                tmp_record [(y_count + 4) - (6*((y_count + 4)/6)) + 30] <= 7;
                              end
                            end

                            if ((tmp_record[(y_count + 5)] !== 15) & (tmp_record[(y_count + 5)] > 7))begin
                              if (store_stripe[(y_count + 5)] == 1)begin
                                tmp_record [((y_count + 5)/6)*6] <= 7;
                                tmp_record [((y_count + 5)/6)*6 + 1] <= 7;
                                tmp_record [((y_count + 5)/6)*6 + 2] <= 7;
                                tmp_record [((y_count + 5)/6)*6 + 3] <= 7;
                                tmp_record [((y_count + 5)/6)*6 + 4] <= 7;
                                tmp_record [((y_count + 5)/6)*6 + 5] <= 7;
                              end
                              else if (store_stripe[(y_count + 5)] == 2)begin
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6))] <= 7;
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6)) + 6] <= 7;
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6)) + 12] <= 7;
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6)) + 18] <= 7;
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6)) + 24] <= 7;
                                tmp_record [(y_count + 5) - (6*((y_count + 5)/6)) + 30] <= 7;
                              end
                            end

                            y_count <= y_count + 6;
                        end
                end
                SCORE:begin
                    if (action_count < 11)begin
                        if (score_count < 18)begin
                            if ((tmp_record[score_count] > 6) & (tmp_record[score_count] < 15)) begin
                                if ((tmp_record[(score_count) - 1] == tmp_record[(score_count) + 1]) & (tmp_record[(score_count)] == tmp_record[(score_count) + 1]) & (tmp_record[(score_count)] == tmp_record[(score_count) - 1])) begin //正常的左右3連
                                    tmp_score_1 <= tmp_score_1 + 1;
                                end
                                if ((tmp_record[(score_count) - 6] == tmp_record[(score_count) + 6]) & (tmp_record[(score_count)] == tmp_record[(score_count) + 6]) & (tmp_record[(score_count)] == tmp_record[(score_count) - 6])) begin //正常的左右3連
                                    tmp_score_1 <= tmp_score_1 + 1;
                                end

                                if((tmp_record[score_count - 1] == 7) & (tmp_record[score_count] == tmp_record[score_count + 1]))begin //左為7的3連
                                    if (store_color[score_count - 1] == (tmp_record[score_count] - 8)) tmp_score_1 <= tmp_score_1 + 1;
                                end
                                else if ((tmp_record[score_count - 1] == tmp_record[score_count]) & (tmp_record[score_count + 1]==7)) begin //右為7的3連
                                    if (store_color[score_count + 1] == (tmp_record[score_count] - 8)) tmp_score_1 <= tmp_score_1 + 1;
                                end
                                else if((tmp_record[score_count - 6] == 7) & (tmp_record[score_count] == tmp_record[score_count + 6]))begin //上為7的3連
                                    if (store_color[score_count - 6] == (tmp_record[score_count] - 8)) tmp_score_1 <= tmp_score_1 + 1;
                                end
                                else if ((tmp_record[score_count - 6] == tmp_record[score_count]) & (tmp_record[score_count + 6]==7)) begin //下為7的3連
                                    if (store_color[score_count + 6] == (tmp_record[score_count] - 8)) tmp_score_1 <= tmp_score_1 + 1;
                                end
                                else if (tmp_record[score_count] == 7) tmp_score_1 <= tmp_score_1 + 1;
                                
                            end

                            if ((tmp_record[(score_count+18)] > 6) & (tmp_record[score_count+18] < 15)) begin
                                if ((tmp_record[(score_count+18) - 1] == tmp_record[(score_count+18) + 1]) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) + 1]) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) - 1])) begin //正常的左右3連
                                    tmp_score_2 <= tmp_score_2 + 1;
                                end
                                if ((tmp_record[(score_count+18) - 6] == tmp_record[(score_count+18) + 6]) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) + 6]) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) - 6])) begin //正常的左右3連
                                    tmp_score_2 <= tmp_score_2 + 1;
                                end
                                
                                if((tmp_record[(score_count+18) - 1] == 7) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) + 1]))begin //左為7的3連
                                    if (store_color[(score_count+18) - 1] == (tmp_record[(score_count+18)] - 8)) tmp_score_2 <= tmp_score_2 + 1;
                                end
                                else if ((tmp_record[(score_count+18) - 1] == tmp_record[(score_count+18)]) & (tmp_record[(score_count+18) + 1]==7)) begin //右為7的3連
                                    if (store_color[(score_count+18) + 1] == (tmp_record[(score_count+18)] - 8)) tmp_score_2 <= tmp_score_2 + 1;
                                end
                                else if((tmp_record[(score_count+18) - 6] == 7) & (tmp_record[(score_count+18)] == tmp_record[(score_count+18) + 6]))begin //上為7的3連
                                    if (store_color[(score_count+18) - 6] == (tmp_record[(score_count+18)] - 8)) tmp_score_2 <= tmp_score_2 + 1;
                                end
                                else if ((tmp_record[(score_count+18) - 6] == tmp_record[(score_count+18)]) & (tmp_record[(score_count+18) + 6]==7)) begin //下為7的3連
                                    if (store_color[(score_count+18) + 6] == (tmp_record[(score_count+18)] - 8)) tmp_score_2 <= tmp_score_2 + 1;
                                end
                                else if (tmp_record[score_count+18] == 7) tmp_score_2 <= tmp_score_2 + 1;
                            end
                            
                            tmp_score_3 <= tmp_score_3 + (tmp_record[score_count]==7 & store_stripe[score_count]>0) + (tmp_record[score_count]==7 & store_stripe[score_count]>0);
                            tmp_score <= tmp_score_1 + tmp_score_2 - tmp_score_3;
                            score_count <= score_count + 1;
                        end
                        else begin
                            for (i=0; i<36; i=i+1)begin
                               if (tmp_record[i] > 6) store_color[i] <= 15; 
                            end
                            if (score_count == 18) begin
                                    re_bulid <= 0;
                                    start <= 0;
                                    out_score <= tmp_score;  
                                    score_count <= 0;
                            end                        
                        end
                    end
                end
                ACTION:begin
                    if (action_count < 10) begin
                        action_count <= action_count + 1;
                        case(stort_action[action_count]) 
                            2'b00: //上
                                if ((stort_action_pos[action_count] > 5) & (store_color[(stort_action_pos[action_count])] !== 15)) begin
                                    if ((stort_action_pos[action_count]) > 0)begin
                                        store_stripe[(stort_action_pos[action_count])] <= store_stripe[(stort_action_pos[action_count])-6];
                                        store_stripe[(stort_action_pos[action_count])-6] <= store_stripe[(stort_action_pos[action_count])];
                                    end
                                    store_color[(stort_action_pos[action_count])] <= store_color[(stort_action_pos[action_count]) - 6];
                                    store_color[(stort_action_pos[action_count]) - 6] <= store_color[(stort_action_pos[action_count])];
                                end
                            2'b01: //下
                                if ((stort_action_pos[action_count] < 30) & (store_color[(stort_action_pos[action_count])] !== 15)) begin
                                    if ((stort_action_pos[action_count]) > 0)begin
                                        store_stripe[(stort_action_pos[action_count])] <= store_stripe[(stort_action_pos[action_count])+6];
                                        store_stripe[(stort_action_pos[action_count])+ 6] <= store_stripe[(stort_action_pos[action_count])];
                                    end
                                    store_color[(stort_action_pos[action_count])] <= store_color[(stort_action_pos[action_count]) + 6];
                                    store_color[(stort_action_pos[action_count]) + 6] <= store_color[(stort_action_pos[action_count])];
                                end
                            2'b10: //左
                                if ((stort_action_pos[action_count] - 6*(stort_action_pos[action_count]/6) !== 0) & (store_color[(stort_action_pos[action_count])] !== 15)) begin
                                    if ((stort_action_pos[action_count]) > 0)begin
                                        store_stripe[(stort_action_pos[action_count])] <= store_stripe[(stort_action_pos[action_count])-1];
                                        store_stripe[(stort_action_pos[action_count])- 1] <= store_stripe[(stort_action_pos[action_count])];
                                    end
                                    store_color[(stort_action_pos[action_count])] <= store_color[(stort_action_pos[action_count]) - 1];
                                    store_color[(stort_action_pos[action_count]) - 1] <= store_color[(stort_action_pos[action_count])];
                                end
                            2'b11: //右
                                if ((stort_action_pos[action_count] - 6*(stort_action_pos[action_count]/6) !== 5) & (store_color[(stort_action_pos[action_count])] !== 15)) begin
                                    if ((stort_action_pos[action_count]) > 0)begin
                                        store_stripe[(stort_action_pos[action_count])] <= store_stripe[(stort_action_pos[action_count])+1];
                                        store_stripe[(stort_action_pos[action_count])+ 1] <= store_stripe[(stort_action_pos[action_count])];
                                    end
                                    store_color[(stort_action_pos[action_count])] <= store_color[(stort_action_pos[action_count]) + 1];
                                    store_color[(stort_action_pos[action_count]) + 1] <= store_color[(stort_action_pos[action_count])];
                                end

                        endcase
                        for (i=0; i<36; i=i+1)begin
                            tmp_record[i] <= store_color[i];
                        end
                        x_count <= 0;
                        y_count <= 1;
                    end
                end
                FINAL: begin
                    out_valid <= 1;
                    out_score <= tmp_score; 
                    
                end
            endcase
        end
    end
endmodule