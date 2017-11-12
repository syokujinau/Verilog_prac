module D_FF(q, d, clk, rst);
output q;
input  d, clk, rst;
reg    q;
always @(posedge clk) //正緣觸發,同步active high reset
    if(rst)
        q <= 1'b0;
    else
        q <= d;
endmodule 

