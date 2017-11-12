module T_FF(Q, T, clk, rst);
output Q;
input  T, clk, rst;
reg    Q;
always @(posedge rst or negedge clk)
  if(rst)
    Q = 0;
  else
    Q <= (T) ? ~Q : Q;
endmodule 

