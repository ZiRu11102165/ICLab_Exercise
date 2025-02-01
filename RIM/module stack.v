module stack 
#(
parameter data_size = 32,
parameter capacity = 8
)
(
input [data_size-1:0] data_in,
input push,pop,
output reg [data_size-1:0] data_out, 
output ok_flag
);
parameter IDLE = 2'b00,
          RW   = 2'b01,
          DONE = 2'b10;
always@* begin
    case()
    IDLE:
        
    endcase
end