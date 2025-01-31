//~ `New testbench
`timescale  1ns / 1ps
`include "SMC.v"
module tb_SMC;


// SMC Inputs
reg   [1:0]  mode                          = 0 ;
reg   [2:0]  Vgs0                          = 0 ;
reg   [2:0]  Vgs1                          = 0 ;
reg   [2:0]  Vgs2                          = 0 ;
reg   [2:0]  Vgs3                          = 0 ;
reg   [2:0]  Vgs4                          = 0 ;
reg   [2:0]  Vgs5                          = 0 ;
reg   [2:0]  Vds0                          = 0 ;
reg   [2:0]  Vds1                          = 0 ;
reg   [2:0]  Vds2                          = 0 ;
reg   [2:0]  Vds3                          = 0 ;
reg   [2:0]  Vds4                          = 0 ;
reg   [2:0]  Vds5                          = 0 ;
reg   [2:0]  W0                            = 0 ;
reg   [2:0]  W1                            = 0 ;
reg   [2:0]  W2                            = 0 ;
reg   [2:0]  W3                            = 0 ;
reg   [2:0]  W4                            = 0 ;
reg   [2:0]  W5                            = 0 ;

// SMC Outputs
wire  [9:0]  out                           ;
reg [66:0] pattern [0:99];
reg [66:0] p;
reg [9:0] gt; 
integer i, error;


SMC  u_SMC (
    .mode                    ( mode  [1:0] ),
    .Vgs0                    ( Vgs0  [2:0] ),
    .Vgs1                    ( Vgs1  [2:0] ),
    .Vgs2                    ( Vgs2  [2:0] ),
    .Vgs3                    ( Vgs3  [2:0] ),
    .Vgs4                    ( Vgs4  [2:0] ),
    .Vgs5                    ( Vgs5  [2:0] ),
    .Vds0                    ( Vds0  [2:0] ),
    .Vds1                    ( Vds1  [2:0] ),
    .Vds2                    ( Vds2  [2:0] ),
    .Vds3                    ( Vds3  [2:0] ),
    .Vds4                    ( Vds4  [2:0] ),
    .Vds5                    ( Vds5  [2:0] ),
    .W0                      ( W0    [2:0] ),
    .W1                      ( W1    [2:0] ),
    .W2                      ( W2    [2:0] ),
    .W3                      ( W3    [2:0] ),
    .W4                      ( W4    [2:0] ),
    .W5                      ( W5    [2:0] ),

    .out                     ( out   [9:0] )
);

initial
begin
    $readmemb("Pattern.dat", pattern);
    error = 0;
    #10
    for (i=1; i<100; i = i+1) begin
        p = pattern[i];
        #10
        mode = p[65:64];
        Vgs0 = p[63:61]; Vgs1 = p[60:58]; Vgs2 = p[57:55]; Vgs3 = p[54:52]; Vgs4 = p[51:49]; Vgs5 = p[48:46]; 
        Vds0 = p[45:43]; Vds1 = p[42:40]; Vds2 = p[39:37]; Vds3 = p[36:34]; Vds4 = p[33:31]; Vds5 = p[30:28]; 
        W0 = p[27:25]; W1 = p[24:22]; W2 = p[21:19]; W3 = p[18:16]; W4 = p[15:13]; W5 = p[12:10];
        gt = p[9:0];
        
        #10
        $display("mode = %d", mode);
        #10
        if (out !== gt) begin
            $write("ERROR: out %d != gt %d\n", out, gt);
            error = error + 1;
        end
    end
    $write("Error Count: %d / %d\n", error, i-1);
    $finish;
end

endmodule