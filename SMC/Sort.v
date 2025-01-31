`timescale 1ns / 1ps

module Sort(output reg [9:0]n0,
            output reg [9:0]n1,
            output reg [9:0]n2,
            output reg [9:0]n3,
            output reg [9:0]n4,
            output reg [9:0]n5,
            input [9:0]Clac_out0,
            input [9:0]Clac_out1,
            input [9:0]Clac_out2,
            input [9:0]Clac_out3,
            input [9:0]Clac_out4,
            input [9:0]Clac_out5);
    integer i;
    reg [2:0]count;
    reg [9:0] tmp_n0, tmp_n1, tmp_n2, tmp_n3, tmp_n4, tmp_n5, tmp;

    always @(*) begin  
        tmp = 0;
        tmp_n0 = Clac_out0;
        tmp_n1 = Clac_out1;
        tmp_n2 = Clac_out2;
        tmp_n3 = Clac_out3;
        tmp_n4 = Clac_out4;
        tmp_n5 = Clac_out5;

        for (i = 0; i < 6; i = i + 1)begin
            count = i;
            if (count[0] == 0) begin
                if (tmp_n0 >= tmp_n1) begin
                    tmp_n0 = tmp_n0;
                    tmp_n1 = tmp_n1;
                end
                else begin
                    tmp = tmp_n0;
                    tmp_n0 = tmp_n1;
                    tmp_n1 = tmp;
                end

                if (tmp_n2 >= tmp_n3) begin
                    tmp_n2 = tmp_n2;
                    tmp_n3 = tmp_n3;
                end
                else begin
                    tmp = tmp_n2;
                    tmp_n2 = tmp_n3;
                    tmp_n3 = tmp;
                end

                if (tmp_n4 >= tmp_n5) begin
                    tmp_n4 = tmp_n4;
                    tmp_n5 = tmp_n5;
                end
                else begin
                    tmp = tmp_n4;
                    tmp_n4 = tmp_n5;
                    tmp_n5 = tmp;
                end
            end
            else begin
                if (tmp_n1 >= tmp_n2) begin
                    tmp_n1 = tmp_n1;
                    tmp_n2 = tmp_n2;
                end
                else begin
                    tmp = tmp_n1;
                    tmp_n1 = tmp_n2;
                    tmp_n2 = tmp;
                end
                if (tmp_n3 >= tmp_n4) begin
                    tmp_n3 = tmp_n3;
                    tmp_n4 = tmp_n4;
                end
                else begin
                    tmp = tmp_n3;
                    tmp_n3 = tmp_n4;
                    tmp_n4 = tmp;
                end
            end
            count = count + 1;
            // $display("tmp_n0 = %d, tmp_n1 = %d, tmp_n2 = %d, tmp_n3 = %d, tmp_n4 = %d, tmp_n5 = %d", tmp_n0, tmp_n1, tmp_n2, tmp_n3, tmp_n4, tmp_n5);
        end
        n0 = tmp_n0;
        n1 = tmp_n1;
        n2 = tmp_n2;
        n3 = tmp_n3;
        n4 = tmp_n4;
        n5 = tmp_n5;

    end
endmodule
